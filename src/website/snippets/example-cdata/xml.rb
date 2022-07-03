require 'shale'

class Address < Shale::Mapper
  attribute :content, Shale::Type::String

  xml do
    map_content to: :content, cdata: true
  end
end

class Person < Shale::Mapper
  attribute :first_name, Shale::Type::String
  attribute :address, Address

  xml do
    root 'Person'

    map_element 'FirstName', to: :first_name, cdata: true
    map_element 'Address', to: :address
  end
end

puts Person.new(
  first_name: 'John',
  address: Address.new(content: 'Oxford Street')
).to_xml(:pretty)
