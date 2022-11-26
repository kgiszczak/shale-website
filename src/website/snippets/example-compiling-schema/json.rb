require 'shale'
require 'shale/schema'

schema = <<~SCHEMA
{
  "type": "object",
  "properties": {
    "firstName": { "type": "string" },
    "lastName": { "type": "string" },
    "address": { "$ref": "http://bar.com" }
  },
  "$defs": {
    "Address": {
      "$id": "http://bar.com",
      "type": "object",
      "properties": {
        "street": { "type": "string" },
        "city": { "type": "string" }
      }
    }
  }
}
SCHEMA

mapping = {
  nil => 'Api::Foo', # default schema (without ID)
  'http://bar.com' => 'Api::Bar',
}

result = Shale::Schema.from_json(
  [schema],
  root_name: 'Person',
  namespace_mapping: mapping
)

result.each do |name, model|
  puts "# ----- #{name}.rb -----"
  puts model
end
