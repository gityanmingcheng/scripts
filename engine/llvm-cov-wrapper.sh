#!/bin/bash


if [ "$1" = "-v" ]; then
  echo "llvm-cov-wrapper 4.2.0"
  exit 0
else
  /usr/bin/gcov "$@"
fi
