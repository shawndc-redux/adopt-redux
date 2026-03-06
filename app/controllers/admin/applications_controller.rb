class Admin::ApplicationsController < ApplicationController
  def show
    @application = Application.find(params[:id])
  end

  def update
    @application = Application.find(params[:id])
    @application_pet = ApplicationPet.where(
      pet_id: params[:pet_id]).where(
      application_id: params[:id]).first

    if params[:status] == "Approve"
      @application_pet.update!(application_pet_status: 2)
    elsif params[:status] == "Reject"
      @application_pet.update!(application_pet_status: 3)
    end
    
     redirect_to "/admin/applications/#{params[:id]}"
  end
end