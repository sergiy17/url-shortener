class CreateAnalytics < ActiveRecord::Migration[8.0]
  def change
    create_table :analytics do |t|
      t.references :url, null: false, foreign_key: true
      t.integer :visits, default: 0
      t.datetime :last_visit_at

      t.timestamps
    end
  end
end
