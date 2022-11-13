require 'shale'

class Address < Shale::Mapper
  attribute :city, Shale::Type::String
  attribute :street, Shale::Type::String
end

class Person < Shale::Mapper
  attribute :name, Shale::Type::String
  attribute :address, Address

  csv do
    map 'name', to: :name
    map 'city', to: :city, receiver: :address
    map 'street', to: :street, receiver: :address
  end
end

person = Person.from_csv(<<~DATA)
John Doe,London,Oxford Street
DATA

pp person
