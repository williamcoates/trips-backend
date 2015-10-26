class ConfirmationsController < Devise::ConfirmationsController

  def show
     self.resource = resource_class.confirm_by_token(params[:confirmation_token])
     if resource.errors.empty?
       redirect_to "#{Settings.front_end_url}/?verified=true"
     else
       redirect_to "#{Settings.front_end_url}/register?confirm_error=true"
     end
   end

end
