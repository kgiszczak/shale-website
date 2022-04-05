require 'shale'

class Person < Shale::Mapper
  attribute :first_name, Shale::Type::String
  attribute :last_name, Shale::Type::String
  attribute :age, Shale::Type::Integer

  xml do
    root 'person'

    map_element 'first_name', to: :first_name,
      namespace: 'http://ns1.com',
      prefix: 'ns1'

    map_element 'last_name', to: :last_name,
      namespace: 'http://ns2.com',
      prefix: 'ns2'

    map_attribute 'age', to: :age,
      namespace: 'http://ns2.com',
      prefix: 'ns2'
  end
end

person = Person.from_xml(<<~DATA)
<person
  xmlns:ns1="http://ns1.com"
  xmlns:ns2="http://ns2.com"
  ns2:age="50"
>
  <ns1:first_name>John</ns1:first_name>
  <ns2:last_name>Doe</ns2:last_name>
</person>
DATA

pp person
