class CreateJobAlerts < ActiveRecord::Migration[8.0]
  def change
    create_table :job_alerts do |t|
      t.references :user, null: false, foreign_key: true
      t.json :search_params
      t.string :frequency
      t.datetime :last_sent_at
      t.boolean :active

      t.timestamps
    end
  end
end
