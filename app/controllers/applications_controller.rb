class ApplicationsController < ApplicationController
  def show
    @application = Application.find(params[:id])
    if params[:search].present?
      @searched_pets = Pet.find_by(name: params[:search])
    end
  end

  def new
  end

  def create
    application = Application.new(application_params)

    if application.save
      redirect_to "/applications/#{application.id}"
    else
      redirect_to "/applications/new"
      flash[:alert] = "Error: #{error_message(application.errors)}"
    end
  end

    private

  def application_params
    params.permit(:id, :name, :address, :state, :city, :zip, :description, :status)
  end
end