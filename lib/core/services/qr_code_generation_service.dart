import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:qr/qr.dart';





class QrCodeGenerationService{

  String payLoad;
  int size;
  Color backGround;
  QrCodeGenerationService(this.payLoad,this.size,{this.backGround=Colors.white});

  Future<Uint8List> generate()async{
    final qrCode=QrCode(4, QrErrorCorrectLevel.L);
    qrCode.addData(payLoad);
    final qrImage=QrImage(qrCode);
    final image = img.Image(width: size, height: size);
    for(int x=0;x<size;x++){
      for(int y=0;y<size;y++){
        bool isDark=qrImage.isDark(y * qrCode.moduleCount ~/ size, x * qrCode.moduleCount ~/ size);
        img.Color color=isDark?img.ColorRgb8(0,0,0):img.ColorRgb8(backGround.red,backGround.green,backGround.blue);
        image.setPixel(x, y, color);
      }
    }
    Uint8List data= img.encodePng(image);
    return data;
  }

/*
* Future<Uint8List> generate() async {
    final qrCode = QrCode(4, QrErrorCorrectLevel.L);
    qrCode.addData(payLoad);
    final qrImage = QrImage(qrCode);

    final image = img.Image(width: size, height: size);
    for (int x = 0; x < size; x++) {
      for (int y = 0; y < size; y++) {
        bool isDark = qrImage.isDark(
            y * qrCode.moduleCount ~/ size, x * qrCode.moduleCount ~/ size);
        image.setPixel(x, y, isDark ? img.ColorRgb8(0, 0, 0) : img.ColorRgb8(255, 255, 255));
      }
    }

    // Convert to 1-bit (black & white) dithered image
    final ditheredImage = img.grayscale(image);
    final bwImage = img.threshold(ditheredImage, 128);

    return Uint8List.fromList(img.encodePng(bwImage));
  }
* */
  Future<Uint8List> generateQrForRecu() async {
    final qrCode = QrCode(4, QrErrorCorrectLevel.L);
    qrCode.addData(payLoad);
    final qrImage = QrImage(qrCode);

    // Create an image for the QR code
    final image = img.Image(width: size, height: size);
    for (int x = 0; x < size; x++) {
      for (int y = 0; y < size; y++) {
        bool isDark = qrImage.isDark(
            y * qrCode.moduleCount ~/ size, x * qrCode.moduleCount ~/ size);
        image.setPixel(x, y, isDark ? img.ColorRgb8(0, 0, 0) : img.ColorRgb8(255, 255, 255));
      }
    }

    // Convert to grayscale
    img.Image grayscaleImage = img.grayscale(image);

    // Apply thresholding
    for (int x = 0; x < grayscaleImage.width; x++) {
      for (int y = 0; y < grayscaleImage.height; y++) {
        img.Pixel pixel = grayscaleImage.getPixel(x, y); // Get pixel
        int brightness = img.getLuminance(pixel).toInt(); // Convert to int

        // Apply thresholding
        grayscaleImage.setPixel(x, y, brightness < 128 ? img.ColorRgb8(0, 0, 0) : img.ColorRgb8(255, 255, 255));
      }
    }

    return Uint8List.fromList(img.encodePng(grayscaleImage));
  }


}