class Category < ApplicationRecord
    has_many :job_categories, dependent: :destroy
  has_many :jobs, through: :job_categories

  validates :name, presence: true, uniqueness: true
end
