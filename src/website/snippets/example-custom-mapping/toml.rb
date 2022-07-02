require 'shale'

class Person < Shale::Mapper
  attribute :first_name, Shale::Type::String
  attribute :last_name, Shale::Type::String

  toml do
    map 'firstName', to: :first_name
    map 'lastName', to: :last_name
  end
end

person = Person.new(
  first_name: 'John',
  last_name: 'Doe',
)

puts person.to_toml
