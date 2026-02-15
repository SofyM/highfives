class User < ApplicationRecord
  has_many :high_fives, class_name: 'HighFive', dependent: :destroy
  validates :workos_id, presence: true, uniqueness: true
  validates :email, presence: true
  validates :first_name, :last_name, presence: true

  def full_name
    "#{first_name} #{last_name}"
  end

  def self.from_sso(profile)
    user = find_or_create_by(workos_id: profile.id)
    user.update(
      email: profile.email,
      first_name: profile.first_name,
      last_name: profile.last_name,
      organization_id: profile.organization_id,
      connection_id: profile.connection_id
    )

    user
  end
end
