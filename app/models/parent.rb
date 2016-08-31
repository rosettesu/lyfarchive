class Parent < ApplicationRecord
  has_many :campers, inverse_of: :parent
  before_save { self.email = email.downcase }
  validates :first_name, :last_name, :email, :phone_number, :address,
            :referral_method, presence: true
  validates :email, length: { maximum: 255 }, format: VALID_EMAIL_REGEX

  def full_name
    "#{first_name} #{last_name}"
  end
end
