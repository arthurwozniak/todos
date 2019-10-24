class CreateToDos < ActiveRecord::Migration[6.0]
  def change
    create_table :to_dos do |t|
      t.string :text, null: false
      t.boolean :done, null: false, default: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
