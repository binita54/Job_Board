class Employer < ApplicationRecord
  belongs_to :user
  has_many :jobs, dependent: :destroy
  
  validates :company_name, presence: true
  validates :website, format: { with: URI::DEFAULT_PARSER.make_regexp }, allow_blank: true

end
