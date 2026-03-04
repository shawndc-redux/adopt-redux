class Admin::SheltersController < ApplicationController
  def index
    @shelters = Shelter.find_by_sql("SELECT * FROM shelters ORDER BY shelters.name desc")
    @pending_shelters = Shelter.joins(:applications).where(applications: {status: "Pending"})
  end
end