require 'shale'
require 'shale/schema'

class EmailType < Shale::Type::Value
end

class EmailTypeJSON < Shale::Schema::JSON::Base
  def as_type
    { 'type' => 'string', 'format' => 'email' }
  end
end

class Person < Shale::Mapper
  attribute :name, Shale::Type::String
  attribute :email, EmailType
end

Shale::Schema::JSON.register_json_type(EmailType, EmailTypeJSON)

puts Shale::Schema.to_json(Person, pretty: true)
