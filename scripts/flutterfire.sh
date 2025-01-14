#!/usr/bin/env bash
# This script helps us to configure firebase like modify (build.gradle, project.pbxproj, ...),
# add new files (google-services.json, GoogleService-Info.plist) to the native code.
# With the option selected as default, it means we will configure it for all build types.
# Otherwise, the selected flavor will only be applied.
#
#
# Before run the script, please following steps below:
#
# [1] Install FlutterFire CLI via: dart pub global activate flutterfire_cli. Make sure flutterfire version is greater than 0.3.0
# [2] Sign-In to Firebase with command line: firebase login

# [3] First of all, You need to run with default option to configure firebase for all build types.
#     Then, you can run with the selected flavor to configure firebase for that build type.
#     For example: ./scripts/flutterfire.sh will configure firebase for all build types.
#                  ./scripts/flutterfire.sh and select the PROD flavor will configure firebase for PROD build type.

default="default";
printf "Select flavor to configure:\n"
select flavor in $default "alpha" "dev" "prg" "uat" "prd"; do
  printf "\nSelect configuration build:\n"
  select mode in "Debug" "Release"; do
      if [ $flavor = $default ]
      then
          flutterfire configure \
            --out=lib/firebase_options/firebase_options_$default.dart
      else
          source env/.env.${flavor}
          echo "Try to reading the flavor: #$FLAVOR"

          flutterfire configure \
            --platforms=android,ios \
            --out=lib/firebase_options/firebase_options_${flavor}.dart \
            --android-package-name=$PACKAGE_NAME \
            --android-out=android/app/src/${flavor}/google-services.json \
            --ios-bundle-id=$BUNDLE_ID \
            --ios-build-config=$mode-$flavor \
            --ios-out=ios/Config/$flavor/GoogleService-Info.plist
      fi
      exit 0
  done
  exit 0
done
