#!/bin/sh
case "$1" in
    elastalert|elastalert-create-index|elastalert-test-rule)
        shift
        exec "$1" --config /opt/config/config.yaml "$@"
        ;;
    *)
        echo "Usage: elastalert|elastalert-create-index|elastalert-test-rule [options]"
        echo "Command will be invoked with --config and given options"
        ;;
esac
