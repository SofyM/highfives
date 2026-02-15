class HomeController < ApplicationController
  def index
    render template: 'index'
  end

  def random_high_five
    return render :random_high_five if request.get?

    users = User.all
    random_user = users.sample

    if random_user
      HighFive.create(
        user_id: random_user.id,
        giver_id: session[:user_id]
      )

      render json: {
        name: random_user.full_name
      }
    else
      render json: { error: "No users found" }, status: :not_found
    end
  end
end
