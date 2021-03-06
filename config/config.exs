import Config

config :ex_aws,
  access_key_id: [
    {:system, "AWS_ACCESS_KEY_ID"},
    {:awscli, "default", 30},
    :instance_role
  ],
  secret_access_key: [
    {:system, "AWS_SECRET_ACCESS_KEY"},
    {:awscli, "default", 30},
    :instance_role
  ]

config :asmo,
  legacy: {"asmo-bucket-legacy", "images/avatar-\d+.png"},
  modern: {"asmo-bucket-modern", "avatar/avatar-\d+.png"},
  chunk_size: 256,
  db_pool_size: 32,
  process_pool_size: 32,
  process_timeout: 10000
