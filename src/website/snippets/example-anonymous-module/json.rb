require 'shale'

class Person < Shale::Mapper
  attribute :name, Shale::Type::String

  def name
    "#{super}!"
  end

  def name=(val)
    super("#{val}!")
  end
end

person = Person.from_json(<<~DATA)
{
  "name": "John Doe"
}
DATA

pp person
