class CreateEmployers < ActiveRecord::Migration[8.0]
  def change
    create_table :employers do |t|
      t.references :user, null: false, foreign_key: true
      t.string :company_name
      t.string :website
      t.text :description

      t.timestamps
    end
  end
end
