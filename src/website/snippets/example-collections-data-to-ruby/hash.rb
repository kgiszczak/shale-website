require 'shale'

class Person < Shale::Mapper
  attribute :first_name, Shale::Type::String
  attribute :last_name, Shale::Type::String
end

pp Person.from_hash([
  {
    'first_name' => 'John',
    'last_name' => 'Doe',
  },
  {
    'first_name' => 'James',
    'last_name' => 'Sixpack',
  }
])
JSON
