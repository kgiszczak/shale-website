require 'shale'

class Person < Shale::Mapper
  attribute :name, Shale::Type::String

  xml do
    root 'person'

    group from: :name_from_xml, to: :name_to_xml do
      map_content
      map_attribute 'prefix'
      map_element 'last_name'
    end
  end

  def name_from_xml(model, value)
    prefix = value[:attributes]['prefix']
    first_name = value[:content].text
    last_name = value[:elements]['last_name'].text
    model.name = [prefix, first_name, last_name].join(' ')
  end

  def name_to_xml(model, element, doc)
    prefix, first_name, last_name = model.name.split(' ')
    doc.add_attribute(element, 'prefix', prefix)
    doc.add_text(element, first_name)

    child = doc.create_element('last_name')
    doc.add_text(child, last_name)
    doc.add_element(element, child)
  end
end

person = Person.from_xml(<<~DATA)
<person prefix="Mr.">
  John
  <last_name>Doe</last_name>
</person>
DATA

pp person
