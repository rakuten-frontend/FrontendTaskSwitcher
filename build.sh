#!/bin/sh

# Created by Ogasawara, Tsutomu | Oga | CWDD on 1/29/15.
# Copyright (c) 2015 Rakuten, Inc. All rights reserved.

SDK="macosx10.10"
CONFIGURATION="Release"
PROJ_FILE_PATH="FrontendTaskSwitcher.xcodeproj"
TARGET_NAME="FrontendTaskSwitcher"

# clean
xcodebuild clean -project "${PROJ_FILE_PATH}"

# build
xcodebuild -project "${PROJ_FILE_PATH}" -sdk "${SDK}" -configuration "${CONFIGURATION}" -target "${TARGET_NAME}"
