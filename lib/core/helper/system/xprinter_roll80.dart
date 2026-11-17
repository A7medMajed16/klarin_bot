// import 'dart:developer';
// import 'dart:io';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bluetooth_printer/flutter_bluetooth_printer.dart';
// import 'package:flutter_bluetooth_printer/flutter_bluetooth_printer_library.dart';
// import 'package:go_router/go_router.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';
// import 'package:va_note/core/config/storage/cache_helper.dart';
// import 'package:printing/printing.dart';
// import 'package:screenshot/screenshot.dart';

// import '../../routes/app_router.dart';
// import '../../utils/constants/app_strings.dart';

// class XPrinterMdSoft {
//   Uint8List? bytes;
//   final double paperSizeInMm;
//   BuildContext? context;

//   XPrinterMdSoft({required this.context, this.paperSizeInMm = 71.5});

//   ScreenshotController controller = ScreenshotController();
//   static bool isBluetoothPrinter(String printerName) {
//     return RegExp(
//       r'^([0-9A-Fa-f]{2}:){5}[0-9A-Fa-f]{2}$',
//     ).hasMatch(printerName);
//   }

//   static Future<void> pdfSilentPrint({
//     required BuildContext context,
//     required pw.Document pdf,
//     String? cachePrinterKey,
//     String? printerName,
//   }) async {
//     try {
//       if (printerName != null ||
//           SP.getString(key: cachePrinterKey ?? AppStrings.cachedMainPrinter) !=
//               null) {
//         final printer =
//             printerName ??
//             SP.getString(key: cachePrinterKey ?? AppStrings.cachedMainPrinter)!;
//         if (isBluetoothPrinter(printer)) {
//           _printBluetoothReceipt(context: context, address: printer, pdf: pdf);
//           return;
//         } else if (printer == 'Sunmi') {
//           await printPwDocumentOnSunmi(pdf);
//           return;
//         }
//         if (Platform.isWindows || kIsWeb) {
//           await Printing.directPrintPdf(
//             usePrinterSettings: true,
//             onLayout: (PdfPageFormat format) async => pdf.save(),
//             printer: Printer(url: printer, isDefault: true),
//           );
//         }
//       } else {
//         Printer? pri = await Printing.pickPrinter(
//           context: navigatorKey.currentContext!,
//         );
//         if (pri != null) {
//           _setDefaultPrinter(
//             printerName: pri.name,
//             cachePrinterKey: cachePrinterKey,
//           );
//         }
//         await Printing.directPrintPdf(
//           usePrinterSettings: true,
//           onLayout: (PdfPageFormat format) async => pdf.save(),
//           printer: pri!,
//         );
//       }
//     } catch (e) {
//       debugPrint('Error printing PDF: $e');
//     }
//   }

//   static void _setDefaultPrinter({
//     String? cachePrinterKey,
//     required String printerName,
//   }) async {
//     SP.setString(
//       key: cachePrinterKey ?? AppStrings.cachedMainPrinter,
//       value: printerName,
//     );
//   }

//   static Future<void> _printBluetoothReceipt({
//     required BuildContext context,
//     required String address,
//     required pw.Document pdf,
//   }) async {
//     ReceiptController? receiptController;
//     final Uint8List pdfBytes = await pdf.save();
//     final PdfRaster page = await Printing.raster(pdfBytes, dpi: 150).first;
//     final pagePng = await page.toPng();
//     if (context.mounted) {
//       showDialog(
//         context: context,
//         builder: (context) {
//           return Receipt(
//             onInitialized: (controller) {
//               receiptController = controller;
//               receiptController?.paperSize = PaperSize.mm80;
//             },
//             builder: (context) {
//               return AlertDialog(
//                 content: SizedBox(
//                   width: 700,
//                   child: Image.memory(
//                     pagePng, // نطلعها PNG مباشرة
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       );
//     }
//     Future.delayed(const Duration(seconds: 3), () async {
//       log('${receiptController.runtimeType} ####');
//       await receiptController?.print(
//         address: address,
//         addFeeds: 1,
//         keepConnected: true,
//       );
//       if (context.mounted) {
//         context.pop();
//       }
//     });
//   }

//   static Future<void> printPwDocumentOnSunmi(pw.Document pdf) async {
//     final Uint8List pdfBytes = await pdf.save();
//     final pages = Printing.raster(pdfBytes, dpi: 135);
//     await for (final page in pages) {
//       final Uint8List img = await page.toPng();
//       await SunmiPrinter.printImage(img);
//       await SunmiPrinter.lineWrap(10);
//     }
//   }
// }
