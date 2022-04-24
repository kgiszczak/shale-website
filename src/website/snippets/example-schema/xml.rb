require 'shale'
require 'shale/schema'

class Address < Shale::Mapper
  attribute :city, Shale::Type::String
end

class Person < Shale::Mapper
  attribute :name, Shale::Type::String
  attribute :address, Address
end

Shale::Schema.to_xml(Person, pretty: true).each do |name, xml|
  puts "<!-- #{name} -->"
  puts xml
  puts
end
