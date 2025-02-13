class CreateUrls < ActiveRecord::Migration[8.0]
  def change
    create_table :urls do |t|
      t.text :original_url, null: false
      t.string :slug, null: false

      t.timestamps
    end

    add_index :urls, :original_url, unique: true
    add_index :urls, :slug, unique: true
  end
end
