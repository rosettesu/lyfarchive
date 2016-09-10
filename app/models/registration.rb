class Registration < ApplicationRecord
  include RegFormHelper
  belongs_to :camp, inverse_of: :registrations
  belongs_to :camper, inverse_of: :registrations
  validates :camp, :camper, presence: true
  validates :grade, presence: true,
            :if => Proc.new { |r| r.required_for_step?(:camper) }
  validates :shirt_size, presence: true,
            :if => Proc.new { |r| r.required_for_step?(:shirt) }
  with_options :if => Proc.new { |r| r.required_for_step?(:bus) } do
    validates_inclusion_of :bus, in: [true, false]
  end
  validates :waiver_signature, :waiver_date, presence: true,
            :if => Proc.new { |r| r.required_for_step?(:waiver) }
  enum shirt_size: { x_small: 0, small: 1, medium: 2, large: 3, x_large: 4, xx_large: 5}
  enum group: ('A'..'Z').to_a.map!(&:to_sym)

  cattr_accessor :reg_steps do %w[camper shirt bus notes waiver] end
  attr_accessor :reg_step

end
