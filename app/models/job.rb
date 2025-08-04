class Job < ApplicationRecord
  belongs_to :employer
  has_many :applications, dependent: :destroy
  has_many :job_skills, dependent: :destroy
  has_many :skills, through: :job_skills
  has_many :job_categories, dependent: :destroy
  has_many :categories, through: :job_categories

  # Fixed enum declarations:
  enum :employment_type, {
    full_time: 0,
    part_time: 1,
    contract: 2,
    freelance: 3,
    internship: 4
  }, default: :full_time

  enum :status, {
    draft: 0,
    published: 1,
    archived: 2
  }, default: :draft

  validates :title, :description, :employment_type, presence: true
  validates :salary, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  scope :active, -> { published.where("expires_at > ? OR expires_at IS NULL", Time.current) }
  scope :recent, -> { order(published_at: :desc) }

  before_save :set_published_at, if: :will_save_change_to_status?

  private

  def set_published_at
    self.published_at = Time.current if status_changed?(to: "published")
  end
end
