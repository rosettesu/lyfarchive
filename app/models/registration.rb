class Registration < ApplicationRecord
  belongs_to :camp, inverse_of: :registrations
  belongs_to :camper, inverse_of: :registrations
  validates :camp, :camper, :grade_completed, :shirt_size, :waiver_signature,
            :waiver_date, presence: true
  validates_inclusion_of :bus, in: [true, false]
  enum shirt_size: [:XSmall, :Small, :Medium, :Large, :XLarge]
  enum group: ('A'..'Z').to_a.map!(&:to_sym)
end
