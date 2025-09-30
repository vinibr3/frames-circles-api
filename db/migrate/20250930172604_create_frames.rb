class CreateFrames < ActiveRecord::Migration[8.0]
  def change
    create_table :frames do |t|
      t.decimal :x, null: false
      t.decimal :y, null: false
      t.decimal :width, null: false
      t.decimal :height, null: false
      t.box :geometry, null: false

      t.timestamps
    end
  end
end
