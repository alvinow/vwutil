import 'package:matrixclient2base/modules/base/vwnode/vwnode.dart';

class NodeResponseUtil {
  static List<VwNode> getNodeResponseByFieldName(
      {required List<VwNode> renderedNodeResponseList,
      required String fieldName}) {
    List<VwNode> returnValue = [];

    for (int la = 0; la < renderedNodeResponseList.length; la++) {
      VwNode currentNode = renderedNodeResponseList.elementAt(la);
      if (currentNode.responseInfo != null &&
          currentNode.responseInfo!.contextTypeId != null &&
          currentNode.responseInfo!.contextId != null &&
          currentNode.responseInfo!.contextTypeId == "fieldName" &&
          currentNode.responseInfo!.contextId == fieldName) {
        returnValue.add(currentNode);
      }
    }

    return returnValue;
  }

  static List<VwNode> getNodeResponseByFieldNameAndUserId({
    required List<VwNode> renderedNodeResponseList,
    required String fieldName,
    required String userId,
  }) {
    List<VwNode> returnValue = [];

    for (int la = 0; la < renderedNodeResponseList.length; la++) {
      VwNode currentNode = renderedNodeResponseList.elementAt(la);
      if (currentNode.creatorUserId == userId &&
          currentNode.responseInfo != null &&
          currentNode.responseInfo!.contextTypeId != null &&
          currentNode.responseInfo!.contextId != null &&
          currentNode.responseInfo!.contextTypeId == "fieldName" &&
          currentNode.responseInfo!.contextId == fieldName) {
        returnValue.add(currentNode);
      }
    }

    return returnValue;
  }
}
