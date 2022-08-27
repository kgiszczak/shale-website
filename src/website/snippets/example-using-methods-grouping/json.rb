require 'shale'

class Person < Shale::Mapper
  attribute :name, Shale::Type::String

  json do
    group from: :name_from_json, to: :name_to_json do
      map 'first_name'
      map 'last_name'
    end
  end

  def name_from_json(model, value)
    model.name = "#{value['first_name']} #{value['last_name']}"
  end

  def name_to_json(model, doc)
    doc['first_name'] = model.name.split(' ')[0]
    doc['last_name'] = model.name.split(' ')[1]
  end
end

person = Person.from_json(<<~DATA)
{
  "first_name": "John",
  "last_name": "Doe"
}
DATA

pp person
