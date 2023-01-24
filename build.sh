#!/bin/bash

set -eo pipefail

function build {
	make -C "$1" build-docker
}

function publish-staging {
	make -C "$1" publish-staging
}

function publish-release {
	make -C "$1" publish-release
}

function validate {
	make --quiet -C "$1" validate-docker
}

dirs=()

for dir in *; do
  if [ -f "${dir}/Makefile" ]; then
    dirs+=("$dir")
  fi
done

case "$1" in
	build) 
		for workflow in "${dirs[@]}"; do
      echo "Building $workflow"
      build "$workflow"
		done
	;;
	publish-staging)
		for workflow in "${dirs[@]}"; do
      echo "Publish-staging $workflow"
      publish-staging "$workflow"
		done
	;;
	publish-release)
		for workflow in "${dirs[@]}"; do
      echo "Publishing release: $workflow"
      publish-release "$workflow"
		done
	;;
	validate)
		for workflow in "${dirs[@]}"; do
      echo "Validating docker: $workflow"
      validate "$workflow"
		done
	;;
esac
