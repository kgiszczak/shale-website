require 'shale'

class Person < Shale::Mapper
  attribute :first_name, Shale::Type::String
  attribute :middle_name, Shale::Type::String
  attribute :last_name, Shale::Type::String
  attribute :age, Shale::Type::Integer
  attribute :hobby, Shale::Type::String

  xml do
    root 'person'
    namespace 'http://ns1.com', 'ns1'

    map_element 'first_name', to: :first_name

    # undeclare namespace on 'middle_name' element
    map_element 'middle_name', to: :middle_name,
      namespace: nil,
      prefix: nil

    # overwrite default namespace
    map_element 'last_name', to: :last_name,
      namespace: 'http://ns2.com',
      prefix: 'ns2'

    map_attribute 'age', to: :age

    map_attribute 'hobby', to: :hobby,
      namespace: 'http://ns1.com',
      prefix: 'ns1'
  end
end

person = Person.from_xml(<<~DATA)
<ns1:person
  xmlns:ns1="http://ns1.com"
  xmlns:ns2="http://ns2.com"
  age="50"
  ns1:hobby="running"
>
  <ns1:first_name>John</ns1:first_name>
  <middle_name>Joe</middle_name>
  <ns2:last_name>Doe</ns2:last_name>
</ns1:person>
DATA

pp person
