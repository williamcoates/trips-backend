# Custom Devise SessionsController, extended to add #valid method
# which returns json to indicate if session is valid
class SessionsController < Devise::SessionsController
  respond_to :json

  def valid
    render json: { session_valid: user_signed_in? }
  end
end
