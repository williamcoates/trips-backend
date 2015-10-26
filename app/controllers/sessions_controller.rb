class SessionsController < Devise::SessionsController
  respond_to :json

  def valid
    render json: { session_valid: user_signed_in? }
  end

end
