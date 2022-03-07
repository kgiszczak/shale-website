require 'shale'

class Person < Shale::Mapper
  attribute :hobbies, Shale::Type::String, collection: true
  attribute :street, Shale::Type::String
  attribute :city, Shale::Type::String

  json do
    map 'hobbies', using: { from: :hobbies_from_json, to: :hobbies_to_json }
    map 'address', using: { from: :address_from_json, to: :address_to_json }
  end

  def hobbies_from_json(value)
    self.hobbies = value.split(',').map(&:strip)
  end

  def hobbies_to_json
    hobbies.join(', ')
  end

  def address_from_json(value)
    self.street = value['street']
    self.city = value['city']
  end

  def address_to_json
    { 'street' => street, 'city' => city }
  end
end

person = Person.from_json(<<~DATA)
{
  "hobbies": "Singing, Dancing, Running",
  "address": {
    "street": "Oxford Street",
    "city": "London"
  }
}
DATA

pp person
