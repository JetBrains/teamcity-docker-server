#!/bin/bash

echo '/run-services.sh'

for entry in /services/*.sh
do
  echo "$entry"
  if [[ -f "$entry" ]]; then
      [[ ! -x "$entry" ]] && (chmod +x "$entry"; sync)
      "$entry"
  fi
done

echo '/run-agent.sh'
exec '/run-server.sh'
