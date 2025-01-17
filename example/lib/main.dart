/// This Dart file contains a simple Flutter application for capturing ID images.

// Import necessary packages and files
import 'dart:io';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:capture_identity/capture_identity_new.dart';

// Main function to run the application
void main() {
  runApp(const MyApp());
}

// The main application class, `MyApp`
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Set the application title and theme
      title: 'Id Capture',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'ID Capture'), // Set the home page
    );
  }
}

// The home page of the application, `MyHomePage`
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

// The state for the home page, `_MyHomePageState`
class _MyHomePageState extends State<MyHomePage> {
  File? idCapture; // Variable to store the captured ID image file

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: GestureDetector(
          // Gesture detector for handling taps on the capture area
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
            // Container representing the capture area
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
              // Centered content inside the capture area
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
