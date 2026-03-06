class Pet < ApplicationRecord
  validates :name, presence: true
  validates :age, presence: true, numericality: true
  belongs_to :shelter
  has_many :application_pets
  has_many :applications, through: :application_pets

  def shelter_name
    shelter.name
  end

  def self.adoptable
    where(adoptable: true)
  end

  def self.search_for_pet(search)
    where('lower(name) like ?', "%#{search.downcase}%")
  end

  def accepted(app_id)
    !(ApplicationPet.where(pet_id: self.id).where(application_id: app_id).where(application_pet_status: "Accepted")).empty?
  end

  def rejected(app_id)
    !(ApplicationPet.where(pet_id: self.id).where(application_id: app_id).where(application_pet_status: "Rejected")).empty?
  end
end
