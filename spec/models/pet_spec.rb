require "rails_helper"

RSpec.describe Pet, type: :model do
  describe "relationships" do
    it { should belong_to(:shelter) }
    it { should have_many(:application_pets) }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:age) }
    it { should validate_numericality_of(:age) }
  end

  before(:each) do
    @shelter_1 = Shelter.create(name: "Aurora shelter", city: "Aurora, CO", foster_program: false, rank: 9)
    @pet_1 = @shelter_1.pets.create(name: "Mr. Pirate", breed: "tuxedo shorthair", age: 5, adoptable: true)
    @pet_2 = @shelter_1.pets.create(name: "Clawdia", breed: "shorthair", age: 3, adoptable: true)
    @pet_3 = @shelter_1.pets.create(name: "Ann", breed: "ragdoll", age: 3, adoptable: false)
    @app = Application.create(name: "Quinn", address: "2000 South Ave", city: "Chicago", state: "IL", zip: "12345", status: 1, description: "I love animals") 
    
    @app.add_pet(@pet_1)
  end

  describe "class methods" do
    describe "#search" do
      it "returns partial matches" do
        expect(Pet.search("Claw")).to eq([@pet_2])
      end
    end

    describe "#adoptable" do
      it "returns adoptable pets" do
        expect(Pet.adoptable).to eq([@pet_1, @pet_2])
      end
    end

    describe "#search_for_pet" do
      it "returns partial matches" do
        expect(Pet.search_for_pet("Claw")).to eq([@pet_2])
      end
    end
  end

  describe "instance methods" do
    describe ".shelter_name" do
      it "returns the shelter name for the given pet" do
        expect(@pet_3.shelter_name).to eq(@shelter_1.name)
      end
    end

    describe ".accepted" do
      it "returns true if an accepted application pet exists for that pet/app" do
        @pet_1.application_pets[0].update!(application_pet_status: "Accepted")
        expect(@pet_1.accepted(@app.id)).to eq true
      end
    end

    describe ".rejected" do
      it "returns true if an rejected application pet exists for that pet/app" do
        @pet_1.application_pets[0].update!(application_pet_status: "Rejected")
        expect(@pet_1.rejected(@app.id)).to eq true
      end
    end
  end
end
