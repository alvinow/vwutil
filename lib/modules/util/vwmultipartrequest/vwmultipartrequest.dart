import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:matrixclient/modules/util/vwmultipartrequest/multipartrequestextended.dart';

typedef OnUploadProgressFunction = void Function(int bytes, int totalBytes);

class VwMultipartRequest {
  static void implementOnUploadProgressFunction(int bytes, int totalBytes) {
    int precentage = 0;

    if (bytes > 0) {
      try {
        precentage = ((bytes * 100) / totalBytes).toInt();
        //print("Upload "+totalBytes.toString()+" bytes of file  "+precentage.toString());
      } catch (error) {}
    }

    //print(bytes.toString()+" of "+ totalBytes.toString()+" ("+precentage.toString()+"%)");
  }

  static Future<http.StreamedResponse?> multipartUpload(
      {required String url,
      required List<int> bytes,
      required String fileName,
      OnUploadProgressFunction? onUploadProgressFunction}) async {
    http.StreamedResponse? response;

    try {
      if (onUploadProgressFunction == null) {
        onUploadProgressFunction =
            VwMultipartRequest.implementOnUploadProgressFunction;
      }

      var urlUri = Uri.parse(url);
      MultipartRequestExtended request = MultipartRequestExtended(
          "POST", urlUri,
          onProgress: onUploadProgressFunction);
      //request.fields['field1'] = 'field1Value';
      request.files
          .add(http.MultipartFile.fromBytes("file", bytes, filename: fileName));
      response = await request.send();
    } catch (error) {
      print("Error catched on VwMultipartRequest.multipartUpload= " +
          error.toString());
    }

    return response;
  }
}
