require 'shale'
require 'shale/schema'

schema1 = <<~SCHEMA
<xs:schema
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:bar="http://bar.com"
  elementFormDefault="qualified"
>
  <xs:import namespace="http://bar.com" />

  <xs:element name="Person" type="Person" />

  <xs:complexType name="Person">
    <xs:sequence>
      <xs:element name="Name" type="xs:string" />
      <xs:element ref="bar:Address" />
    </xs:sequence>
  </xs:complexType>
</xs:schema>
SCHEMA

schema2 = <<~SCHEMA
<xs:schema
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:bar="http://bar.com"
  targetNamespace="http://bar.com"
  elementFormDefault="qualified"
>
  <xs:element name="Address" type="bar:Address" />

  <xs:complexType name="Address">
    <xs:sequence>
      <xs:element name="Street" type="xs:string" />
      <xs:element name="City" type="xs:string" />
    </xs:sequence>
  </xs:complexType>
</xs:schema>
SCHEMA

mapping = {
  nil => 'Api::Foo', # no namespace
  'http://bar.com' => 'Api::Bar',
}

result = Shale::Schema.from_xml(
  [schema1, schema2],
  namespace_mapping: mapping
)

result.each do |name, model|
  puts "# ----- #{name}.rb -----"
  puts model
end
