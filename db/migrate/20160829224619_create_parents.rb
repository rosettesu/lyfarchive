class CreateParents < ActiveRecord::Migration[5.0]
  def change
    create_table :parents do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :phone_number
      t.string :street
      t.string :city
      t.string :state
      t.string :zip

      t.timestamps
    end
  end
end
