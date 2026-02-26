class ApplicationsController < ApplicationController
  def show
    @application = Application.find(params[:id])
  end

    private

  def application_params
    params.permit(:id, :name, :address, :state, :city, :zip, :description, :status)
  end
end