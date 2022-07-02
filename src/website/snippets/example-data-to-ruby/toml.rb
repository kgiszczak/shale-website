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

pp Person.from_toml(<<~TOML)
first_name = "John"
last_name = "Doe"
age = 50
married = false
hobbies = ["Singing", "Dancing"]
[address]
city = "London"
street = "Oxford Street"
zip = "E1 6AN"
TOML
