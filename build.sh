#!/usr/bin/env bash
set -euo pipefail

if [[ -z "${THEOS:-}" && -f "${HOME}/.bashrc" ]]; then
	# shellcheck disable=SC1090
	source "${HOME}/.bashrc" || true
fi

if [[ -z "${THEOS:-}" && -d "/opt/theos" ]]; then
	export THEOS="/opt/theos"
fi

if [[ -z "${THEOS:-}" ]]; then
	echo "error: THEOS is not set. Export THEOS=/path/to/theos (or put it in ~/.bashrc)." >&2
	exit 1
fi

APP_NAME="EzTap"

make clean
make

APP_PATH=""
while IFS= read -r -d '' match; do
	APP_PATH="${match}"
	break
done < <(find .theos/obj -type d -name "${APP_NAME}.app" -print0 2>/dev/null)

if [[ -z "${APP_PATH}" ]]; then
	echo "error: build output not found under .theos/obj (expected ${APP_NAME}.app)." >&2
	exit 1
fi

STAGE_DIR="$(mktemp -d)"
trap 'rm -rf "${STAGE_DIR}"' EXIT

PAYLOAD_DIR="${STAGE_DIR}/Payload"
mkdir -p "${PAYLOAD_DIR}"
cp -r "${APP_PATH}" "${PAYLOAD_DIR}/"

rm -f test.ipa test.tipa
(cd "${STAGE_DIR}" && zip -r "${OLDPWD}/test.ipa" Payload)
mv test.ipa test.tipa

echo Done.
