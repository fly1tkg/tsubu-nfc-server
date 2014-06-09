class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :kind
      t.references :event_set
      t.string :title
      t.integer :price
      t.integer :zusaar_id
      t.text :register_users

      t.timestamps
    end
  end
end
