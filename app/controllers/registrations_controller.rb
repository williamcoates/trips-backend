class RegistrationsController < Devise::RegistrationsController
  # Disable CSRF checks. This is OK as we only allow JSON requests from our site
  # so we aren't vulnerable to CSRF (https://github.com/pillarjs/understanding-csrf)
  skip_before_action :verify_authenticity_token
  respond_to :json
end
