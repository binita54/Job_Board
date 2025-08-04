class CreateApplications < ActiveRecord::Migration[8.0]
  def change
    create_table :applications do |t|
      t.references :user, null: false, foreign_key: true
      t.references :job, null: false, foreign_key: true
      t.text :cover_letter
      t.integer :status
      t.datetime :submitted_at

      t.timestamps
    end
  end
end
