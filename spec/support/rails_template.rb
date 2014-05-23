# rake "db:drop:all"
# rake "db:create:all"

# generate :model, 'user email:string'
generate "aa_global_notifications:install"

# Finalise
rake "db:migrate"
rake "db:test:prepare"