require 'rails_helper'

RSpec.describe JobsController, type: :controller do
  let(:user) { create(:user) }
  let(:employer) { create(:employer, user: user) }
  let(:job) { create(:job, employer: employer) }

  describe 'GET #index' do
    it 'returns http success' do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #show' do
    context 'when job is published' do
      let(:published_job) { create(:job, employer: employer, status: :published) }

      it 'returns http success' do
        get :show, params: { id: published_job.id }
        expect(response).to have_http_status(:success)
      end
    end

    context 'when job is draft' do
      let(:draft_job) { create(:job, employer: employer, status: :draft) }

      context 'when user is not authenticated' do
        it 'redirects to sign in' do
          get :show, params: { id: draft_job.id }
          expect(response).to redirect_to(new_user_session_path)
        end
      end

      context 'when user is not the owner' do
        let(:other_user) { create(:user) }

        before { sign_in other_user }

        it 'raises not authorized error' do
          expect {
            get :show, params: { id: draft_job.id }
          }.to raise_error(Pundit::NotAuthorizedError)
        end
      end

      context 'when user is the owner' do
        before { sign_in user }

        it 'returns http success' do
          get :show, params: { id: draft_job.id }
          expect(response).to have_http_status(:success)
        end
      end
    end
  end

  describe 'POST #create' do
    before { sign_in user }

    let(:valid_attributes) { attributes_for(:job) }

    context 'with valid params' do
      it 'creates a new job' do
        expect {
          post :create, params: { job: valid_attributes }
        }.to change(Job, :count).by(1)
      end

      it 'redirects to the created job' do
        post :create, params: { job: valid_attributes }
        expect(response).to redirect_to(Job.last)
      end
    end

    context 'with invalid params' do
      it 'does not create a new job' do
        expect {
          post :create, params: { job: { title: '' } }
        }.not_to change(Job, :count)
      end

      it 'renders new template' do
        post :create, params: { job: { title: '' } }
        expect(response).to render_template(:new)
      end
    end
  end
end
