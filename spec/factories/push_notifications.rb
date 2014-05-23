FactoryGirl.define do
  factory :push_notification, :class => 'AaGlobalNotifications::PushNotification' do
    message "This is a push notification message"
  end
end
