require 'shale'

class Base < Shale::Mapper
  json do
    render_nil true
  end
end

class Person < Base
  attribute :first_name, Shale::Type::String
  attribute :last_name, Shale::Type::String
  attribute :age, Shale::Type::Integer

  json do
    map 'first_name', to: :first_name
    map 'last_name', to: :last_name
    map 'age', to: :age
  end
end

puts Person.new(
  first_name: nil,
  last_name: nil,
  age: nil
).to_json(pretty: true)
