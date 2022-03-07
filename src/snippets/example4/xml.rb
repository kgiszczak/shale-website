require 'shale'

class Person < Shale::Mapper
  attribute :name, Shale::Type::String
  attribute :age, Shale::Type::Integer
  attribute :hobbies, Shale::Type::String, collection: true

  xml do
    root 'Person'

    map_content to: :name
    map_attribute 'age', to: :age
    map_element 'Hobby', to: :hobbies
  end
end

person = Person.new(
  name: 'John Doe',
  age: 44,
  hobbies: ['Singing', 'Dancing'],
)

puts person.to_xml
