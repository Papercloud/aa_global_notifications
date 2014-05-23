ActiveAdmin.register AaGlobalNotifications::PushNotification, :as => "Global Notification" do
  actions :index, :show, :create, :destroy, :new, :update, :edit

  permit_params :message

  form do |f|
    f.inputs "Push Notification" do
      f.input :message
    end
    f.actions
  end

  index do
    column :message 
    column :state
    column "Actions" do |notification|
      links = ''.html_safe
      if notification.failed?
        links << link_to("Retry", retry_admin_global_notification_path(notification), :class => "member_link", method: :put)
        links << link_to("Edit", edit_admin_global_notification_path(notification), :class => "member_link")
      end
      links << link_to("View", admin_global_notification_path(notification), :class => "member_link")
    end
  end

  member_action :retry, method: :put do
    @push_notification = AaGlobalNotifications::PushNotification.find(params[:id])
    @push_notification.retry!
    redirect_to admin_global_notifications_path, flash: { message: "Push notification has been scheduled retry" }
  end
end

