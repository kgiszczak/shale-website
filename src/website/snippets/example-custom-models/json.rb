require 'shale'

class Address
  attr_accessor :street, :city
end

class Person
  attr_accessor :first_name, :last_name, :address
end

class AddressMapper < Shale::Mapper
  model Address

  attribute :street, Shale::Type::String
  attribute :city, Shale::Type::String
end

class PersonMapper < Shale::Mapper
  model Person

  attribute :first_name, Shale::Type::String
  attribute :last_name, Shale::Type::String
  attribute :address, AddressMapper
end

address = Address.new
address.street = 'Oxford Street'
address.city = 'London'

person = Person.new
person.first_name = 'John'
person.last_name = 'Doe'
person.address = address

puts PersonMapper.to_json(person, :pretty)
