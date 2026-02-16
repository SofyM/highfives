class WorkosEventCursor < ApplicationRecord
  validates :organization_id, presence: true, uniqueness: true
end
