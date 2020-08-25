#!/bin/bash
# Author: Yevgeniy Goncharov aka xck, http://sys-adm.in

#
PATH=$PATH:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin
SCRIPT_PATH=$(cd `dirname "${BASH_SOURCE[0]}"` && pwd)

me=`basename "$0"`

if [[ $# -eq 0 ]]; then
    echo "Usage: ./$me <ip address>"
    exit 1
fi

## 8884,1442:udp,5225,1887 in /etc/knockd.conf
ipaddr="${1}"
for port in '8884:tcp' '1442:udp' '5225:tcp' '1887:tcp'; do {
    echo "${port}"
    proto="$(awk -F: '{print $2}' <<< "${port}")"
    port="$(awk -F: '{print $1}' <<< "${port}")"
    case "${proto}" in
        "tcp") nc "${ipaddr}" "${port}"
            ;;
        "udp") echo close | nc "${ipaddr}" -u "${port}"
            ;;
        *) echo "Failed: Invalid Protocol"
    esac
}
done
