class ApplicationPet < ApplicationRecord
  belongs_to :application
  belongs_to :pet
  enum application_pet_status: {"In Progress": 0, "Pending": 1, "Accepted": 2, "Rejected": 3}
end
