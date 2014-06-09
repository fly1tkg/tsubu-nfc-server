class CreateEventSets < ActiveRecord::Migration
  def change
    create_table :event_sets do |t|
      t.text :attendance_users, :default => []

      t.timestamps
    end
  end
end
