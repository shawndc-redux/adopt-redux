require "rails_helper"

RSpec.describe "Admin Applications Show" do
  before(:each) do
    @application = Application.create!(name: "Shawn", address: "1800 North Ave", city: "Chicago", state: "IL", zip: "12345", status: 1, description: "I love animals") 
    @application_2 = Application.create!(name: "Quinn", address: "2000 South Ave", city: "Chicago", state: "IL", zip: "12345", status: 0, description: "I love animals") 
    @shelter = Shelter.create(name: "Aurora shelter", city: "Aurora, CO", foster_program: false, rank: 9)
    @pet_1 = Pet.create(adoptable: true, age: 1, breed: "sphynx", name: "Lucille Bald", shelter_id: @shelter.id)
    @pet_2 = Pet.create(adoptable: true, age: 3, breed: "doberman", name: "Lobster", shelter_id: @shelter.id)
    @application.add_pet(@pet_1)
    @application.add_pet(@pet_2)
    @application_2.add_pet(@pet_1)

    visit "/admin/applications/#{@application.id}"
  end

  describe "When I visit an admin application show page ('/admin/applications/:id')" do
    context "For every pet that the application is for" do
      it "has a button to approve the application for that specific pet" do
        within("#pets-#{@pet_1.id}") do
          expect(page).to have_button("Approve")
        
          click_button("Approve")
        end
      
        expect(page).to have_current_path("/admin/applications/#{@application.id}")
      
        within("#pets-#{@pet_1.id}") do
          expect(page).to_not have_button("Approve")
          expect(page).to have_content("Approved")
        end

        within("#pets-#{@pet_2.id}") do
          expect(page).to have_button("Approve")
        end      
      end
    end
  end

  describe "When I visit an admin application show page ('/admin/applications/:id')" do
    context "For every pet that the application is for" do
      it "has a button to reject the application for that specific pet" do
        within("#pets-#{@pet_1.id}") do
          expect(page).to have_button("Reject")
        
          click_button("Reject")
        end
      
        expect(page).to have_current_path("/admin/applications/#{@application.id}")
      
        within("#pets-#{@pet_1.id}") do
          expect(page).to_not have_button("Reject")
          expect(page).to_not have_button("Approve")
          expect(page).to have_content("Rejected")
        end

        within("#pets-#{@pet_2.id}") do
          expect(page).to have_button("Approve")
        end 
      end
    end
  end

  describe "Approved/Rejected Pets on one Application do not affect other Applications" do
    context "where there are two applications in the system for the same pet" do
      it "does not affect other applications when an adoption is approved/rejected" do
        within("#pets-#{@pet_1.id}") do
          click_button("Approve")
        end
        visit "/admin/applications/#{@application_2.id}" 
        # save_and_open_page
        within("#pets-#{@pet_1.id}") do
          expect(page).to have_button("Approve")
          expect(page).to have_button("Reject")
        end
      end

    end
  end
end