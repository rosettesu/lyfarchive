class CreateCampers < ActiveRecord::Migration[5.0]
  def change
    create_table :campers do |t|
      t.string :first_name
      t.string :last_name
      t.integer :gender
      t.date :birthdate
      t.string :email
      t.text :medical
      t.text :diet_allergies
      t.integer :status, default: 0

      t.timestamps
    end
    add_index :campers, [:first_name, :last_name, :birthdate], unique: true
  end
end
