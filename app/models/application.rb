class Application < ApplicationRecord
  belongs_to :user
  belongs_to :job

  self.enum status: { submitted: 0, reviewed: 1, interviewed: 2, rejected: 3, offered: 4 }

  validates :cover_letter, presence: true
end
