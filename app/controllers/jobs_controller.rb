class JobsController < ApplicationController
  before_action :authenticate_user!, except: [ :index, :show ]
  before_action :set_job, only: [ :show, :edit, :update, :destroy, :publish, :archive ]

  def index
   @pagy, @jobs = pagy(
    policy_scope(Job).active.recent.includes(:employer, :categories),
    items: 10
  )
rescue Pagy::OverflowError => e
  redirect_to jobs_path(page: 1), alert: "Page not found"
end

  def show
    authorize @job
  end

  def new
    @job = current_user.employer.jobs.new
    authorize @job
  end

  def create
    @job = current_user.employer.jobs.new(job_params)
    authorize @job

    if @job.save
      redirect_to @job, notice: "Job was successfully created."
    else
      render :new
    end
  end

  def edit
    authorize @job
  end

  def update
    authorize @job

    if @job.update(job_params)
      redirect_to @job, notice: "Job was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    authorize @job
    @job.destroy
    redirect_to jobs_url, notice: "Job was successfully destroyed."
  end

  def publish
    authorize @job, :publish?
    @job.published!
    redirect_to @job, notice: "Job has been published."
  end

  def archive
    authorize @job, :archive?
    @job.archived!
    redirect_to @job, notice: "Job has been archived."
  end

  private

  def set_job
    @job = Job.find(params[:id])
  end

  def job_params
    params.require(:job).permit(:title, :description, :employment_type, :location, :remote,
                               :salary, :expires_at, skill_ids: [], category_ids: [])
  end
end
