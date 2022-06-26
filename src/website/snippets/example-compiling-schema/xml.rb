require 'shale'
require 'shale/schema'

schema = <<~SCHEMA
<xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema">
  <xs:element name="Person" type="Person" />

  <xs:complexType name="Person">
    <xs:sequence>
      <xs:element name="FirstName" type="xs:string" />
      <xs:element name="LastName" type="xs:string" />
      <xs:element name="Address" type="Address" />
    </xs:sequence>
    <xs:attribute name="age" type="xs:integer" />
  </xs:complexType>

  <xs:complexType name="Address">
    <xs:sequence>
      <xs:element name="Street" type="xs:string" />
      <xs:element name="City" type="xs:string" />
    </xs:sequence>
  </xs:complexType>
</xs:schema>
SCHEMA

Shale::Schema.from_xml([schema]).each do |name, model|
  puts "# ----- #{name}.rb -----"
  puts model
end
