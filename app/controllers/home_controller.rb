class HomeController < ApplicationController
  def index
    render template: 'index'
  end

  def random_high_five
    return render(template: 'random_high_five') if request.get?

    users = [
      { 'id' => 'alice-johnson', 'first_name' => 'Alice', 'last_name' => 'Johnson' },
      { 'id' => 'bob-smith', 'first_name' => 'Bob', 'last_name' => 'Smith' },
      { 'id' => 'carol-williams', 'first_name' => 'Carol', 'last_name' => 'Williams' },
      { 'id' => 'david-brown', 'first_name' => 'David', 'last_name' => 'Brown' },
      { 'id' => 'emma-davis', 'first_name' => 'Emma', 'last_name' => 'Davis' },
      { 'id' => 'frank-miller', 'first_name' => 'Frank', 'last_name' => 'Miller' }
    ]

    random_user = users.sample

    if random_user
      high_fives_store[random_user['id']] ||= []
      high_fives_store[random_user['id']] << {
        giver_id: session[:user_id],
        timestamp: Time.current
      }

      render json: {
        name: "#{random_user['first_name']} #{random_user['last_name']}"
      }
    else
      render json: { error: "No users found" }, status: :not_found
    end
  end
end
