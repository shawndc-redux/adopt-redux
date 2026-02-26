require "rails_helper"

RSpec.describe "application show page" do
  before(:each) do
    @application = Application.create(name: "Shawn", address: "1800 North Ave", city: "Chicago", state: "IL", zip: "12345", status: 0, description: "I love animals") 
    @shelter = Shelter.create(name: "Aurora shelter", city: "Aurora, CO", foster_program: false, rank: 9)
    @pet_1 = Pet.create(adoptable: true, age: 1, breed: "sphynx", name: "Lucille Bald", shelter_id: @shelter.id)
    @pet_2 = Pet.create(adoptable: true, age: 3, breed: "doberman", name: "Lobster", shelter_id: @shelter.id)
    ApplicationPet.create(pet_id: @pet_1.id, application_id: @application.id)
    
    visit "/applications/#{@application.id}"
  end

  describe "page content" do
    it "has application attributes" do
      expect(page).to have_content(@application.name)
      expect(page).to have_content(@application.address)
      expect(page).to have_content(@application.zip)
      expect(page).to have_content(@application.state)
      expect(page).to have_content(@application.city)
      expect(page).to have_content(@application.description)
    end
    
    it "has names of all pets that this application is for" do
      expect(page).to have_content(@pet_1.name)
      expect(page).to_not have_content(@pet_2.name)
    end

    it "all names of pets should be links to their show page" do
      expect(page).to have_link(@pet_1.name)

      click_on("#{@pet_1.name}")

      expect(page).to have_current_path("/pets/#{@pet_1.id}")
    end

    it "has application status" do
      expect(page).to have_content("In Progress")
    end
  end
end