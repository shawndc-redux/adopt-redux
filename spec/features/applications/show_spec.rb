require "rails_helper"

RSpec.describe "application show page" do
  before(:each) do
    @application = Application.create(name: "Shawn", address: "1800 North Ave", city: "Chicago", state: "IL", zip: "12345", status: 0, description: "I love animals") 
    @application_2 = Application.create(name: "Quinn", address: "2000 South Ave", city: "Chicago", state: "IL", zip: "12345", status: 0, description: "I love animals") 
    @shelter = Shelter.create(name: "Aurora shelter", city: "Aurora, CO", foster_program: false, rank: 9)
    @pet_1 = Pet.create(adoptable: true, age: 1, breed: "sphynx", name: "Lucille Bald", shelter_id: @shelter.id)
    @pet_2 = Pet.create(adoptable: true, age: 3, breed: "doberman", name: "Lobster", shelter_id: @shelter.id)
    ApplicationPet.create(pet_id: @pet_1.id, application_id: @application.id)
    
  end
  
  describe "page content" do
    before(:each) do
      visit "/applications/#{@application.id}"
    end

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

  describe "Searching for Pets for an Application" do
    before(:each) do
      visit "/applications/#{@application_2.id}"
    end

    it "has a section to add a pet" do
      expect(page).to have_content("Add a Pet to this Application")
      
      fill_in :search, with: "Lobster"
      click_button("Search")

      expect(page).to have_current_path("/applications/#{@application_2.id}?search=Lobster&commit=Search")
      expect(page).to have_content("Lobster")
    end
    
    it "accepts partial names" do
      fill_in :search, with: "Lobs"
      click_button("Search")
  
      expect(page).to have_current_path("/applications/#{@application_2.id}?search=Lobs&commit=Search")
      expect(page).to have_content("Lobster")
    end

    context "sad path" do
      it "must match a pet name" do
      fill_in :search, with: "Apher"
      click_button("Search")
  
      expect(page).to have_current_path("/applications/#{@application_2.id}?search=Apher&commit=Search")
      expect(page).to_not have_content("Lobster")
      expect(page).to_not have_content("Lucille Bald")
      expect(page).to have_content("No pets match this search")
      end
    end
  end

  describe "add a pet to an application" do
    context "when I visit an application show page" do
      context "search for a pet by name" do
        before(:each) do
          visit "/applications/#{@application_2.id}"
          fill_in :search, with: "Lobs"
          click_button("Search")
        end

        it "has a button to adopt pet" do
          expect(page).to have_button("Adopt this Pet")
        end

        it "can add a pet to an application" do
          click_button("Adopt this Pet")

          expect(page).to have_current_path("/applications/#{@application_2.id}")
          expect(page).to have_content("Lobster")
        end
      end
    end
  end
end