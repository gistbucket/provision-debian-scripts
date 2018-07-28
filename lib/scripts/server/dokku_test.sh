#!/usr/bin/env bash

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

dokku_domain=${dokku_domain:-localtest.me}

dokku version
dokku domains:report | grep -Eq "vhosts:\s+${dokku_domain}"
dokku plugin:list | grep -Eq '^\s+(postgres|letsencrypt|http-auth|redirect|maintenance)\b'

goss -g - validate --format documentation <<-EOF
	service:
	  docker:
	    enabled: true
	    running: true
	group:
	  docker:
	    exists: true
	user:
	  dokku:
	    exists: true
	    groups:
	    - docker
	    home: /home/dokku
	group:
	  dokku:
	    exists: true
EOF
