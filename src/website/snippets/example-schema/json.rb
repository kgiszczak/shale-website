require 'shale'

class Address < Shale::Mapper
  attribute :city, Shale::Type::String
end

class Person < Shale::Mapper
  attribute :name, Shale::Type::String
  attribute :address, Address
end

puts Shale.schema.to_json(
  Person,
  id: 'My ID',
  description: 'My description',
  pretty: true
)
