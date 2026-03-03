class ApplicationsController < ApplicationController
  def show
    @application = Application.find(params[:id])
    if params[:search].present?
      @searched_pets = Pet.search_for_pet(params[:search])
    end

    if params[:search].present? && @searched_pets.empty?
      flash[:alert] = "No pets match this search"
    end
  end

  def add_pet
    app_pet = ApplicationPet.new
    app_pet.pet_id = params[:pet_id]
    app_pet.application_id = params[:id]
    if app_pet.save
      redirect_to "/applications/#{params[:id]}"
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

  def update
    @application = Application.find(params[:id])
    
    if params[:reason].present?
      @application.update(status: 1)
    end
    redirect_to "/applications/#{@application.id}"
  end

    private

  def application_params
    params.permit(:id, :name, :address, :state, :city, :zip, :description, :status)
  end
end