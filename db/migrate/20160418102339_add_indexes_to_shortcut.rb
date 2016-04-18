class AddIndexesToShortcut < ActiveRecord::Migration
  def change
    add_index :shortcuts, :slug
    add_index :shortcuts, :url
  end
end
