#!/bin/bash

# Check if flutterfire command exists
command -v flutterfire &> /dev/null

if [ $? -eq 0 ]; then
  echo "FlutterFire CLI is already installed."
else
  echo "warning: FlutterFire CLI not found. Installing..."

  # Install the FlutterFire CLI (assuming you have pub installed)
  dart pub global activate flutterfire_cli

  if [ $? -eq 0 ]; then
    echo "FlutterFire CLI installation successful!"
  else
    echo "error: Error installing FlutterFire CLI. Please check your internet connection and try again."
  fi
fi
