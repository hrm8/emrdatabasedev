# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.destroy_all
Clinic.destroy_all
Insurance.destroy_all
ShareRequest.destroy_all
Record.destroy_all
Address.destroy_all

User.create(name: 'Ricardo', email: 'r@gmail.com', social: '12341234', phone: '8921470142738', birthDate: Date.new(1990, 3, 2))
User.create(name: 'Roberto', email: 'rob@gmail.com', social: '09128375', phone: '234562321', birthDate: Date.new(1989, 3, 2))
User.create(name: 'Amanda', email: 'amanda@gmail.com', social: '23914876', phone: '7855262346', birthDate: Date.new(1988, 3, 2))
User.create(name: 'Kenny', email: 'kenn@gmail.com', social: '4271864968', phone: '7347246', birthDate: Date.new(1987, 3, 2))

Clinic.create(name: 'Miami Cardiology', phone: '42987132', email: 'miami@cardiology.com')
Clinic.create(name: 'Orthopedists Heaven', phone: '4214323441', email: 'miami@ortho.com')
Clinic.create(name: 'Brawling Brain', phone: '43212551', email: 'miami@brain.com')

Insurance.create(name: 'Progressive', phone: '4298557132', email: 'miami@prog.com')
Insurance.create(name: 'Blue Cross', phone: '421436623441', email: 'blue@cross.com')

User.all.each do |u|
  Address.create(street: '1300 S Miami Ave', zip: '33130', state: 'FL', city: 'Miami', apt:"#{u.id + 100}", user_id: u.id)
end
Clinic.all.each do |u|
  Address.create(street: '1310 S Miami Ave', zip: '33130', state: 'FL', city: 'Miami', apt:"#{u.id + 300}", clinic_id: u.id)
end
Insurance.all.each do |u|
  Address.create(street: '1320 S Miami Ave', zip: '33130', state: 'FL', city: 'Miami', apt:"#{u.id + 500}", insurance_id: u.id)
end

(1..50).each do |i|
  r = Record.new(url: "google.com/#{i}")
  r.user = User.offset(rand(User.count)).first
  r.owner_clinic = Clinic.offset(rand(Clinic.count)).first
  r.save
end

Clinic.all.each do |c|
  (1..5).each do
    c.records.push(Record.offset(rand(Record.count)).first)
  end
end