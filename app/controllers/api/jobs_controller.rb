class Api::JobsController < ApplicationController
  before_action :set_job, only: %i[update destroy]
  def index
    @jobs = Job.all
    render json: @jobs.map { |job| job.new_attr }
  end

  def create
    @job = Job.new(job_params)
    if @job.save
      render json: @job.new_attr
    else
      render json: @job.errors, status: 422
    end
  end

  def update
    if @job.update(job_params)
      render json: @job.new_attr
    else
      render json: @job.errors, status: 422
    end
  end

  def destroy
    if @job.destroy
      render json: { message: 'success to delete job' }
    else
      render json: { message: 'fail to delete job' }, status: 422
    end
  end

  private

  def set_job
    @job = Job.find_by_id(params[:id])
    return unless @job.nil?

    render json: { error: 'job not found' }, status: 404
  end

  def job_params
    params.require(:job).permit(:name, :description)
  end
end
