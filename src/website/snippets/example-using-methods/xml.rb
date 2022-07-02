require 'shale'

class Person < Shale::Mapper
  attribute :hobbies, Shale::Type::String, collection: true
  attribute :street, Shale::Type::String
  attribute :city, Shale::Type::String

  xml do
    root 'Person'

    map_attribute 'hobbies', using: {
      from: :hobbies_from_xml,
      to: :hobbies_to_xml,
    }

    map_element 'Address', using: {
      from: :address_from_xml,
      to: :address_to_xml,
    }
  end

  def hobbies_from_xml(model, value)
    model.hobbies = value.split(',').map(&:strip)
  end

  def hobbies_to_xml(model, element, doc)
    doc.add_attribute(element, 'hobbies', model.hobbies.join(', '))
  end

  def address_from_xml(model, node)
    model.street = node.children.find { |e| e.name == 'Street' }.text
    model.city = node.children.find { |e| e.name == 'City' }.text
  end

  def address_to_xml(model, parent, doc)
    street_element = doc.create_element('Street')
    doc.add_text(street_element, model.street.to_s)

    city_element = doc.create_element('City')
    doc.add_text(city_element, model.city.to_s)

    address_element = doc.create_element('Address')
    doc.add_element(address_element, street_element)
    doc.add_element(address_element, city_element)
    doc.add_element(parent, address_element)
  end
end

person = Person.from_xml(<<~DATA)
<Person hobbies="Singing, Dancing, Running">
  <Address>
    <Street>Oxford Street</Street>
    <City>London</City>
  </Address>
</person>
DATA

pp person
