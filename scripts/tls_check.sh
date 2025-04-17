#!/bin/bash

# Array of TLS versions to check
tls_versions=("-tls1" "-tls1_1" "-tls1_2" "-tls1_3")

# Checks TLS versions for each argument
for website in "$@"
do
  for tls_option in "${tls_versions[@]}"
  do
    # Commands to execute for each TLS version
    output=$(openssl s_client -connect "$website":443 "$tls_option" 2>&1)
    certificate=$(echo "$output" | grep "BEGIN CERTIFICATE")
    no_certificate=$(echo "$output" | grep "no peer certificate available")

    echo -n "$website ${tls_option//-tls/TLS} response .... " # Use -n to avoid a newline

    if [ -n "$certificate" ]; then
      echo "certificate received"
    elif [ -n "$no_certificate" ]; then
      echo "no peer certificate available"
    else
      echo "error"
    fi
  done
  echo "-X-X-X-X-" # Print the separator after checking all TLS versions for a website
done