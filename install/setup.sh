#
# Comment the next line if you want to have verbose installation messages
#
FLAG_QUIET=true
FLAG_SILENT=false
FLAG_UPDATE=false
FLAG_DEBUG=false

APT_REPLACE="--ignore-installed --upgrade"
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
