// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
//
// class VideoRecorder extends StatefulWidget {
//   const VideoRecorder({Key? key}) : super(key: key);
//
//   @override
//   State<VideoRecorder> createState() => _VideoRecorderState();
// }
//
// class _VideoRecorderState  extends State<VideoRecorder> {
//   CameraController? controller;
//
//   bool _isRecordingInProgress = false;
//
//   Future<void> startVideoRecording() async {
//     final CameraController? cameraController = controller;
//     if (controller!.value.isRecordingVideo) {
//       // A recording has already started, do nothing.
//       return;
//     }
//     try {
//       await cameraController!.startVideoRecording();
//       setState(() {
//         _isRecordingInProgress = true;
//         print(_isRecordingInProgress);
//       });
//     } on CameraException catch (e) {
//       print('Error starting to record video: $e');
//     }
//   }
//   Future<XFile?> stopVideoRecording() async {
//     if (!cameraController!.value.isRecordingVideo) {
//       // Recording is already is stopped state
//       return null;
//     }
//     try {
//       XFile file = await cameraController!.stopVideoRecording();
//       setState(() {
//         _isRecordingInProgress = false;
//         print(_isRecordingInProgress);
//       });
//       return file;
//     } on CameraException catch (e) {
//       print('Error stopping video recording: $e');
//       return null;
//     }
//   }
//
//   Future<void> pauseVideoRecording() async {
//     if (!cameraController!.value.isRecordingVideo) {
//       // Video recording is not in progress
//       return;
//     }
//     try {
//       await cameraController!.pauseVideoRecording();
//     } on CameraException catch (e) {
//       print('Error pausing video recording: $e');
//     }
//   }
//
//   Future<void> resumeVideoRecording() async {
//     if (!cameraController!.value.isRecordingVideo) {
//       // No video recording was in progress
//       return;
//     }
//     try {
//       await cameraController!.resumeVideoRecording();
//     } on CameraException catch (e) {
//       print('Error resuming video recording: $e');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body:Column(
//         children: [
//           Container(
//             child: Center(
//               child: Text(
//                 'data',style: TextStyle(color: Colors.red,fontSize: 20),
//               ),
//             ),
//           ),
//           AspectRatio(
//             aspectRatio: 1 / cameraController!.value.aspectRatio,
//             child: cameraController!.buildPreview(),
//           )
//         ],
//       ),
//     );
//   }
// }
