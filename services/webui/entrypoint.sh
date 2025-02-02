#!/bin/bash

# Set bash options for robust error handling
set -Eeuo pipefail

# Set tcmalloc as the default memory allocator
export LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libtcmalloc_minimal.so.4

echo $ROOT
ls -lha $ROOT

# Set permissive umask for new files and directories
# 000 will result in:
# - new files: 666 (rw-rw-rw-)
# - new directories: 777 (rwxrwxrwx)
umask 000

# Create outputs directory and set permissions
mkdir -p "${ROOT}/outputs"
chmod 777 "${ROOT}/outputs"

# Create the /data/config/auto directory if it doesn't exist
mkdir -vp /data/config/auto

# Set up empty configuration files if they don't exist
if [ ! -f /data/config/auto/config.json ]; then
  echo '{}' >/data/config/auto/config.json
fi

if [ ! -f /data/config/auto/ui-config.json ]; then
  echo '{}' >/data/config/auto/ui-config.json
fi

if [ ! -f /data/config/auto/styles.csv ]; then
  touch /data/config/auto/styles.csv
fi

# Define mount points and their corresponding target paths
declare -A MOUNTS
MOUNTS["/root/.cache"]="/data/.cache"
MOUNTS["${ROOT}/models"]="/data/models"
MOUNTS["${ROOT}/embeddings"]="/data/embeddings"
MOUNTS["${ROOT}/config.json"]="/data/config/auto/config.json"
MOUNTS["${ROOT}/ui-config.json"]="/data/config/auto/ui-config.json"
MOUNTS["${ROOT}/styles.csv"]="/data/config/auto/styles.csv"
MOUNTS["${ROOT}/extensions"]="/data/config/auto/extensions"
MOUNTS["${ROOT}/config_states"]="/data/config/auto/config_states"

# Loop through each mount point and create symbolic links to the data volume
for to_path in "${!MOUNTS[@]}"; do
  set -Eeuo pipefail
  from_path="${MOUNTS[${to_path}]}"
  rm -rf "${to_path}"
  if [ ! -f "$from_path" ]; then
    mkdir -vp "$from_path"
  fi
  mkdir -vp "$(dirname "${to_path}")"
  ln -sT "${from_path}" "${to_path}"
  echo Mounted $(basename "${from_path}")
done

# Execute the command passed to the script with additional CLI arguments
exec "$@" ${CLI_ARGS}
