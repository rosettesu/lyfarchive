class Camp < ApplicationRecord
  has_many :registrations, inverse_of: :camp
  default_scope -> { order(year: :desc) }
end
