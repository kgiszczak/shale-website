require 'shale'

class Person < Shale::Mapper
  attribute :hobbies, Shale::Type::String, collection: true
  attribute :street, Shale::Type::String
  attribute :city, Shale::Type::String

  yaml do
    map 'hobbies', using: { from: :hobbies_from_yaml, to: :hobbies_to_yaml }
    map 'address', using: { from: :address_from_yaml, to: :address_to_yaml }
  end

  def hobbies_from_yaml(value)
    self.hobbies = value.split(',').map(&:strip)
  end

  def hobbies_to_yaml
    hobbies.join(', ')
  end

  def address_from_yaml(value)
    self.street = value['street']
    self.city = value['city']
  end

  def address_to_yaml
    { 'street' => street, 'city' => city }
  end
end

person = Person.from_yaml(<<~DATA)
hobbies: Singing, Dancing, Running
address:
  street: Oxford Street
  city: London
DATA

pp person
