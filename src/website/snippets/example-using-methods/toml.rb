require 'shale'

class Person < Shale::Mapper
  attribute :hobbies, Shale::Type::String, collection: true
  attribute :street, Shale::Type::String
  attribute :city, Shale::Type::String

  toml do
    map 'hobbies', using: { from: :hobbies_from_toml, to: :hobbies_to_toml }
    map 'address', using: { from: :address_from_toml, to: :address_to_toml }
  end

  def hobbies_from_toml(model, value)
    model.hobbies = value.split(',').map(&:strip)
  end

  def hobbies_to_toml(model, doc)
    doc['hobbies'] = model.hobbies.join(', ')
  end

  def address_from_toml(model, value)
    model.street = value['street']
    model.city = value['city']
  end

  def address_to_toml(model, doc)
    doc['address'] = { 'street' => model.street, 'city' => model.city }
  end
end

person = Person.from_toml(<<~DATA)
hobbies = "Singing, Dancing, Running"
[address]
street = "Oxford Street"
city = "London"
DATA

pp person
