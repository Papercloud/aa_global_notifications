require 'spec_helper'

describe AaGlobalNotifications::PushNotification do

	it "has valid factory" do
		push_notification = build(:push_notification)
		push_notification.should be_valid
	end

	describe "scheduling" do
		before :each do

		end
		it "creating a push notification hits send_notification method and deliver" do
			AaGlobalNotifications::PushNotification
							.any_instance.should_receive(:deliver)
							.and_call_original

			AaGlobalNotifications::PushNotification.should_receive(:send_notification)
							.and_call_original

			push_notification = create(:push_notification)
		end

		it "failing notification sets state to failed" do
			AaGlobalNotifications::PushNotification.stub(:response).and_return(false)
			push_notification = create(:push_notification)
		end

		it "retrying a failed notification sets its status to pending" do
			AaGlobalNotifications::PushNotification.stub(:response).and_return(false)
			push_notification = create(:push_notification)
			push_notification.mark_as_failed!
			push_notification.failed?.should eq true

			push_notification.retry!
			push_notification.pending?.should eq true
		end
	end

	describe "states" do
		it "creating a push_notification sets it to pending" do
			push_notification = create(:push_notification)
			push_notification.pending?.should eq true
		end
	end

	describe "validations" do
		it "message between 1 and 50 characters is valid" do
			push_notification = build(:push_notification, message: "this is a valid message")
			push_notification.should be_valid
		end

		it "message greater than 50 characters is invalid" do
			long_string = str = "this" * 50

			push_notification = build(:push_notification, message: long_string)
			push_notification.should_not be_valid
		end

		it "message less than 1 character is invalid" do
			push_notification = build(:push_notification, message: "")
			push_notification.should_not be_valid
		end
	end
end