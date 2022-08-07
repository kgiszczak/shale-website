require 'shale'

class Address < Shale::Mapper
  attribute :city, Shale::Type::String
  attribute :street, Shale::Type::String
end

class Person < Shale::Mapper
  attribute :first_name, Shale::Type::String
  attribute :last_name, Shale::Type::String
  attribute :address, Address
end

person = Person.new(
  first_name: 'John',
  last_name: 'Doe',
  address: Address.new(
    city: 'London',
    street: 'Oxford Street',
  ),
)

puts person.to_json(only: [:first_name, address: [:city]], pretty: true)
