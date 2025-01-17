import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'capture_controller.dart';
import 'framing_capture_widget.dart';

/// CaptureView is a Flutter widget for capturing images using the device's camera.
/// It provides a user interface with a live camera preview, framing guides,
/// and a capture button. After capturing an image, it can be cropped and processed
/// before being passed to a callback function.
class CaptureView extends StatefulWidget {
  /// Creates a new instance of [CaptureView].
  ///
  /// The required parameters are:
  /// - [fileCallback]: A callback function that will be called with the captured and cropped image.
  /// - [title]: The title displayed at the top of the capture screen.
  ///
  /// The optional parameter is:
  /// - [info]: Additional information or instructions displayed on the capture screen.
  const CaptureView(
      {Key? key,
      required this.fileCallback,
      required this.title,
      this.onCameraAccessDenied,
      this.info,
      this.hideIdWidget})
      : super(key: key);

  /// Callback function that receives the captured and cropped image as an [XFile].
  final Function(File imagePath) fileCallback;

  /// The title displayed at the top of the capture screen.
  final String title;

  /// Additional information or instructions displayed on the capture screen.
  final String? info;

  final bool? hideIdWidget;

  final VoidCallback? onCameraAccessDenied;

  @override
  State<CaptureView> createState() => _CaptureViewState();
}

class _CaptureViewState extends State<CaptureView> {
  CameraController? controller; // Change to nullable type
  late List<CameraDescription> cameras;
  bool isCapturing = false; // Add a flag to track capturing state

  @override
  void initState() {
    super.initState();
    initializeCameras().then((value) {
      // Initialize the camera controller with a default camera description.
      if (cameras.isEmpty) {
        controller = CameraController(
            getDefaultCameraDescription(), ResolutionPreset.ultraHigh);
      } else {
        controller =
            CameraController(cameras.first, ResolutionPreset.ultraHigh);
      }

      // Initialize the camera controller and update the UI after initialization.
      controller?.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});
      }).catchError((e) {
        if (e is CameraException &&
            e.code == 'CameraAccessDeniedWithoutPrompt') {
          widget.onCameraAccessDenied?.call();
        }
      });
    }).catchError((e) {
      if (e is CameraException && e.code == 'CameraAccessDeniedWithoutPrompt') {
        widget.onCameraAccessDenied?.call();
      }
    });
  }

  Future<void> initializeCameras() async {
    // await Permission.camera.request();
    cameras = await availableCameras();
    setState(() {}); // Refresh the widget tree after obtaining cameras
  }

  CameraDescription getDefaultCameraDescription() {
    return cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.back,
      orElse: () => cameras.first,
    );
  }

  // void _showCameraAccessDeniedDialog() {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text('Camera Access Denied'),
  //         content: const Text(
  //             'User has previously denied the camera access request. Go to Settings to enable camera access.'),
  //         actions: <Widget>[
  //           TextButton(
  //             child: const Text('OK'),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  @override
  void dispose() {
    // Dispose of the camera controller to release resources.
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        fit: StackFit.expand,
        children: [
          // Live camera preview.
          if (controller != null && controller!.value.isInitialized)
            CameraPreview(controller!),
          // Framing guides around the capture area.
          FramingCaptureWidget(
            hideIdWidget: widget.hideIdWidget ?? false,
          ),
          // UI at the top of the capture screen.
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              margin: const EdgeInsets.only(
                top: 10,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Back button.
                  IconButton(
                    onPressed: isCapturing
                        ? null
                        : () {
                            Navigator.pop(context);
                          },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                  ),
                  // Title at the top of the screen.
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Text(
                      widget.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  // Additional information or instructions.
                  if (widget.info != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      child: Text(
                        widget.info!,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                ],
              ),
            ),
          ),
          // Capture button at the bottom center.
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.black12,
                shape: BoxShape.circle,
              ),
              margin: const EdgeInsets.all(25),
              child: IconButton(
                enableFeedback: true,
                color: Colors.white,
                onPressed: isCapturing
                    ? null
                    : () async {
                        setState(() {
                          isCapturing = true;
                        });

                        // Capture an image.
                        XFile file = await controller!.takePicture();

                        // Crop the captured image.
                        File? croppedImage = await CaptureController.cropImage(
                          File(file.path),
                        );

                        // Callback to handle the cropped image.
                        widget.fileCallback(croppedImage!);

                        // Close the capture screen and callback to handle the cropped image..
                        Navigator.pop(context, croppedImage);
                      },
                icon: const Icon(
                  Icons.camera,
                ),
                iconSize: 72,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
