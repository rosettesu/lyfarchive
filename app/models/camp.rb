class Camp < ApplicationRecord
  has_many :registrations, inverse_of: :camp
  validates :year, presence: true, uniqueness: true
  self.primary_key = 'year'
  default_scope -> { order(year: :desc) }
end
