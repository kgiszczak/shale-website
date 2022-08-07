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

data = <<~JSON
{
  "first_name": "John",
  "last_name": "Doe",
  "address": {
    "city": "London",
    "street": "Oxford Street"
  }
}
JSON

pp Person.from_json(data, only: [:first_name, address: [:city]])
