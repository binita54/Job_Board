Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users

  root to: "jobs#index"

  resources :jobs do
    member do
      patch :publish
      patch :archive
    end

    resources :applications, only: [ :new, :create ]
  end

  resources :applications, except: [ :new, :create ]

  namespace :employers do
    get "dashboard", to: "dashboard#index"
    resources :jobs, only: [ :index ]
  end

  get "my_jobs", to: "jobs#my_jobs"

  # For admin panel (if you add admin later)
  # namespace :admin do
  #   resources :jobs
  #   resources :employers
  #   resources :applications
  #   root to: "dashboard#index"
  # end
end
