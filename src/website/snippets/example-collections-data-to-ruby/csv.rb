require 'shale'

class Person < Shale::Mapper
  attribute :first_name, Shale::Type::String
  attribute :last_name, Shale::Type::String
end

pp Person.from_csv(<<~CSV)
John,Doe
James,Sixpack
CSV
