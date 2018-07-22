#!/usr/bin/env bash
set -e

BASE_DIR=$(cd "$(dirname "$0")"; pwd)
PROJECT_NAME="DereGuide"
PROJECT_FILE_PATH="${BASE_DIR}/../${PROJECT_NAME}.xcodeproj"
TARGET_DIR="${BASE_DIR}/${PROJECT_NAME}"

TRANSLATIONS=("en" "ja" "zh-Hant-TW" "zh-Hant")
