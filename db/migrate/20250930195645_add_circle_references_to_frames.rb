class AddCircleReferencesToFrames < ActiveRecord::Migration[8.0]
  def change
    add_reference :frames, :highest_circle, null: true, foreign_key: { to_table: :circles }
    add_reference :frames, :lowest_circle, null: true, foreign_key: { to_table: :circles }
    add_reference :frames, :rightest_circle, null: true, foreign_key: { to_table: :circles }
    add_reference :frames, :leftest_circle, null: true, foreign_key: { to_table: :circles }
  end
end
