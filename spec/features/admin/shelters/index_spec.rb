require "rails_helper"

RSpec.describe "Admin Shelters Index" do
  before(:each) do
    @shelter_1 = Shelter.create(name: "Aurora shelter", city: "Aurora, CO", foster_program: false, rank: 9)
    @shelter_2 = Shelter.create(name: "RGV animal shelter", city: "Harlingen, TX", foster_program: false, rank: 5)
    @shelter_3 = Shelter.create(name: "Fancy pets of Colorado", city: "Denver, CO", foster_program: true, rank: 10)
    @shelter_4 = Shelter.create(name: "Mystery Building", city: "Irvine CA", foster_program: false, rank: 9)

    @shelter_1.pets.create!(name: "Mr. Pirate", breed: "tuxedo shorthair", age: 5, adoptable: true)
    @shelter_1.pets.create!(name: "Clawdia", breed: "shorthair", age: 3, adoptable: true)
    @shelter_3.pets.create!(name: "Lucille Bald", breed: "sphynx", age: 8, adoptable: true)
    @bruno = Pet.create!(adoptable: true, age: 3, breed: "doberman", name: "Bruno", shelter_id: @shelter_1.id)
    @shelter_4.pets.create!(adoptable: true, age: 7, breed: "pitbull", name: "Trixie")
    @bailey = Pet.create!(adoptable: true, age: 3, breed: "doberman", name: "Bailey", shelter_id: @shelter_4.id)
    @trevor = Application.create!(name: "Trevor Smith", address: "815 Ardsma Ave", city: "Providence", state: "RI", zip: "02904", description: "I am a good person.", status: "Pending")  
    @john = Application.create!(name: "John Smith", address: "376 Amherst Street", city: "Providence", state: "RI", zip: "02904", description: "I am a good person.", status: "Pending")
    @application = Application.create!(name: "Shawn", address: "1800 North Ave", city: "Chicago", state: "IL", zip: "12345", status: 0, description: "I love animals") 
    @application_2 = Application.create!(name: "Quinn", address: "2000 South Ave", city: "Chicago", state: "IL", zip: "12345", status: 0, description: "I love animals") 
    @trevor.add_pet(@bruno)
    @john.add_pet(@bailey)
    visit "/admin/shelters"
  end

  describe "Admin Shelters Index Sorting" do
    context "When I visit the admin shelter index ('/admin/shelters')" do
      it "shows all Shelters in the system listed in reverse alphabetical order by name" do
        expect(@shelter_2.name).to appear_before(@shelter_3.name)
        expect(@shelter_3.name).to appear_before(@shelter_1.name)
      end
    end
  end

  describe "Shelters with Pending Applications" do
    context "When I visit the admin shelter index ('/admin/shelters')" do
      context "I see a section for Shelters with Pending Applications" do
        it "has the name of every shelter that has a pending application" do
          within("#pending") do
            expect(page).to have_content("Shelters with Pending Applications")
            expect(page).to have_content(@shelter_1.name)
            expect(page).to have_content(@shelter_4.name)
            expect(page).to_not have_content(@shelter_2.name)
            expect(page).to_not have_content(@shelter_3.name)
          end
        end
      end
    end
  end
end