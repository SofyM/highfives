class User < ApplicationRecord
  has_many :high_fives, class_name: 'HighFive', dependent: :destroy
  validates :workos_id, presence: true, uniqueness: true
  validates :directory_user_id, uniqueness: true, allow_nil: true
  validates :email, presence: true
  validates :first_name, :last_name, presence: true

  def full_name
    "#{first_name} #{last_name}"
  end

  def self.from_sso(profile)
    user = find_by(workos_id: profile.id) || find_by(email: profile.email) || new
    user.assign_attributes(
      email: profile.email,
      first_name: profile.first_name,
      last_name: profile.last_name,
      organization_id: profile.organization_id,
      connection_id: profile.connection_id
    )
    user.workos_id = profile.id if user.workos_id.blank? || user.workos_id != profile.id
    user.save
    user
  end
end
