class CreateRegistrations < ActiveRecord::Migration[5.0]
  def change
    create_table :registrations do |t|
      t.integer :grade_completed
      t.integer :shirt_size
      t.boolean :bus
      t.text :additional_notes
      t.string :waiver_signature
      t.datetime :waiver_date
      t.integer :group
      t.string :family
      t.string :cabin
      t.references :camp, foreign_key: true, index: true
      t.references :camper, foreign_key: true, index: true

      t.timestamps
    end
    add_index :registrations, [:camp_id, :camper_id], unique: true
  end
end
