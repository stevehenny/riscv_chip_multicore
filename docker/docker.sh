#!/bin/bash

# Function to find the root of the Git repository
find_git_root() {
  # Start from the current directory and look for the .git directory
  local dir="$PWD"
  while [[ "$dir" != "/" ]]; do
    if [[ -d "$dir/.git" ]]; then
      echo "$dir"
      return
    fi
    dir=$(dirname "$dir")
  done
  echo "No Git repository found."
  exit 1
}

# Find the root of the Git repository
ROOT_REPO=$(find_git_root)

# Define container name and image name
CONTAINER_NAME="verilator_container"  # Change this to your desired container name
IMAGE_NAME="chip_env"           # Change this to your Docker image name

# Run the Docker container with the volume mounted
docker run --rm -v "$ROOT_REPO":/mnt/repo --name "$CONTAINER_NAME" -it "$IMAGE_NAME"

