module AaGlobalNotifications
	class PushNotification < ActiveRecord::Base
		# Override point in case of collisions, plus keeps the table name tidy.
		self.table_name = "agn_push_notifications"
	end
end