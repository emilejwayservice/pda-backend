import 'dart:convert';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart';
import 'package:pda/config.dart';

class EncryptionService {
  late Encrypter encrypter;
  final IV iv = IV.fromLength(16); // Fixed IV (not random)

  EncryptionService() {
    final keyBytes = base64.decode(secretKey);

    if (keyBytes.length != 32) {
      throw ArgumentError("AES-256 requires a 32-byte key, but got ${keyBytes.length} bytes.");
    }

    final key = Key(keyBytes);
    encrypter = Encrypter(AES(key, mode: AESMode.cbc));
  }

  /// Encrypt and return IV + Encrypted text in Base64
  String encrypt(String input) {
    final encrypted = encrypter.encrypt(input, iv: iv);
    final combined = iv.bytes + encrypted.bytes; // Store IV + Encrypted data together
    return base64.encode(combined);
  }

  /// Decrypt using IV + Encrypted text
  String decrypt(String encoded) {
    final combined = base64.decode(encoded);
    final extractedIv = IV(Uint8List.fromList(combined.sublist(0, 16))); // Extract IV
    final encryptedBytes = combined.sublist(16); // Extract encrypted data

    final decrypted = encrypter.decrypt(Encrypted(encryptedBytes), iv: extractedIv);
    return decrypted;
  }
}
