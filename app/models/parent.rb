class Parent < ApplicationRecord
  include RegFormHelper
  has_many :referrals, inverse_of: :parent
  has_many :referral_methods, through: :referrals
  accepts_nested_attributes_for :referrals, allow_destroy: true
  has_many :campers, inverse_of: :parent
  before_save { self.email = email.downcase }
  with_options :if => Proc.new { |p| p.required_for_step?(:parent) } do
    validates :first_name, :last_name, presence: true, length: { maximum: 50 }
    validates :phone_number, :street, :city, presence: true
    validates :email, length: { maximum: 255 }, format: VALID_EMAIL_REGEX
    validates :state, length: { is: 2 }
    validates :zip, length: { minimum: 5 }
  end

  cattr_accessor :reg_steps do %w[parent referral] end
  attr_accessor :reg_step

  def full_name
    "#{first_name} #{last_name}"
  end
end
