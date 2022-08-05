require 'shale'

class Person < Shale::Mapper
  attribute :first_name, Shale::Type::String
  attribute :last_name, Shale::Type::String
  attribute :age, Shale::Type::Integer

  xml do
    root 'person'

    map_element 'first_name', to: :first_name, render_nil: true
    map_element 'last_name', to: :last_name, render_nil: false
    map_attribute 'age', to: :age, render_nil: true
  end
end

puts Person.new(
  first_name: nil,
  last_name: nil,
  age: nil
).to_xml(:pretty)
