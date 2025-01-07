import 'dart:typed_data';
import 'package:matrixclient2base/modules/base/vwfilestorage/modules/vwimagefileinfo/vwimagefileinfo.dart';
import 'package:path/path.dart' as pa;
import 'package:image/image.dart' as img;


class ImageUtil {
  static VwImageFileInfo? getImageFileInfo(String filename, Uint8List fileContent) {
    VwImageFileInfo? returnValue;
    try {
      final extension = pa.extension(filename);

      if (extension.toLowerCase() == ".png" ||
          extension.toLowerCase() == ".jpg" ||
          extension.toLowerCase() == ".jpeg") // '.dart'
      {
        img.Image? imageFile;

        if (extension.toLowerCase() == ".png") {
          imageFile = img.decodePng(fileContent);
        } else if (extension.toLowerCase() == ".jpg" ||
            extension.toLowerCase() == ".jpeg") {
          imageFile = img.decodeJpg(fileContent);
        }

        returnValue =
            VwImageFileInfo(width: imageFile!.width, height: imageFile!.height);
      }
    } catch (error) {}
    return returnValue;
  }
}
