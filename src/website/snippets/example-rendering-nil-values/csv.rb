require 'shale'

class Person < Shale::Mapper
  attribute :first_name, Shale::Type::String
  attribute :last_name, Shale::Type::String
  attribute :age, Shale::Type::Integer

  csv do
    map 'first_name', to: :first_name
    map 'last_name', to: :last_name
    map 'age', to: :age, render_nil: false
  end
end

puts Person.new(
  first_name: nil,
  last_name: nil,
  age: nil
).to_csv
