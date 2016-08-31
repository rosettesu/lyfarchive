# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# make some camps
camp = Camp.create!(year: 2016, name: "When LYF Gives You Lemons")
prev_camp = Camp.create!(year: 2015, name: "Circle of LYF")

# make some parents
60.times do |n|
  parent_first_name = Faker::Name.first_name
  parent_last_name = Faker::Name.last_name
  parent_email = Faker::Internet.safe_email(parent_first_name)
  phone_number = Faker::PhoneNumber.cell_phone
  address = "#{Faker::Address.street_address}, #{Faker::Address.city} #{Faker::Address.state_abbr} #{Faker::Address.zip}"
  referral_method = ["TACL-LYF Counselors", "TACL-LYF Campers and Families",
                     "JTASA", "TAP", "Other Taiwanese Organizations",
                     "Chinese School", "Newspaper", "Flyers", "Other"].sample
  referred_by = [Faker::Name.name, ""].sample
  Parent.create!(first_name: parent_first_name,
                 last_name: parent_last_name,
                 email: parent_email,
                 phone_number: phone_number,
                 address: address,
                 referral_method: referral_method,
                 referred_by: referred_by)
end

# give each parent some campers and register them for this year
parents = Parent.all
parents.each do |parent|
  rand(1..3).times do
    first_name = Faker::Name.first_name
    last_name = parent.last_name
    email = Faker::Internet.safe_email(first_name)
    gender = [:M, :F].sample
    birthdate = Faker::Date.between(18.years.ago, 9.years.ago)
    camper = parent.campers.create!(first_name: first_name,
                                    last_name: last_name,
                                    gender: gender,
                                    birthdate: birthdate,
                                    email: email,
                                    medical: "N/A",
                                    diet_allergies: "N/A",
                                    active: true)
    grade_completed = Time.now.year - camper.birthdate.year - 5
    shirt_size = %w[XSmall Small Medium Large XLarge].sample
    group = ('A'..'N').to_a.sample
    family = %w[Guava Dragonfruit Starfruit Kumquat Papaya Waxapple Passionfruit
                Pomelo Longan Persimmon Durian Loquat Lychee].sample
    cabin = %w[Coyote Redtail Deer Bobcat Raccoon Salmon Trout Owl Jackrabbit
               Condor Quail Eagle].sample
    waiver_signature = "#{parent.first_name} #{parent.last_name}"
    camper.registrations.create!(camp_id: camp.id,
                                 grade_completed: grade_completed,
                                 shirt_size: shirt_size,
                                 waiver_signature: waiver_signature,
                                 waiver_date: Time.zone.now,
                                 bus: true,
                                 group: group,
                                 cabin: cabin,
                                 family: family)
  end
end

# register the oldest campers (16+) for last year
repeat_campers = Camper.where('birthdate < ?', 16.years.ago)
repeat_campers.each do |camper|
  grade_completed = Time.now.year - camper.birthdate.year - 6
  shirt_size = %w[XSmall Small Medium Large XLarge].sample
  group = ('A'..'M').to_a.sample
  family = %w[Guava Dragonfruit Starfruit Kumquat Papaya Waxapple Passionfruit
              Pomelo Longan Persimmon Durian Loquat Lychee].sample
  cabin = %w[Coyote Redtail Deer Bobcat Raccoon Salmon Trout Owl Jackrabbit
             Condor Quail Eagle].sample
  waiver_signature = "#{camper.parent.first_name} #{camper.parent.last_name}"
  camper.registrations.create!(camp_id: prev_camp.id,
                               grade_completed: grade_completed,
                               shirt_size: shirt_size,
                               waiver_signature: waiver_signature,
                               waiver_date: Time.zone.now,
                               bus: false,
                               group: group,
                               cabin: cabin,
                               family: family)
end
