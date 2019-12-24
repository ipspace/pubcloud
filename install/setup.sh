#
# Which cloud providers do you want to work with?
#
USE_AZURE=true
USE_AWS=true
#
# Installation flags
#
FLAG_QUIET=true
FLAG_SILENT=true
FLAG_UPDATE=true
FLAG_DEBUG=false
#
# Stop changing the script right here ;)
#
QUIET=
APT_REPLACE="--ignore-installed --upgrade"

# Get rid of dpkg-preconfigure error messages
export DEBIAN_FRONTEND=noninteractive

if $FLAG_QUIET || $FLAG_SILENT; then
  QUIET="-qq"
fi

run() {
  if $FLAG_SILENT; then
    "$@" >/dev/null
  elif $FLAG_DEBUG; then
    echo "executing: $@"
    "$@"
  else
    "$@"
  fi
}
