import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
class IoUtil{

  static Future<String?> getContentBase64({required String filePath}) async{
  try {
    Uint8List? contentUint8List = await IoUtil.getContentAsBytes(
        filePath: filePath);
    if(contentUint8List!=null) {
      return base64.encode(contentUint8List);
    }
  }
  catch(error) {}
    return null;
  }

  static Future<Uint8List> getContentAsBytes({required String filePath}) async{
    Uint8List returnValue=Uint8List.fromList([]);
    try {
      File imagefile = File(filePath);
      returnValue= await imagefile.readAsBytes();
    }
    catch(error) {}
    return returnValue;
    }

}