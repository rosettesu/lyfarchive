class AddParentToCampers < ActiveRecord::Migration[5.0]
  def change
    add_reference :campers, :parent, foreign_key: true
  end
end
