require 'shale'
require 'shale/schema'

class ByteType < Shale::Type::Value
end

class Person < Shale::Mapper
  attribute :name, Shale::Type::String
  attribute :age, ByteType
end

Shale::Schema::XML.register_xml_type(ByteType, 'byte')

Shale::Schema.to_xml(Person, pretty: true).each do |name, xml|
  puts "<!-- #{name} -->"
  puts xml
  puts
end
