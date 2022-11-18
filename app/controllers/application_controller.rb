class ApplicationController < ActionController::Base
	def logged_in_user_id
		session["user_id"]
	end
	def set_logged_in_user_id(id)
		session["user_id"] = id
	end
end
