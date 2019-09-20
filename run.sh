#!/bin/sh
case "$1" in
    elastalert|elastalert-create-index|elastalert-test-rule)
        program="$1"
        shift
        echo "$program" --config /opt/elastalert/config/config.yaml "$@"
        exec "$program" --config /opt/elastalert/config/config.yaml "$@"
        ;;
    *)
        echo "Usage: elastalert|elastalert-create-index|elastalert-test-rule [options]"
        echo "Command will be invoked with --config and given options"
        ;;
esac
