class CreateJobs < ActiveRecord::Migration[8.0]
  def change
    create_table :jobs do |t|
      t.references :employer, null: false, foreign_key: true
      t.string :title
      t.text :description
      t.string :employment_type
      t.string :location
      t.boolean :remote
      t.decimal :salary
      t.integer :status
      t.datetime :published_at
      t.datetime :expires_at

      t.timestamps
    end
  end
end
