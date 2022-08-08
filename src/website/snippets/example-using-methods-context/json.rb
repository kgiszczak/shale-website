class Person < Shale::Mapper
  attribute :password, Shale::Type::String

  json do
    map 'password', using: { from: :password_from, to: :password_to }
  end

  def password_from(model, value, context)
    model.password = context.admin? ? value : '*****'
  end

  def password_to(model, doc, context)
    doc['password'] = context.admin? ? model.password : '*****'
  end
end

class User
  def initialize(admin: false)
    @admin = admin
  end

  def admin?
    @admin
  end
end

current_user = User.new(admin: false)
person = Person.new(password: 'secret')
puts person.to_json(context: current_user, pretty: true)
