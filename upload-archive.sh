#!/bin/bash
#
# (Above line comes out when placing in Xcode scheme)
#

DATABASE=""
BUGSPLAT_USER=""
BUGSPLAT_PASS=""
#BUGSPLAT_DOMAIN="${DATABASE}.bugsplatsoftware.com"
BUGSPLAT_DOMAIN="oban.bugsplatsoftware.com"
UPLOAD_URL="https://${BUGSPLAT_DOMAIN}/post/plCrashReporter/symbol/"

LOG="/tmp/bugsplat-upload.log"
DATE=$( /bin/date +"%Y-%m-%d" )
ARCHIVE_DIR="${HOME}/Library/Developer/Xcode/Archives/${DATE}"
ARCHIVE=$( /bin/ls -t "${ARCHIVE_DIR}" | /usr/bin/grep xcarchive | /usr/bin/sed -n 1p )

echo "Archive: ${ARCHIVE}" > $LOG 2>&1

APP="${ARCHIVE_DIR}/${ARCHIVE}/Products/Applications/${PRODUCT_NAME}.app"
APP_VERSION=$(/usr/libexec/PlistBuddy -c "Print CFBundleShortVersionString" "${APP}/Contents/Info.plist")

echo "App version: ${APP_VERSION}" >> $LOG 2>&1
echo "Zipping ${ARCHIVE}" >> $LOG 2>&1

/bin/rm "/tmp/${PRODUCT_NAME}.xcarchive.zip"
cd "${ARCHIVE_DIR}/${ARCHIVE}"
/usr/bin/zip -r "/tmp/${PRODUCT_NAME}.xcarchive.zip" *
cd -

UUID_CMD_OUT=$(xcrun dwarfdump --uuid "${APP}/Contents/MacOS/${PRODUCT_NAME}")
UUID_CMD_OUT=$([[ "${UUID_CMD_OUT}" =~ ^(UUID: )([0-9a-zA-Z\-]+) ]] && echo ${BASH_REMATCH[2]})
echo "UUID found: ${UUID_CMD_OUT}" > $LOG 2>&1

echo "Signing into bugsplat and storing session cookie for use in upload" >> $LOG 2>&1

COOKIEPATH="/tmp/bugsplat-cookie.txt"
rm "${COOKIEPATH}"
curl -b "${COOKIEPATH}" -c "${COOKIEPATH}" "https://${BUGSPLAT_DOMAIN}/login"
curl -b "${COOKIEPATH}" -c "${COOKIEPATH}" --data "currusername=${BUGSPLAT_USER}&currpasswd=${BUGSPLAT_PASS}" "https://${BUGSPLAT_DOMAIN}/browse/login.php"

echo "Uploading /tmp/${PRODUCT_NAME}.xcarchive.zip to ${UPLOAD_URL}" >> $LOG 2>&1

curl -i -b "${COOKIEPATH}" -c "${COOKIEPATH}" -F filedata=@"/tmp/${PRODUCT_NAME}.xcarchive.zip" -F appName="${PRODUCT_NAME}" -F appVer="${APP_VERSION}" -F database="${DATABASE}" -F buildId="${UUID_CMD_OUT}" $UPLOAD_URL >> $LOG 2>&1
