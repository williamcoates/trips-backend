class CreateTrips < ActiveRecord::Migration
  def change
    # Setup postgres UUID extension
    execute('CREATE EXTENSION  IF NOT EXISTS "uuid-ossp"')
    create_table :trips, id: :uuid do |t|
      t.integer :user_id, null: false
      t.text :destination, null: false
      t.date :start_date, null: false
      t.date :end_date, null: false
      t.text :comment
      t.timestamps null: false
    end
    add_foreign_key :trips, :users
  end
end
