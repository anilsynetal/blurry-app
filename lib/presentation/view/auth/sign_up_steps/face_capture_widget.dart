// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
//
// class FaceCaptureWidget extends StatelessWidget {
//   final XFile? image;
//   final double progress; // 0..1
//   final VoidCallback onTakePhoto;
//   final VoidCallback onPickGallery;
//
//   const FaceCaptureWidget({
//     super.key,
//     required this.image,
//     required this.progress,
//     required this.onTakePhoto,
//     required this.onPickGallery,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         SizedBox(height: 8),
//         _CircularPreview(image: image, progress: progress),
//         const SizedBox(height: 12),
//         Text(
//           'Position your face in the oval',
//           style: TextStyle(color: Colors.black.withOpacity(.6), fontSize: 12),
//         ),
//         const SizedBox(height: 20),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             _RoundIconButton(icon: Icons.camera_alt_outlined, onTap: onTakePhoto),
//             const SizedBox(width: 24),
//             _RoundIconButton(icon: Icons.photo_outlined, onTap: onPickGallery),
//           ],
//         ),
//       ],
//     );
//   }
// }
//
// class _CircularPreview extends StatelessWidget {
//   final XFile? image;
//   final double progress;
//   const _CircularPreview({required this.image, required this.progress});
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 220,
//       width: 220,
//       child: Stack(
//         alignment: Alignment.center,
//         children: [
//           SizedBox(
//             height: 200,
//             width: 200,
//             child: ClipOval(
//               child: image == null
//                   ? Container(
//                       color: const Color(0xFFF7F7F7),
//                       child: const Center(
//                         child: Icon(Icons.camera_alt_outlined, color: Color(0xFFB0B0B0), size: 32),
//                       ),
//                     )
//                   : Image.file(File(image!.path), fit: BoxFit.cover),
//             ),
//           ),
//           SizedBox(
//             height: 220,
//             width: 220,
//             child: TweenAnimationBuilder<double>(
//               tween: Tween(begin: 0, end: progress.clamp(0.0, 1.0)),
//               duration: const Duration(milliseconds: 200),
//               builder: (_, value, __) => CircularProgressIndicator(
//                 strokeWidth: 4,
//                 value: value == 0 ? null : value,
//                 backgroundColor: const Color(0xFFEDEDED),
//                 valueColor: const AlwaysStoppedAnimation(Color(0xFFB73B3A)),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class _RoundIconButton extends StatelessWidget {
//   final IconData icon;
//   final VoidCallback onTap;
//   const _RoundIconButton({required this.icon, required this.onTap});
//
//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: Colors.white,
//       shape: const CircleBorder(),
//       elevation: 1,
//       child: InkWell(
//         customBorder: const CircleBorder(),
//         onTap: onTap,
//         child: const Padding(
//           padding: EdgeInsets.all(16),
//           child: Icon(Icons.camera_alt_outlined, color: Colors.black87),
//         ),
//       ),
//     );
//   }
// }
