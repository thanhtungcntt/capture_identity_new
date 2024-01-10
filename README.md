# Id Capture Flutter Package

## Overview

The **Id Capture** Flutter package is designed to provide a simple and customizable solution for capturing images of various identification documents, including ID cards, passports, and credit cards. This package utilizes Flutter for the user interface and leverages the `capture_identity` library for capturing ID images.

| (1)                                                                                                                         | (2)                                                                                                                         | (3)                                                                                                                   |
| ------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------- |
| <img src="https://github.com/mohamed296/capture_identity/blob/main/assets/1.jpeg?raw=true?raw=true" alt="1" width="100"> | <img src="https://github.com/mohamed296/capture_identity/blob/main/assets/2.jpeg?raw=true?raw=true" alt="2" width="100"> | <img src="https://github.com/mohamed296/capture_identity/blob/main/assets/3.jpeg?raw=true?raw=true" alt="1" width="100">                                                                                                  |


## Getting Started

### Installation

### iOS

Add two rows to the `ios/Runner/Info.plist`:

* one with the key `Privacy - Camera Usage Description` and a usage description.
  
If editing `Info.plist` as text, add:

```xml
<key>NSCameraUsageDescription</key>
<string>your usage description here</string>
```

### Android

Change the minimum Android sdk version to 21 (or higher) in your `android/app/build.gradle` file.

```groovy
minSdkVersion 21
```

NOTE: this package is build based on camera package (https://pub.dev/packages/camera)
### 2. Usage

#### Using `showCapture` Dialog

```dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:capture_identity/capture_identity.dart';

// ... (Rest of the code remains the same)

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File? idCapture;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: GestureDetector(
          onTap: () async {
            // Show the ID capture dialog and update the state with the captured image
            idCapture = await showCapture(
              context: context,
              title: "Scan ID",
              hideIdWidget: false,
            );
            setState(() {});
          },
          child: Container(
            height: MediaQuery.of(context).size.height * 0.28,
            margin: const EdgeInsets.all(15),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    width: 3, color: Colors.deepOrange.withOpacity(0.4)),
                image: idCapture == null
                    ? null
                    : DecorationImage(image: FileImage(idCapture!))),
            child: Center(
              child: idCapture == null
                  ? Icon(
                      Icons.camera_alt,
                      color: Colors.deepOrange.withOpacity(0.4),
                      size: 30,
                    )
                  : null,
            ),
          ),
        ),
      ),
    );
  }
}
```

#### Using `CaptureView` Widget

```dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:capture_identity/capture_identity.dart';

// ... (Rest of the code remains the same)

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File? idCapture;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: GestureDetector(
          onTap: () async {
            // Navigate to the CaptureView widget and update the state with the captured image
            idCapture = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CaptureView(
                  fileCallback: (imagePath) {},
                  title: "Scan ID",
                  hideIdWidget: false,
                ),
              ),
            );
            setState(() {});
          },
          child: Container(
            height: MediaQuery.of(context).size.height * 0.28,
            margin: const EdgeInsets.all(15),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    width: 3, color: Colors.deepOrange.withOpacity(0.4)),
                image: idCapture == null
                    ? null
                    : DecorationImage(image: FileImage(idCapture!))),
            child: Center(
              child: idCapture == null
                  ? Icon(
                      Icons.camera_alt,
                      color: Colors.deepOrange.withOpacity(0.4),
                      size: 30,
                    )
                  : null,
            ),
          ),
        ),
      ),
    );
  }
}
```

## Features

- **Customization:** The package provides various customization options, such as configuring the capture title and hiding the ID widget. Explore the `showCapture` function for additional customization.

## Example

This example demonstrates how to capture ID images using either the `showCapture` dialog or the `CaptureView` widget. Choose the approach that best fits your application's requirements.

## License

```
MIT License

Copyright (c) 2023 Mohamed Abdelkhalek.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
