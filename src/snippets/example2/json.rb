require 'shale'

class Address < Shale::Mapper
  attribute :city, Shale::Type::String
  attribute :street, Shale::Type::String
  attribute :zip, Shale::Type::String
end

class Person < Shale::Mapper
  attribute :first_name, Shale::Type::String
  attribute :last_name, Shale::Type::String
  attribute :age, Shale::Type::Date
  attribute :married, Shale::Type::Boolean, default: -> { false }
  attribute :hobbies, Shale::Type::String, collection: true
  attribute :address, Address
end

person = Person.new(
  first_name: 'John',
  last_name: 'Doe',
  age: 50,
  hobbies: ['Singing', 'Dancing'],
  address: Address.new(
    city: 'London',
    street: 'Oxford Street',
    zip: 'E1 6AN',
  ),
)

puts person.to_json
