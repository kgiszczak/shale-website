require 'shale'

class Person < Shale::Mapper
  attribute :first_name, Shale::Type::String
  attribute :last_name, Shale::Type::String
  attribute :age, Shale::Type::Integer
  attribute :married, Shale::Type::Boolean, default: -> { false }
end

person = Person.new(
  first_name: 'John',
  last_name: 'Doe',
  age: 50,
)

puts person.to_csv
