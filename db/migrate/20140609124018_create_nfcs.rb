class CreateNfcs < ActiveRecord::Migration
  def change
    create_table :nfcs do |t|
      t.references :user, index: true
      t.string :uuid

      t.timestamps
    end
    add_index :nfcs, :uuid
  end
end
