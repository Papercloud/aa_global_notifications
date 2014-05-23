AaGlobalNotifications.setup do |config|


	#urbanairship configuration probably should get the user to add this themselves
	Urbanairship.application_key = 'application-key'
	Urbanairship.application_secret = 'application-secret'
	Urbanairship.master_secret = 'master-secret'
	Urbanairship.logger = Rails.logger
	Urbanairship.request_timeout = 5 # default
end

