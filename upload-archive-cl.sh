#!/bin/bash
#
# (Above line comes out when placing in Xcode scheme)
#

LOG="/tmp/bugsplat-upload.log"

if [ ! -f "${HOME}/.bugsplat.conf" ]
then
    echo "Missing bugsplat config file: ~/.bugsplat.conf" >> $LOG 2>&1
    exit
fi

source "${HOME}/.bugsplat.conf"

if [ -z "${BUGSPLAT_USER}" ]
then
    echo "BUGSPLAT_USER must be set in ~/.bugsplat.conf" >> $LOG 2>&1
    exit
fi

if [ -z "${BUGSPLAT_PASS}" ]
then
    echo "BUGSPLAT_PASS must be set in ~/.bugsplat.conf" >> $LOG 2>&1
    exit
fi

DATE=$( /bin/date +"%Y-%m-%d" )
ARCHIVE_DIR="${HOME}/Library/Developer/Xcode/Archives/${DATE}"
ARCHIVE=$( /bin/ls -t "${ARCHIVE_DIR}" | /usr/bin/grep xcarchive | /usr/bin/sed -n 1p )

echo "Archive: ${ARCHIVE}" >> $LOG 2>&1

APP_DIR="${ARCHIVE_DIR}/${ARCHIVE}/Products/usr/local/bin"
APP="${APP_DIR}/${PRODUCT_NAME}"
echo "APP: ${APP}" >> $LOG 2>&1
pushd "${APP_DIR}"

INFO_PLIST="/tmp/${PRODUCT_NAME}-Info.plist"
rm ${INFO_PLIST}
otool -X -s __TEXT __info_plist ${PRODUCT_NAME} | sed 's/Contents.*//' | xxd -r >> $INFO_PLIST 2>&1

APP_MARKETING_VERSION=$(/usr/libexec/PlistBuddy -c "Print CFBundleShortVersionString" "${INFO_PLIST}")
APP_BUNDLE_VERSION=$(/usr/libexec/PlistBuddy -c "Print CFBundleVersion" "${INFO_PLIST}")

echo "App marketing version: ${APP_MARKETING_VERSION}" >> $LOG 2>&1
echo "App bundle version: ${APP_BUNDLE_VERSION}" >> $LOG 2>&1

APP_VERSION="${APP_MARKETING_VERSION}"

if [ -n "${APP_BUNDLE_VERSION}" ]
then
    APP_VERSION="${APP_VERSION} (${APP_BUNDLE_VERSION})"
fi

BUGSPLAT_SERVER_URL=$(/usr/libexec/PlistBuddy -c "Print BugsplatServerURL" "${INFO_PLIST}")
BUGSPLAT_SERVER_URL=${BUGSPLAT_SERVER_URL%/}

UPLOAD_URL="${BUGSPLAT_SERVER_URL}/post/plCrashReporter/symbol/"

echo "App version: ${APP_VERSION}" >> $LOG 2>&1
echo "Zipping ${ARCHIVE}" >> $LOG 2>&1

/bin/rm "/tmp/${PRODUCT_NAME}.xcarchive.zip"
cd "${ARCHIVE_DIR}/${ARCHIVE}"
/usr/bin/zip -r "/tmp/${PRODUCT_NAME}.xcarchive.zip" *
cd -

UUID_CMD_OUT=$(xcrun dwarfdump --uuid "${APP}")
UUID_CMD_OUT=$([[ "${UUID_CMD_OUT}" =~ ^(UUID: )([0-9a-zA-Z\-]+) ]] && echo ${BASH_REMATCH[2]})
echo "UUID found: ${UUID_CMD_OUT}" >> $LOG 2>&1

echo "Signing into bugsplat and storing session cookie for use in upload" >> $LOG 2>&1

COOKIEPATH="/tmp/bugsplat-cookie.txt"
rm "${COOKIEPATH}"
curl -b "${COOKIEPATH}" -c "${COOKIEPATH}" --data-urlencode "email=${BUGSPLAT_USER}" --data-urlencode "password=${BUGSPLAT_PASS}" "${BUGSPLAT_SERVER_URL}/api/authenticatev3.php"

echo "Uploading /tmp/${PRODUCT_NAME}.xcarchive.zip to ${UPLOAD_URL}" >> $LOG 2>&1

curl -i -b "${COOKIEPATH}" -c "${COOKIEPATH}" -F filedata=@"/tmp/${PRODUCT_NAME}.xcarchive.zip" -F appName="${PRODUCT_NAME}" -F appVer="${APP_VERSION}" -F buildId="${UUID_CMD_OUT}" $UPLOAD_URL >> $LOG 2>&1
