class HighFivesController < ApplicationController
  def create
    recipient_id = params[:recipient_id]
    giver_id = session[:user_id]

    high_fives_store[recipient_id] ||= []
    high_fives_store[recipient_id] << {
      giver_id: giver_id,
      timestamp: Time.current
    }

    if request.xhr?
      head :ok
    else
      redirect_back fallback_location: home_path
    end
  end
end
