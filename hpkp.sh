#!/bin/sh
set -eu

if ! $(command -v openssl >/dev/null 2>&1); then
	echo >&2 "Error: ${0} requires openssl, which seems to be unavailable on this system."
	exit 1
fi

if [ "${#}" -lt 1 ]; then
	echo 'Generate a HPKP header from one or more PEM certificates'
	echo "Usage: ${0} CERTIFICATE..."
	echo "${0} (C) 2016 Pascal Ernster"
	echo "${0} is licensed under the GNU General Public License v3.0"
	echo '
This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see https://www.gnu.org/licenses/.'
	exit 1
fi

hpkp()
{
	local FILE="${@}"
	if [ -r "${FILE}" ]; then
		echo -n "pin-sha256=\"$(openssl x509 -in "${FILE}" -pubkey -noout | openssl enc -base64 -d | openssl dgst -sha256 -binary | openssl enc -base64)\";"
	else
		echo >&2 "Error: File \"${FILE}\" could not be read."
		exit 1
	fi
}

HPKPHEADER='Public-Key-Pins:'
for ARG in $(seq 1 ${#}); do
	eval "FILE=\${$ARG}"
	HPKPHEADER="${HPKPHEADER} $(hpkp ${FILE})"
done

echo "${HPKPHEADER} max-age=5184000; includeSubDomains"
