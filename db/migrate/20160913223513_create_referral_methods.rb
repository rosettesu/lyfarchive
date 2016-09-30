class CreateReferralMethods < ActiveRecord::Migration[5.0]
  def change
    create_table :referral_methods do |t|
      t.string :name
      t.boolean :allow_details

      t.timestamps
    end
  end
end
