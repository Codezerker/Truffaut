ARCHIVE_PATH=$1
EXPORT_PATH=$2

xcodebuild \
	-exportArchive \
	-exportFormat app \
	-archivePath "${ARCHIVE_PATH}" \
	-exportPath "${EXPORT_PATH}" \
	-exportWithOriginalSigningIdentity
