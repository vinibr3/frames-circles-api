class CreateCircles < ActiveRecord::Migration[8.0]
  def change
    create_table :circles do |t|
      t.references :frame, null: false, foreign_key: { to_table: :frames }
      t.decimal :x, null: false
      t.decimal :y, null: false
      t.decimal :radius, null: false
      t.decimal :diameter, null: false
      t.circle :geometry, null: false

      t.timestamps
    end
  end
end
