require 'shale'
require 'shale/schema'

class Address < Shale::Mapper
  attribute :city, Shale::Type::String
end

class Person < Shale::Mapper
  attribute :name, Shale::Type::String
  attribute :address, Address
end

puts Shale::Schema.to_json(
  Person,
  id: 'http://foo.bar/schema/person',
  description: 'My description',
  pretty: true
)
