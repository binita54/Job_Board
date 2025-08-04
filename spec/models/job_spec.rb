require 'rails_helper'

RSpec.describe Job, type: :model do
  let(:employer) { create(:employer) }

  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:employment_type) }
    it { should validate_numericality_of(:salary).is_greater_than_or_equal_to(0).allow_nil }
  end

  describe 'associations' do
    it { should belong_to(:employer) }
    it { should have_many(:applications) }
    it { should have_many(:job_skills) }
    it { should have_many(:skills).through(:job_skills) }
    it { should have_many(:job_categories) }
    it { should have_many(:categories).through(:job_categories) }
  end

  describe 'enums' do
    it { should define_enum_for(:employment_type).with_values(full_time: 0, part_time: 1, contract: 2, freelance: 3, internship: 4) }
    it { should define_enum_for(:status).with_values(draft: 0, published: 1, archived: 2) }
  end

  describe 'scopes' do
    let!(:published_job) { create(:job, employer: employer, status: :published, published_at: 1.day.ago) }
    let!(:draft_job) { create(:job, employer: employer, status: :draft) }
    let!(:archived_job) { create(:job, employer: employer, status: :archived) }
    let!(:expired_job) { create(:job, employer: employer, status: :published, published_at: 1.month.ago, expires_at: 1.day.ago) }

    describe '.active' do
      it 'returns only published jobs that are not expired' do
        expect(Job.active).to eq([ published_job ])
      end
    end

    describe '.recent' do
      it 'returns jobs ordered by published_at desc' do
        expect(Job.recent.first).to eq(published_job)
      end
    end
  end

  describe '#set_published_at' do
    let(:job) { create(:job, employer: employer, status: :draft) }

    it 'sets published_at when status changes to published' do
      expect {
        job.published!
      }.to change { job.published_at }.from(nil)
    end
  end
end
