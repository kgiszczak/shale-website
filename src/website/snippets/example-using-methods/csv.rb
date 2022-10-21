require 'shale'

class Address < Shale::Mapper
  attribute :street, Shale::Type::String
  attribute :city, Shale::Type::String
end

class Person < Shale::Mapper
  attribute :name, Shale::Type::String
  attribute :address, Address, default: -> { Address.new }

  csv do
    map 'name', to: :name
    map 'street', using: { from: :street_from_csv, to: :street_to_csv }
    map 'city', using: { from: :city_from_csv, to: :city_to_csv }
  end

  def street_from_csv(model, value)
    model.address.street = value
  end

  def street_to_csv(model, doc)
    doc['street'] = model.address.street
  end

  def city_from_csv(model, value)
    model.address.city = value
  end

  def city_to_csv(model, doc)
    doc['city'] = model.address.city
  end
end

person = Person.from_csv(<<~DATA)
John Doe,Oxford Street,London
DATA

pp person
