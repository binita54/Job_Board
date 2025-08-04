class JobAlert < ApplicationRecord
  belongs_to :user
  
  enum frequency: { daily: 0, weekly: 1, monthly: 2 }
  
  validates :frequency, presence: true
  validates :search_params, presence: true
  
  scope :active, -> { where(active: true) }
  
  def self.process_alerts
    JobAlert.active.find_each do |alert|
      next unless alert.due?
      
      jobs = alert.matching_jobs
      next if jobs.empty?
      
      JobAlertMailer.with(alert: alert, jobs: jobs).new_jobs.deliver_now
      alert.update(last_sent_at: Time.current)
    end
  end
  
  def due?
    case frequency
    when 'daily' then last_sent_at.nil? || last_sent_at < 1.day.ago
    when 'weekly' then last_sent_at.nil? || last_sent_at < 1.week.ago
    when 'monthly' then last_sent_at.nil? || last_sent_at < 1.month.ago
    end
  end
  
  def matching_jobs
    Job.ransack(search_params).result.active
  end
end