import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:matrixclient/modules/base/vwfilestorage/modules/vwfileencryption/vwfileencryption.dart';
import 'package:md5_file_checksum/md5_file_checksum.dart';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as encryption;

class CryptoUtil {
  static Future<Uint8List> decryptByVwFileEncryptionInfo(
      {required String fileBase64,
      required VwFileEncryption fileEncryptionInfo,
      encryption.AESMode aesMode = encryption.AESMode.cbc})  async{
    return  await CryptoUtil.decrypt(
        fileBase64: fileBase64,
        encryptionKey: fileEncryptionInfo.encryptionKey,
        encryptionIV: fileEncryptionInfo.encryptionIV.toString());
  }

  static Future<Uint8List> decrypt(
      {required String fileBase64,
      required String encryptionKey,
      required String encryptionIV,
      encryption.AESMode aesMode = encryption.AESMode.cbc})  async{
    Uint8List decryptedUint8List=Uint8List(0);
    try {
      final keyAES = encryption.Key.fromBase64(encryptionKey);
      final iv = encryption.IV.fromBase64(encryptionIV!);

      final encrypter = encryption. Encrypter(
          encryption.AES(keyAES, mode: encryption.AESMode.cbc));

      final String decryptedBase64 = encrypter.decrypt64 (fileBase64, iv: iv);

       decryptedUint8List = base64Decode(decryptedBase64);
    } catch (error) {}
    return decryptedUint8List;
  }

  static Future<String?> getFileMd5Checksum(String filePath) async {
    String? fileChecksum;
    try {
      fileChecksum = await Md5FileChecksum.getFileChecksum(filePath: filePath);
    } catch (exception) {
      print('Unable to generate file checksum: $exception');
    }
    return fileChecksum;
  }

  static String getMd5Checksum(List<int> input) {
    Digest md5hashDigestValue = md5.convert(input);

    return base64.encode(md5hashDigestValue.bytes);
  }

  static Future<String?> getFileMd5ChecksumNative(String filePath) async {
    final file = File(filePath);
    if (!file.existsSync()) return null;
    try {
      final stream = file.openRead();
      final hash = await md5.bind(stream).first;
      // NOTE: You might not need to convert it to base64
      return base64.encode(hash.bytes);
    } catch (exception) {
      return null;
    }
  }

  static String getSha256Checksum(List<int> input) {
    Digest sha256digest = sha256.convert(input);

    return base64.encode(sha256digest.bytes);
  }
}
