class CreateShortcuts < ActiveRecord::Migration
  def change
    create_table :shortcuts do |t|
      t.string :slug, null: false
      t.string :url, null: false

      t.timestamps null: false
    end
  end
end
