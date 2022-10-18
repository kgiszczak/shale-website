require 'shale'

class Person < Shale::Mapper
  attribute :first_name, Shale::Type::String
  attribute :last_name, Shale::Type::String
end

records = [
  Person.new(first_name: 'John', last_name: 'Doe'),
  Person.new(first_name: 'James', last_name: 'Sixpack'),
]
puts Person.to_yaml(records)
