# docker-compose up -d

# # Wait for the hasura to be up
# bash -c 'while [[ "$(curl https://hasura-endpoint.rocketgraph.io/healthz)" != "OK" ]]; do sleep 5; done'

# # # Get the ip address
# IP_ADDRESS=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)
# # GET the instance id
# INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
# # Metadata
# METADATA_URL=https://rocketgraph.io/metadata/project-state

# # And then post it to the project state to finish setting up databases
# curl -d '{
#     "type": "FINISHED_BOOTING_HASURA"
#     "instance_ip": "'$IP_ADDRESS'",
#     "instance_id": "'$INSTANCE_ID'"
# }
# ' -H "Content-Type: application/json" \
#   -X POST https://rocketgraph.io/metadata/project-state/

# Connect DB
# Modify this to be able to add AWS RDS as
# backend database
# curl -d '{
#   "type": "pg_add_source",
#   "args": {
#     "name": "postgres",
#     "configuration": {
#       "connection_info": {
#         "database_url": {
#           "from_env": "PG_DATABASE_URL"
#         },
#         "pool_settings": {
#           "retries": 1,
#           "idle_timeout": 180,
#           "max_connections": 50
#         }
#       }
#     }
#   }
# }
# ' -H "Content-Type: application/json" \
#   -H "X-Hasura-Role: admin" \
#   -H "X-hasura-admin-secret: kaushik_replace_hasura_secret" \
#   -X POST http://localhost:8080/v1/metadata

# curl -d '{
#   "type": "pg_add_source",
#   "args": {
#     "name": "postgres",
#     "configuration": {
#       "connection_info": {
#         "database_url": {
#           "name": "postgres",
#           "password": "POSTGRESQL_PASSWORD",
#           "database": "postgres",
#           "host": "host",
#           "port": "port"
#         },
#         "pool_settings": {
#           "retries": 1,
#           "idle_timeout": 180,
#           "max_connections": 50
#         }
#       }
#     }
#   }
# }
# ' -H "Content-Type: application/json" \
#   -H "X-Hasura-Role: admin" \
#   -H "X-hasura-admin-secret: myadminsecretkey" \
#   -X POST http://localhost:8080/v1/metadata

# Create users table
curl -d '
    {
        "type": "run_sql",
        "source": "AWS RDS Production Database",
        "args": {
            "source": "AWS RDS Production Database",
            "cascade": true,
            "sql": "CREATE TABLE users(id uuid NOT NULL DEFAULT gen_random_uuid(), name text, email text NOT NULL, passwordhash text, PRIMARY KEY (id));"
        }
    }
' -H "Content-Type: application/json" \
  -H "X-Hasura-Role: admin" \
  -H "X-hasura-admin-secret: myadminsecretkey" \
  -X POST https://hasura-endpoint.rocketgraph.io/v2/query

# Create customers table
curl -d '
    {
        "type": "run_sql",
        "source": "AWS RDS Production Database",
        "args": {
            "source": "AWS RDS Production Database",
            "cascade": true,
            "sql": "CREATE TABLE Customers(id uuid NOT NULL DEFAULT gen_random_uuid(), email text, stripe_id text, PRIMARY KEY (id));"
        }
    }
' -H "Content-Type: application/json" \
  -H "X-Hasura-Role: admin" \
  -H "X-hasura-admin-secret: myadminsecretkey" \
  -X POST https://hasura-endpoint.rocketgraph.io/v2/query

# Create instances table
curl -d '
    {
        "type": "run_sql",
        "source": "AWS RDS Production Database",
        "args": {
            "source": "AWS RDS Production Database",
            "cascade": true,
            "sql": "CREATE TABLE Instances(id uuid NOT NULL DEFAULT gen_random_uuid(), name text, owner text, ip_address text, hasura_endpoint text, hasura_secret text, instance_id text, postgresql_endpoint text, postgres_password text, state text, user_id UUID, backend_endpoint text, serverless text, lambda_endpoint text, db_instance_identifier text, aws_rds_state text, PRIMARY KEY (id));"
        }
    }
' -H "Content-Type: application/json" \
  -H "X-Hasura-Role: admin" \
  -H "X-hasura-admin-secret: myadminsecretkey" \
  -X POST https://hasura-endpoint.rocketgraph.io/v2/query

# Create commits table
curl -d '
    {
        "type": "run_sql",
        "source": "AWS RDS Production Database",
        "args": {
            "source": "AWS RDS Production Database",
            "cascade": true,
            "sql": "CREATE TABLE commits(id uuid NOT NULL DEFAULT gen_random_uuid(), repo_id text, commit_id text, message text, name text, email text, username text, author text, PRIMARY KEY (id));"
        }
    }
' -H "Content-Type: application/json" \
  -H "X-Hasura-Role: admin" \
  -H "X-hasura-admin-secret: myadminsecretkey" \
  -X POST https://hasura-endpoint.rocketgraph.io/v2/query

# Create serverless table table
curl -d '
    {
        "type": "run_sql",
        "source": "AWS RDS Production Database",
        "args": {
            "source": "AWS RDS Production Database",
            "cascade": true,
            "sql": "CREATE TABLE Serverless(id uuid NOT NULL DEFAULT gen_random_uuid(), filename text, function_name text, installation_id text, instance_id text, url text, username text, author text, PRIMARY KEY (id));"
        }
    }
' -H "Content-Type: application/json" \
  -H "X-Hasura-Role: admin" \
  -H "X-hasura-admin-secret: myadminsecretkey" \
  -X POST https://hasura-endpoint.rocketgraph.io/v2/query
