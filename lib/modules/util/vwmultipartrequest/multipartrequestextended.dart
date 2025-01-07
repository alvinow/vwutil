import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:vwutil/modules/util/vwmultipartrequest/vwmultipartrequest.dart';

class MultipartRequestExtended extends http.MultipartRequest {
  /// Creates a new [MultipartRequest].
  MultipartRequestExtended(
      String method,
      Uri url, {
      required  this.onProgress,
      }) : super(method, url);

  final OnUploadProgressFunction onProgress;

  /// Freezes all mutable fields and returns a
  /// single-subscription [http.ByteStream]
  /// that will emit the request body.
  @override
  http.ByteStream finalize() {
    final byteStream = super.finalize();
    if (onProgress == null) return byteStream;

    final total = contentLength;
    var bytes = 0;

    final t = StreamTransformer.fromHandlers(
      handleData: (List<int> data, EventSink<List<int>> sink) {
        
        bytes += data.length;
        onProgress?.call(bytes, total);
        sink.add(data);

      },
    );
    final stream = byteStream.transform(t);
    return http.ByteStream(stream);
  }
}