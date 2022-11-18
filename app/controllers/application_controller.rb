class ApplicationController < ActionController::Base
  	before_action :set_current_user

	def logged_in_user_id
		session["user_id"]
	end
	def set_logged_in_user_id(id)
		session["user_id"] = id
	end

	helper_method :logged_in_user_id

	private
		def set_current_user
			if logged_in_user_id
				@current_user = User.find(logged_in_user_id)
			else
				@current_user = nil
			end
		end

end
