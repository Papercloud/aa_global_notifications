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

		after_commit :send_notification, on: :create

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

		def self.pubnub
		  pubnub ||= Pubnub.new(
		            :origin => ENV['PN_ORIGIN'],
		            :publish_key   => ENV['PN_PUBLISH_KEY'],
		            :subscribe_key => ENV['PN_SUBSCRIBE_KEY'],
		            :secret_key => ENV['PN_SECRET_KEY'],
		            :logger => Logger.new(STDERR)
		          )
		end

		def self.send_notification(id)
			push_notification = PushNotification.find(id)
			push_notification.mark_as_sent!

			User.all.find_in_batches do |group|
			  group.each do |user|
			  	PushNotification.delay.deliver(id, user.uuid)
			  end
			end

		end

		def self.deliver(id, channel_id)
			push_notification = PushNotification.find(id)
			pn_apns = {
				aps: {
				  alert: push_notification.message,
				  type: "GlobalNotification"

				}
			}

			pn_gcm = {
			  data: {
			    message: push_notification.message,
			    type: "GlobalNotification"
			  }
			}

			response = pubnub.publish(
			  channel: channel_id,
			  http_sync: true,
			  message: {
			    pn_apns: pn_apns,
			    pn_gcm: pn_gcm
			  }
			)
			
			return response
		end
	end
end