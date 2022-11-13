require 'shale'

class Address < Shale::Mapper
  attribute :city, Shale::Type::String
  attribute :street, Shale::Type::String
end

class Person < Shale::Mapper
  attribute :name, Shale::Type::String
  attribute :address, Address

  toml do
    map 'name', to: :name
    map 'city', to: :city, receiver: :address
    map 'street', to: :street, receiver: :address
  end
end

person = Person.from_toml(<<~DATA)
name = "John Doe"
city = "London"
street = "Oxford Street"
DATA

pp person
