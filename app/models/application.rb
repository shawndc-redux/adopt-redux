class Application < ApplicationRecord
  validates :address, :city, :state, :name, :zip, presence: true
  enum status: {"In Progress": 0, "Pending": 1, "Accepted": 2, "Rejected": 3}
  has_many :application_pets
  has_many :pets, through: :application_pets
end