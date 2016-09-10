class CreateCamps < ActiveRecord::Migration[5.0]
  def change
    create_table(:camps, :primary_key => 'year') do |t|
      t.string :name

      t.timestamps
    end
  end
end
