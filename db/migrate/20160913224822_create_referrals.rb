class CreateReferrals < ActiveRecord::Migration[5.0]
  def change
    create_table :referrals do |t|
      t.integer :referral_method_id
      t.integer :parent_id
      t.string :details

      t.timestamps
    end
    add_index :referrals, :parent_id
    add_index :referrals, :referral_method_id
    add_index :referrals, [:parent_id, :referral_method_id], unique: true
  end
end
