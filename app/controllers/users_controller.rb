class UsersController < ApplicationController
  def index
    @users = User.all.map do |user|
      {
        'id' => user.id,
        'first_name' => user.first_name,
        'last_name' => user.last_name,
        'email' => user.email,
        'high_fives_received' => user.high_fives.count,
        'custom_attributes' => {
          'team' => 'Team' # Placeholder
        }
      }
    end.sort_by { |user| user['id'] == current_user['id'] ? 0 : 1 }
    render template: 'users'
  end
end
