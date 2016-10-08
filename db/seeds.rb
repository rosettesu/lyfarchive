# make some referral methods
detailed = ["TACL-LYF Counselors", "TACL-LYF Campers and Families",
  "Other Taiwanese Organizations", "Other"]
["TACL-LYF Counselors", "TACL-LYF Campers and Families", "JTASA", "TAP",
  "Other Taiwanese Organizations", "Chinese School", "Newspaper", "Flyers",
  "Other"].each do |method|
  ReferralMethod.create!(name: method, allow_details: detailed.include?(method))
end
referral_methods = ReferralMethod.all

# make some camps
camp = Camp.create!(year: 2016, name: "When LYF Gives You Lemons")
prev_camp = Camp.create!(year: 2015, name: "Circle of LYF")

# make next year's camp just bc
Camp.create!(year: 2017, name: "To Be Determined")

# make some parents
60.times do |n|
  parent_first_name = Faker::Name.first_name
  parent_last_name = Faker::Name.last_name
  parent_email = Faker::Internet.safe_email(parent_first_name)
  Parent.create!(first_name: parent_first_name,
                 last_name: parent_last_name,
                 email: parent_email,
                 phone_number: Faker::PhoneNumber.cell_phone,
                 street: Faker::Address.street_address,
                 city: Faker::Address.city,
                 state: Faker::Address.state_abbr,
                 zip: Faker::Address.zip)
end

# give each parent some campers and register them for this year
parents = Parent.all
parents.each do |parent|
  times = rand(1..2)
  referral_methods.sample(times).each do |method|
    parent.referrals.create!(referral_method_id: method.id,
                             details: method.allow_details ? Faker::Name.name : nil)
  end
  rand(1..3).times do
    first_name = Faker::Name.first_name
    last_name = parent.last_name
    email = Faker::Internet.safe_email(first_name)
    gender = [:male, :female].sample
    birthdate = Faker::Date.between(18.years.ago, 9.years.ago)
    camper = parent.campers.create!(first_name: first_name,
                                    last_name: last_name,
                                    gender: gender,
                                    birthdate: birthdate,
                                    email: email,
                                    medical: "N/A",
                                    diet_allergies: "N/A",
                                    status: birthdate < 17.years.ago ?
                                            "graduated" : "active")
    grade = [[Time.now.year - camper.birthdate.year - 5, 3].max, 12].min
    shirt_size = %w[x_small small medium large x_large xx_large].sample
    group = ('A'..'N').to_a.sample
    family = %w[Guava Dragonfruit Starfruit Kumquat Papaya Waxapple Passionfruit
                Pomelo Longan Persimmon Durian Loquat Lychee].sample
    cabin = %w[Coyote Redtail Deer Bobcat Raccoon Salmon Trout Owl Jackrabbit
               Condor Quail Eagle].sample
    waiver_signature = "#{parent.first_name} #{parent.last_name}"
    camper.registrations.create!(camp_id: camp.id,
                                 grade: grade,
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
  grade = Time.now.year - camper.birthdate.year - 6
  shirt_size = %w[x_small small medium large x_large xx_large].sample
  group = ('A'..'N').to_a.sample
  family = %w[Guava Dragonfruit Starfruit Kumquat Papaya Waxapple Passionfruit
              Pomelo Longan Persimmon Durian Loquat Lychee].sample
  cabin = %w[Coyote Redtail Deer Bobcat Raccoon Salmon Trout Owl Jackrabbit
             Condor Quail Eagle].sample
  waiver_signature = "#{camper.parent.first_name} #{camper.parent.last_name}"
  camper.registrations.create!(camp_id: prev_camp.id,
                               grade: grade,
                               shirt_size: shirt_size,
                               waiver_signature: waiver_signature,
                               waiver_date: Time.zone.now,
                               bus: true,
                               group: group,
                               cabin: cabin,
                               family: family)
end
