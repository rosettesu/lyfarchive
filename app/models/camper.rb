class Camper < ApplicationRecord
  belongs_to :parent, inverse_of: :campers
  has_many :registrations, inverse_of: :camper
  validates :parent, presence: true
  before_save { self.email = email.downcase if !email.nil? }
  validates :first_name, :last_name, :gender, :birthdate, presence: true
  validates :medical, :diet_allergies,
            presence: { message: "Required. If none, please write \"N/A\"" }
  validates :email, length: { maximum: 255 }, format: VALID_EMAIL_REGEX,
            allow_blank: true
  validates :birthdate, uniqueness: { scope: [:first_name, :last_name] }
  enum gender: [:M, :F]

  def full_name
    "#{first_name} #{last_name}"
  end
end
