class CreateCamps < ActiveRecord::Migration[5.0]
  def change
    create_table :camps do |t|
      t.integer :year
      t.string :name

      t.timestamps
    end
    add_index :camps, :year
  end
end
