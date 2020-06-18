#!/usr/bin/bash
# This script is used as the entry point for the docker image.
# It will initialize the database if it isn't already present.

if [ ! -f "$SRP_ROOT/db/master.db" ]; then
    echo "First run detected. Initializing database..."
    ruby "$SRP_ROOT/scripts/first_time.rb"
fi

if [ ! -f "$SRP_ROOT/cert.pem" ]; then
    echo "Create an new Certificate"
    ruby "$SRP_ROOT/scripts/cert_create.rb"
fi

# CMD ["ruby", "serpico.rb"]
ruby serpico.rb

