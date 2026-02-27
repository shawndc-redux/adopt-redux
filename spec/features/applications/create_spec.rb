require "rails_helper"

RSpec.describe "application creation" do
  before(:each) do
    @shelter = Shelter.create(name: "Aurora shelter", city: "Aurora, CO", foster_program: false, rank: 9)
    @pet_1 = Pet.create(adoptable: true, age: 1, breed: "sphynx", name: "Lucille Bald", shelter_id: @shelter.id)
    @pet_2 = Pet.create(adoptable: true, age: 3, breed: "doberman", name: "Lobster", shelter_id: @shelter.id)
  end
  
  describe "new application" do
    it "renders a form to create a new application" do
      visit "/pets"
      expect(page).to have_link("Start an Application")
      click_on("Start an Application")

      expect(page).to have_current_path("/applications/new")
      expect(find("form")).to have_content("Name")
      expect(find("form")).to have_content("Address")
      expect(find("form")).to have_content("City")
      expect(find("form")).to have_content("State")
      expect(find("form")).to have_content("Zip")
      expect(find("form")).to have_content("Description")
    end
  end

  describe "application creation" do
    context "given valid data" do
      it "receives the data and takes user to application show page" do
        visit "/applications/new"
        fill_in "Name", with: "Shawn"
        fill_in "Address", with: "1800 North Ave"
        fill_in "City", with: "Chicago"
        fill_in "State", with: "IL"
        fill_in "Zip", with: "12345"
        fill_in "Description", with: "I love cats!!!!!"
        click_button

        expect(page).to have_content("Shawn")
        expect(page).to have_content("1800 North Ave")
        expect(page).to have_content("Chicago")
        expect(page).to have_content("IL")
        expect(page).to have_content("12345")
        expect(page).to have_content("I love cats!!!!!")
        expect(page).to have_content("In Progress")
      end
    end

    context "given invalid data" do
      it "gives errors if params are missing" do
        visit "/applications/new"
        fill_in "Name", with: "Shawn"
        fill_in "City", with: "Chicago"
        fill_in "State", with: "IL"
        fill_in "Zip", with: "12345"
        fill_in "Description", with: "I love cats!!!!!"
        click_button

        expect(page).to have_content("Error: Address can't be blank")
        expect(page).to have_current_path("/applications/new")
      end
    end
  end
end