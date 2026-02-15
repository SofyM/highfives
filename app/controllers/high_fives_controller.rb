class HighFivesController < ApplicationController
  def create
    recipient_id = params[:recipient_id]
    giver_id = session[:user_id]

    HighFive.create(
      user_id: recipient_id,
      giver_id: giver_id
    )

    if request.xhr?
      head :ok
    else
      redirect_back fallback_location: home_path
    end
  end
end
