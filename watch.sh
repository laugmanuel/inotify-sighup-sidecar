#!/bin/sh
set -eu -o pipefail

WATCH_FILE="${WATCH_FILE:-"/inotifywait/tls.crt"}"
INOTIFYWAIT_OPTS="${INOTIFYWAIT_OPTS:-"-e modify -e delete -e delete_self"}"
PROCESS_NAME="${PROCESS_NAME:-"vault"}"

main()
{
  while true; do
    while [[ ! -f "$WATCH_FILE" ]]; do
      echo "$(date "+%FT%T") Waiting for ${WATCH_FILE} to created ..."
      sleep 1
    done

    echo "$(date "+%FT%T") Waiting for ${WATCH_FILE} to be deleted or modified..."
    # shellcheck disable=SC2086
    if ! inotifywait ${INOTIFYWAIT_OPTS} "${WATCH_FILE}"; then
      echo "$(date "+%FT%T") WARNING: inotifywait exited with code $?"
    fi

    # small grace period before sending SIGHUP
    sleep 1

    echo "$(date "+%FT%T") sending SIGHUP to ${PROCESS_NAME}"
    if ! pkill -HUP "${PROCESS_NAME}"; then
      echo "$(date "+%FT%T") WARNING: 'pkill' exited with code $?"
    fi
  done
}

main "$@"
