class HighFive < ApplicationRecord
  belongs_to :user
  validates :user_id, :giver_id, presence: true
end
