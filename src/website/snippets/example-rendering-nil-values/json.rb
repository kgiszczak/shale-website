require 'shale'

class Person < Shale::Mapper
  attribute :first_name, Shale::Type::String
  attribute :last_name, Shale::Type::String
  attribute :age, Shale::Type::Integer

  json do
    map 'first_name', to: :first_name, render_nil: true
    map 'last_name', to: :last_name, render_nil: false
    map 'age', to: :age, render_nil: true
  end
end

puts Person.new(
  first_name: nil,
  last_name: nil,
  age: nil
).to_json(pretty: true)
