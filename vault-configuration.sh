#!/bin/bash

# Add policies. Description is in each policy
vault policy write myapp-r -<<EOF
# Allow to read myapp secrets
path "myapp/*" {
    capabilities = ["read","list"]
}
EOF

vault policy write myapp-rw -<<EOF
# Allow to read and write myapp secrets
path "myapp/*" {
    capabilities = ["create","read","list"]
}
EOF

vault policy write myapp-rwud -<<EOF
# Allow to read, write, update and delete myapp secrets
path "myapp/*" {
    capabilities = ["create","update","delete","read","list"]
}
EOF

vault policy write jenkins-approle-policy -<<EOF
# Allow to login for AppRole
path "auth/approle/login" {
  capabilities = ["create","read"]
}

# Allow to create tokens for AppRoles
path "auth/approle/role/*" {
  capabilities = ["create","read","update"]
}
EOF

# Enable approle authentication method and configure it
vault auth enable approle 
vault auth tune -default-lease-ttl=2592000 \
    -max-lease-ttl=2592000 approle

# Create approles
vault write auth/approle/role/jenkins \
    secret_id_ttl=0 token_ttl=60m token_max_ttl=60m policies="jenkins-approle-policy"
vault write auth/approle/role/virtual-room \
    secret_id_ttl=2592000 token_ttl=60m token_max_ttl=60m policies="myapp_r"
