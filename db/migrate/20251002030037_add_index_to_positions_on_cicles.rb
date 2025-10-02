class AddIndexToPositionsOnCicles < ActiveRecord::Migration[8.0]
  def change
    add_index :circles, :x
    add_index :circles, :y
  end
end
