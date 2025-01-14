#!/bin/bash
# Check if mag command exists
command -v fastlane &> /dev/null

if [ $? -eq 0 ]; then
  GREEN='\033[0;32m'
  NC='\033[0m' # No Color
  echo "${GREEN}fastlane is already installed.${NC}"
else
  echo -w "warning: fastlane not found. Installing..."

  # Install the fastlane (assuming you have pub installed)
  brew install fastlane

  if [ $? -eq 0 ]; then
    echo "fastlane installation successful!"
  else
    echo "error: Error installing fastlane. Please check your internet connection and try again."
  fi
fi
