require 'shale'
require 'shale/schema'

schema = <<~SCHEMA
{
  "type": "object",
  "properties": {
    "firstName": { "type": "string" },
    "lastName": { "type": "string" },
    "address": {
      "type": "object",
      "properties": {
        "street": { "type": "string" },
        "city": { "type": "string" }
      }
    }
  }
}
SCHEMA

Shale::Schema.from_json([schema], root_name: 'Person').each do |name, model|
  puts "# ----- #{name}.rb -----"
  puts model
end
