class CreateMigraines < ActiveRecord::Migration[8.1]
  def change
    create_table :migraines do |t|
      t.references :user, null: false, foreign_key: true
      t.date :occurred_on, null: false
      t.string :nature, null: false
      t.integer :intensity, null: false
      t.boolean :on_period, null: false, default: false
      t.string :medication

      t.timestamps
    end

    add_index :migraines, %i[user_id occurred_on], unique: true
  end
end
