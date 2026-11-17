// import 'package:flutter/material.dart';
// import 'package:mobile_scanner/mobile_scanner.dart';

// import '../../common/widgets/custom_appbar.dart';

// class QRCodeScannerHelper {
//   static Future<String?> scanQRCode(BuildContext context) async {
//     return await Navigator.of(context).push(
//       MaterialPageRoute(
//         builder: (context) => const _QRCodeScannerScreen(),
//       ),
//     );
//   }
// }

// class _QRCodeScannerScreen extends StatefulWidget {
//   const _QRCodeScannerScreen();

//   @override
//   State<_QRCodeScannerScreen> createState() => _QRCodeScannerScreenState();
// }

// class _QRCodeScannerScreenState extends State<_QRCodeScannerScreen> {
//   bool _isScanned = false;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: customAppBar(context: context),
//       body: Stack(
//         children: [
//           MobileScanner(
//             controller: MobileScannerController(
//               detectionSpeed: DetectionSpeed.noDuplicates,
//               facing: CameraFacing.back,
//               returnImage: false,
//             ),
//             onDetect: (capture) {
//               if (_isScanned) return;
//               final List<Barcode> barcodes = capture.barcodes;
//               if (barcodes.isNotEmpty && barcodes.first.rawValue != null) {
//                 _isScanned = true;
//                 Navigator.of(context).pop(barcodes.first.rawValue);
//               }
//             },
//           ),
//           Center(
//             child: Container(
//               decoration: BoxDecoration(
//                 border: Border.all(color: Colors.black, width: 4),
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               width: 200,
//               height: 200,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
