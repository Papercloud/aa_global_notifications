module AaGlobalNotifications
	class PushNotification < ActiveRecord::Base
		# Override point in case of collisions, plus keeps the table name tidy.
		
		include AASM

		validates :message, :length => {
		  :minimum => 1,
		  :maximum => 50
		}

		validates_presence_of :message, :state

		self.table_name = "agn_push_notifications"

		after_create :send_notification	


		aasm column: :state do
		  state :pending, :initial => true
		  state :sent
		  state :failed

		  event :mark_as_sent do
		    transitions :from => [:pending, :failed], :to => :sent
		  end

		  event :mark_as_failed do
		  	transitions :from => :pending, :to => :failed
		  end

		  event :resend_notification do
		  	transitions :from => :failed, :to => :pending
		  end
		end

		def retry!
			resend_notification!
			self.class.delay.send_notification(self.id)
		end

		def send_notification
			#schedule push notification
			self.class.delay.send_notification(self.id)
		end

		def self.send_notification(id)
			push_notification = PushNotification.find(id)
			response = push_notification.deliver

			if response.success?
				push_notification.mark_as_sent
				puts "Push notification sent successfully"
				return true
			else
				push_notification.mark_as_failed
				puts "Push notification failed"
				push_notification.errors[:base] << "Couldn't contact Urban Airship to send push notification"
				return false
			end
		end

		def deliver
			notification = {
				:aps => {
				:alert => self.message,
				:badge => 1
				}
			}
			Urbanairship.broadcast_push(notification)
		end
	end
end