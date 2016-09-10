class Parent < ApplicationRecord
  include RegFormHelper
  has_many :campers, inverse_of: :parent
  accepts_nested_attributes_for :campers
  before_save { self.email = email.downcase }
  with_options :if => Proc.new { |p| p.required_for_step?(:parent) } do
    validates :first_name, :last_name, presence: true, length: { maximum: 50 }
    validates :phone_number, :street, :city, :state, :zip, presence: true
    validates :email, length: { maximum: 255 }, format: VALID_EMAIL_REGEX,
                   presence: true
  end
  validates :referral_method, presence: true,
            :if => Proc.new { |p| p.required_for_step?(:referral) }
  enum referral_method: { counselors: 0, campers: 1, jtasa: 2, tap: 3,
                          other_org: 4, chinese_school: 5, newspaper: 6,
                          flyers: 7, other: 8 }

  cattr_accessor :reg_steps do %w[parent referral] end
  attr_accessor :reg_step

  def full_name
    "#{first_name} #{last_name}"
  end
end
