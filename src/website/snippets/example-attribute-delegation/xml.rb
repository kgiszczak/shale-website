require 'shale'

class Address < Shale::Mapper
  attribute :city, Shale::Type::String
  attribute :street, Shale::Type::String
end

class Person < Shale::Mapper
  attribute :name, Shale::Type::String
  attribute :address, Address

  xml do
    root 'person'
    map_element 'name', to: :name
    map_element 'city', to: :city, receiver: :address
    map_element 'street', to: :street, receiver: :address
  end
end

person = Person.from_xml(<<~DATA)
<person>
  <name>John Doe</name>
  <city>London</city>
  <street>Oxford Street</street>
</person>
DATA

pp person
