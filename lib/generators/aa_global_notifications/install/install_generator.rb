require 'rails/generators/active_record'

class AaGlobalNotifications::InstallGenerator < Rails::Generators::Base
  include Rails::Generators::Migration

  source_root File.expand_path('../templates', __FILE__)

  def copy_migrations
    copy_migration "create_agn_push_notifications"

    #active_admin push_notifications
    #app/admin/push_notifications.rb

    puts "Installation successful. You can now run:"
    puts "  rake db:migrate"
  end

  def copy_initializer
    template "initializer.rb", "config/initializers/aa_global_notifications.rb"
  end

  def config_active_admin
    template "push_notification.rb", "app/admin/push_notification.rb"
  end

  # This is defined in ActiveRecord::Generators::Base, but that inherits from NamedBase, so it expects a name argument
  # which we don't want here. So we redefine it here. Yuck.
  def self.next_migration_number(dirname)
    if ActiveRecord::Base.timestamped_migrations
      Time.now.utc.strftime("%Y%m%d%H%M%S%L%N")
    else
      "%.3d" % (current_migration_number(dirname) + 1)
    end
  end

  protected

  def copy_migration(filename)
    if self.class.migration_exists?("db/migrate", "#{filename}")
      say_status("skipped", "Migration #{filename}.rb already exists")
    else
      migration_template "#{filename}.rb", "db/migrate/#{filename}.rb"
    end
  end

end
