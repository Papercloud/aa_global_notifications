rake "db:drop:all"
rake "db:create:all"

# generate :model, 'user email:string'
# generate "notify_user:install"

# Finalise
rake "db:migrate"
rake "db:test:prepare"