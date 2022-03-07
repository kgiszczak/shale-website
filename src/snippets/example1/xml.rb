require 'shale'

class Address < Shale::Mapper
  attribute :city, Shale::Type::String
  attribute :street, Shale::Type::String
  attribute :zip, Shale::Type::String
end

class Person < Shale::Mapper
  attribute :first_name, Shale::Type::String
  attribute :last_name, Shale::Type::String
  attribute :age, Shale::Type::Integer
  attribute :married, Shale::Type::Boolean, default: -> { false }
  attribute :hobbies, Shale::Type::String, collection: true
  attribute :address, Address
end

pp Person.from_xml(<<~XML)
<person>
  <first_name>John</first_name>
  <last_name>Doe</last_name>
  <age>50</age>
  <married>false</married>
  <hobbies>Singing</hobbies>
  <hobbies>Dancing</hobbies>
  <address>
    <city>London</city>
    <street>Oxford Street</street>
    <zip>E1 6AN</zip>
  </address>
</person>
XML
