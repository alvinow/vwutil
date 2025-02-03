import 'package:matrixclient2base/modules/base/vwbasemodel/vwbasemodel.dart';
import 'package:matrixclient2base/modules/base/vwclassencodedjson/vwclassencodedjson.dart';
import 'package:matrixclient2base/modules/base/vwdataformat/vwdataformattimestamp/vwdataformattimestamp.dart';
import 'package:matrixclient2base/modules/base/vwdataformat/vwfiedvalue/vwfieldvalue.dart';
import 'package:matrixclient2base/modules/base/vwdataformat/vwrowdata/vwrowdata.dart';
import 'package:matrixclient2base/modules/base/vwfielddisplayformat/vwfielddisplayformat.dart';
import 'package:matrixclient2base/modules/base/vwlinknode/modules/vwlinknoderendered/vwlinknoderendered.dart';
import 'package:matrixclient2base/modules/base/vwlinknode/vwlinknode.dart';
import 'package:matrixclient2base/modules/base/vwlinkrowcollection/vwlinkrowcollection.dart';
import 'package:matrixclient2base/modules/base/vwnode/vwcontentcontext/vwcontentcontext.dart';
import 'package:matrixclient2base/modules/base/vwnode/vwnode.dart';
import 'package:matrixclient2base/modules/base/vwnode/vwnodecontent/vwnodecontent.dart';
import 'package:matrixclient2base/modules/base/vwuser/vwuser.dart';
import 'package:vwform/modules/listviewtitlecolumn/listviewtitlecolumn.dart';
import 'package:vwform/modules/remoteapi/remote_api.dart';
import 'package:vwform/modules/vwform/vwformdefinition/vwformdefinition.dart';
import 'package:vwform/modules/vwform/vwformdefinition/vwlocalfieldref/vwlocalfieldref.dart';
import 'package:vwutil/modules/util/displayformatutil.dart';

class NodeUtil {
  static void nodeToRowData(
      {required VwNode nodeSource, required VwRowData rowDataDestination}) {
    try {
      rowDataDestination
          .getOrCreateFieldByName(fieldName: "recordId")
          .valueString = nodeSource.recordId;

      rowDataDestination
          .getOrCreateFieldByName(fieldName: "displayName")
          .valueString = nodeSource.displayName;

      rowDataDestination
          .getOrCreateFieldByName(fieldName: "parentNodeId")
          .valueString = nodeSource.parentNodeId;

      rowDataDestination
          .getOrCreateFieldByName(fieldName: "nodeType")
          .valueString = nodeSource.nodeType;

      rowDataDestination
          .getOrCreateFieldByName(fieldName: "ownerUserId")
          .valueString = nodeSource.ownerUserId;

      rowDataDestination
          .getOrCreateFieldByName(fieldName: "creatorUserId")
          .valueString = nodeSource.creatorUserId;

      rowDataDestination
          .getOrCreateFieldByName(fieldName: "indexKey")
          .value = nodeSource.indexKey;

      rowDataDestination
          .getOrCreateFieldByName(fieldName: "uniqueKey")
          .valueString = nodeSource.uniqueKey;

      rowDataDestination
          .getOrCreateFieldByName(fieldName: "stateKey")
          .valueString = nodeSource.stateKey;




      if (nodeSource.timestamp != null) {
        rowDataDestination
            .getOrCreateFieldByName(fieldName: "createdtimestamp")
            .valueDateTime = nodeSource.timestamp!.created;

        rowDataDestination
            .getOrCreateFieldByName(fieldName: "updatedtimestamp")
            .valueDateTime = nodeSource.timestamp!.updated;
      }
    } catch (error) {}
  }

  static void updateNodeFromRowData(
      {required VwNode nodeDestination, required VwRowData rowDataSource}) {
    if (rowDataSource.getFieldByName("displayName") != null) {
      nodeDestination.displayName =
          rowDataSource.getFieldByName("displayName")!.valueString!.toString();
    }
  }

  static List<VwNode> getNodeListFromFieldValue(VwFieldValue fieldValue) {
    List<VwNode> returnValue = [];

    if (fieldValue.valueTypeId == VwFieldValue.vatValueLinkNodeList &&
        fieldValue.valueLinkNodeList != null) {
      returnValue = NodeUtil.extractNodeListFromLinkNodeList(
          fieldValue!.valueLinkNodeList!);
    } else if (fieldValue.valueTypeId == VwFieldValue.vatNodeList &&
        fieldValue.valueNodeList != null) {
      returnValue = fieldValue.valueNodeList!;
    }

    return returnValue;
  }

  static VwFormDefinition? extractFormDefinitionFromNode(VwNode node) {
    VwFormDefinition? returnValue;

    try {
      RemoteApi.decompressClassEncodedJson(node.content.classEncodedJson!);
      returnValue =
          VwFormDefinition.fromJson(node.content.classEncodedJson!.data!);
    } catch (error) {
      print(
          "Error catched on static VwFormDefinition? extractFormDefinitionFromNode(VwNode node) :" +
              error.toString());
    }
    return returnValue;
  }

  static VwUser? getUserClassFromLinkNodeClassEncodedJson(
      {required VwLinkNode linkNode}) {
    VwUser? returnValue;
    try {
      VwNode? currentNode = NodeUtil.getNode(linkNode: linkNode);

      returnValue =
          VwUser.fromJson(currentNode!.content!.classEncodedJson!.data!);
    } catch (error) {}
    return returnValue;
  }

  static VwFieldValue? getFieldValueFromLinkNodeRowData(
      {required String fieldName, required VwLinkNode linkNode}) {
    VwFieldValue? returnValue;
    try {
      VwNode? currentNode = NodeUtil.extractNodeFromLinkNode(linkNode);

      if (currentNode != null) {
        VwRowData? currentNodeRowData = currentNode.content.rowData;

        if (currentNodeRowData != null) {
          returnValue = currentNodeRowData!.getFieldByName(fieldName);
        }
      }
    } catch (error) {}
    return returnValue;
  }

  static List<VwLinkNode> createLinkNodeListFormNodeList(
      {required List<VwNode> nodeList}) {
    List<VwLinkNode> returnValue = [];

    for (int la = 0; la < nodeList.length; la++) {
      VwNode currentNode = nodeList.elementAt(la);

      VwLinkNode currentLinkNode =
          NodeUtil.createLinkNodeFromNode(node: currentNode);
      returnValue.add(currentLinkNode);
    }

    return returnValue;
  }

  static List<ListViewTitleColumn> createNodeResponseTitle(
      {required String creatorUserId,
      required List<VwNode> activeNodeResponseList}) {
    List<ListViewTitleColumn> returnValue = [];

    for (int la = 0; la < activeNodeResponseList.length; la++) {
      VwNode currentNode = activeNodeResponseList.elementAt(la);

      if (currentNode.creatorUserId != null &&
          currentNode.creatorUserId == creatorUserId) {
        ListViewTitleColumn currentListViewTitleColumn =
            ListViewTitleColumn(caption: "anda", flex: 1);
        returnValue.add(currentListViewTitleColumn);
      } else {
        String username = currentNode.creatorUserId!;
        if (currentNode.creatorUserLinkNode != null) {
          try {
            VwNode? userNode =
                NodeUtil.getNode(linkNode: currentNode.creatorUserLinkNode!);

            if (userNode != null) {
              VwUser user =
                  VwUser.fromJson(userNode.content.classEncodedJson!.data!);
              username = user.displayname;
            }
          } catch (error) {}
        }

        ListViewTitleColumn currentListViewTitleColumn =
            ListViewTitleColumn(caption: username, flex: 1);
        returnValue.add(currentListViewTitleColumn);
      }
    }

    return returnValue;
  }

  static List<int> getNodeIndexByNodeId(
      {required String nodeId, required List<VwNode> nodeList}) {
    List<int> returnValue = [];

    for (int la = 0; la < nodeList.length; la++) {
      VwNode currentNode = nodeList.elementAt(la);

      if (currentNode.recordId == nodeId) {
        returnValue.add(la);
      }
    }

    return returnValue;
  }

  static int deletePageTagRecordByFile(
      {required String fileStorageId, required List<VwRowData> rowDataList}) {
    int returnValue = 0;
    try {
      List<int> deletedRecord = [];
      for (int la = 0; la < rowDataList.length; la++) {
        VwRowData currentRowData = rowDataList.elementAt(la);
        VwFieldValue? fileStorageIdFieldValue =
            currentRowData.getFieldByName("fileStorageId");
        if (fileStorageIdFieldValue != null &&
            fileStorageIdFieldValue.valueString == fileStorageId) {
          deletedRecord.add(la);
        }
      }

      for (int la = deletedRecord.length - 1; la >= 0; la--) {
        int currentElement = deletedRecord.elementAt(la);
        rowDataList.removeAt(currentElement);
      }
    } catch (error) {}
    return returnValue;
  }

  /*
  static void deletePageTagNodeByFile(
      {required String fileStorageId, required List<VwLinkNode> linkNodeList}) {
    try {
      List<int> deletedListLinkNode = [];
      for (int la = 0; la < linkNodeList.length; la++) {
        VwLinkNode currentLinkNode = linkNodeList.elementAt(la);
        VwNode? currentNode = NodeUtil.extractNodeFromLinkNode(currentLinkNode);

        if (currentNode != null) {
          VwRowData? currentRowData =
              NodeUtil.getRowDataFromNodeContentRecordCollection(currentNode!);

          if (currentRowData != null) {
            String? currentCileStorageId =
                currentRowData.getFieldByName("fileStorageId")?.valueString;

            if (currentCileStorageId != null &&
                currentCileStorageId == fileStorageId) {
              deletedListLinkNode.add(la);
            }
          }
        }
      }

      for (int la = deletedListLinkNode.length - 1; la >= 0; la--) {
        int currentElement = deletedListLinkNode.elementAt(la);
        linkNodeList.removeAt(currentElement);
      }
    } catch (error) {}
  }*/

  static List<VwLinkNode> convertNodeListToLinkNodeList(
      {required List<VwNode> nodeList}) {
    List<VwLinkNode> returnValue = [];
    try {
      for (int la = 0; la < nodeList.length; la++) {
        VwNode currentNode = nodeList.elementAt(la);
        VwLinkNode currentLinkNode =
            NodeUtil.createLinkNodeFromNode(node: currentNode);
        returnValue.add(currentLinkNode);
      }
    } catch (error) {}
    return returnValue;
  }

  static String? getContentCollectionName({required VwNode node}) {
    String? returnValue;

    if (node.nodeType == VwNode.ntnRowData && node.content.rowData != null) {
      returnValue = node.content.rowData!.collectionName;
    } else if (node.nodeType == VwNode.ntnClassEncodedJson &&
        node.content.classEncodedJson != null) {
      returnValue = node.content.classEncodedJson!.collectionName;
    }

    return returnValue;
  }

  static VwLinkNode createLinkNodeFromNode({required VwNode node}) {
    VwLinkNode returnValue = VwLinkNode(
        nodeId: node.recordId,
        nodeType: node.nodeType,
        rendered: VwLinkNodeRendered(renderedDate: DateTime.now(), node: node),
        contentContext: VwContentContext(
            collectionName: NodeUtil.getContentCollectionName(node: node)));

    return returnValue;
  }

  static VwNode? getNode({required VwLinkNode linkNode}) {
    VwNode? returnValue;
    try {
      try {
        returnValue = linkNode.rendered!.node;
      } catch (error) {
        if (returnValue == null) {
          returnValue = linkNode.cache!.node;
        }
      }
    } catch (error) {}
    return returnValue;
  }

  static VwFormDefinition? getFormDefinitionFromAttachmentLinkNode(
      {required List<VwNodeContent> attachments, required String tag}) {
    VwFormDefinition? returnValue;
    try {
      List<VwNodeContent> nodeContentList = NodeUtil.extractAttachmentsByTag(
          attachments: attachments,
          nodeType: VwNode.ntnClassEncodedJson,
          tag: tag);

      if (nodeContentList.length > 0) {
        VwNodeContent currentNodeContent = attachments.elementAt(0);

        try {
          returnValue = VwFormDefinition.fromJson(currentNodeContent
              .linkNode!.rendered!.node!.content!.classEncodedJson!.data!);
        } catch (error) {}

        try {
          returnValue = VwFormDefinition.fromJson(currentNodeContent
              .linkNode!.cache!.node!.content!.classEncodedJson!.data!);
        } catch (error) {}

        try {
          returnValue = VwFormDefinition.fromJson(currentNodeContent
              .linkNode!.sync!.node!.content!.classEncodedJson!.data!);
        } catch (error) {}
      }
    } catch (error) {}
    return returnValue;
  }

  static List<String> getRecordIdListFomLinkNodeList(
      List<VwLinkNode> linkNodeList) {
    List<String> returnValue = [];
    try {
      for (int la = 0; la < linkNodeList.length; la++) {
        VwLinkNode currentLinkNode = linkNodeList.elementAt(la);

        returnValue.add(currentLinkNode.nodeId);
      }
    } catch (error) {}

    return returnValue;
  }

  static bool isLinkNodeExistOnField(
      {required List<VwLinkNode> field, required VwNode checking}) {
    bool returnValue = false;
    try {
      List<String> fieldRecordIdList =
          NodeUtil.getRecordIdListFomLinkNodeList(field);

      if (fieldRecordIdList
              .indexOf(checking.content.contentContext!.recordId.toString()) >=
          0) {
        returnValue = true;
      }
    } catch (error) {}

    return returnValue;
  }

  static VwRowData? extractRowDataFromLinkNode(VwLinkNode linkNode) {
    VwRowData? returnValue;
    try {
      returnValue = NodeUtil.extractRowDataFromNode(
          NodeUtil.extractNodeFromLinkNode(linkNode)!);
    } catch (error) {}
    return returnValue;
  }

  static VwRowData? extractRowDataFromNode(VwNode node) {
    VwRowData? returnValue;
    try {
      returnValue = node.content.rowData;
    } catch (error) {}
    return returnValue;
  }

  static VwFormDefinition? extractFormDefinitionFromContent(
      {required VwNodeContent nodeContent}) {
    VwFormDefinition? returnValue;
    try {
      VwClassEncodedJson? classEncodedJson =
          NodeUtil.extractClassEncodedJsonFromContent(nodeContent: nodeContent);

      if (classEncodedJson != null) {
        RemoteApi.decompressClassEncodedJson(classEncodedJson);

        Map<String, dynamic>? data = classEncodedJson?.data;

        if (data == null) {
          data = NodeUtil.extractBaseModel(nodeContent)!.data;
        }

        if (data != null) {
          returnValue = VwFormDefinition.fromJson(data);
        }
      }
    } catch (error) {}
    return returnValue;
  }

  static VwClassEncodedJson? extractClassEncodedJsonFromContent(
      {required VwNodeContent nodeContent}) {
    VwClassEncodedJson? returnValue;
    try {
      return nodeContent.classEncodedJson;
    } catch (error) {}

    return returnValue;
  }

  static List<VwNodeContent> extractAttachmentsByTag(
      {required List<VwNodeContent> attachments,
      required String nodeType,
      required String tag}) {
    List<VwNodeContent> returnValue = [];
    try {
      for (int la = 0; la < attachments.length; la++) {
        VwNodeContent currentNodeContent = attachments.elementAt(la);
        try {
          if (currentNodeContent.tag == tag) {
            if (nodeType == VwNode.ntnClassEncodedJson &&
                    currentNodeContent.classEncodedJson != null &&
                    currentNodeContent.classEncodedJson!.data != null ||
                (currentNodeContent.classEncodedJson!.isCompressed != null &&
                    currentNodeContent.classEncodedJson!.isCompressed == true &&
                    currentNodeContent.classEncodedJson!.dataCompressedBase64 !=
                        null)) {
              returnValue.add(currentNodeContent);
            } else if (nodeType == VwNode.ntnClassEncodedJson &&
                currentNodeContent.linkNode != null) {
              returnValue.add(currentNodeContent);
            } else if (nodeType == VwNode.ntnRowData &&
                currentNodeContent.rowData != null) {
              returnValue.add(currentNodeContent);
            }
          }
        } catch (error) {}
      }
    } catch (error) {}
    return returnValue;
  }

  static VwNode generateNodeRowData(
      {required VwRowData rowData,
      required String upsyncToken,
      required String parentNodeId,
      required String ownerUserId,
      String? creatorUserId}) {
    VwNode formResponseNode = VwNode(
        recordId: rowData.recordId,
        creatorUserId: creatorUserId != null ? creatorUserId : ownerUserId,
        timestamp: VwDataFormatTimestamp(
            created: DateTime.now(), updated: DateTime.now()),
        upsyncToken: upsyncToken,
        parentNodeId: parentNodeId,
        displayName: rowData.recordId,
        nodeType: VwNode.ntnRowData,
        ownerUserId: ownerUserId,
        content: VwNodeContent(
            contentContext: VwContentContext(
                rowDefinitionId: rowData.rowDefinitionId,
                collectionName: rowData.collectionName,
                className: "VwRowData",
                recordId: rowData.recordId,
                recordRef: rowData.ref),
            rowData: rowData));

    return formResponseNode;
  }

  static VwNode generateNodeLinkRowCollection(
      {required VwRowData rowData,
      required String upsyncToken,
      required String parentNodeId,
      required String ownerUserId}) {
    VwNode formResponseNode = VwNode(
        recordId: rowData.recordId,
        timestamp: VwDataFormatTimestamp(
            created: DateTime.now(), updated: DateTime.now()),
        upsyncToken: upsyncToken,
        parentNodeId: parentNodeId,
        displayName: rowData.recordId,
        nodeType: VwNode.ntnLinkRowCollection,
        ownerUserId: ownerUserId,
        content: VwNodeContent(
            contentContext: VwContentContext(
                rowDefinitionId: rowData.rowDefinitionId,
                collectionName: rowData.collectionName,
                className: "VwRowData",
                recordId: rowData.recordId,
                recordRef: rowData.ref),
            linkRowCollection: VwLinkRowCollection(
                recordId: rowData.recordId,
                collectionName: rowData.collectionName.toString(),
                sync: rowData)));

    return formResponseNode;
  }

  static void syncNodeToNodeList(VwNode newNode, List<VwNode> currentNodeList) {
    bool isCurrentRecordExists = false;
    for (int la = 0; la < currentNodeList.length; la++) {
      VwNode currentNode = currentNodeList.elementAt(la);

      if (currentNode.recordId == newNode.recordId) {
        currentNode = newNode;
        isCurrentRecordExists = true;
      }
    }

    if (isCurrentRecordExists == false) {
      currentNodeList.add(newNode);
    }
  }

  static void removeNodeFromNodeList(
      String nodeId, List<VwNode> currentNodeList) {
    try {
      for (int la = 0; la < currentNodeList.length; la++) {
        if (currentNodeList.elementAt(la).recordId == nodeId) {
          currentNodeList.removeAt(la);
          break;
        }
      }
    } catch (error) {}
  }

  static void removeNodeFromLinkNodeList(
      String nodeId, List<VwLinkNode> currentLinkNodeList) {
    try {
      for (int la = 0; la < currentLinkNodeList.length; la++) {
        if (currentLinkNodeList.elementAt(la).nodeId == nodeId) {
          currentLinkNodeList.removeAt(la);
          break;
        }
      }
    } catch (error) {}
  }

  static void injectNodeToLinkNodeList(
      VwNode newNode, List<VwLinkNode> currentLinkNodeList) {
    try {
      //insert to both sync, rendered and cache
      //searchBy contentId

      VwBaseModel? newNodeContentBaseModel =
          NodeUtil.getBaseModelFromContent(newNode);
      if (newNodeContentBaseModel != null) {
        VwLinkNodeRendered newLinkNodeRendered =
            VwLinkNodeRendered(renderedDate: DateTime.now(), node: newNode);

        bool isUpdated = false;
        for (int la = 0; la < currentLinkNodeList.length; la++) {
          VwLinkNode currentLinkNode = currentLinkNodeList.elementAt(la);

          if (currentLinkNode.contentContext != null &&
              currentLinkNode.contentContext!.recordId ==
                  newNodeContentBaseModel.recordId) {
            currentLinkNode.cache = newLinkNodeRendered;
            currentLinkNode.rendered = null;
            currentLinkNode.sync = null;
            currentLinkNode.contentContext = VwContentContext(
              recordId:
                  newLinkNodeRendered.node!.content.contentContext!.recordId,
              collectionName: newLinkNodeRendered
                  .node!.content.contentContext!.collectionName,
            );
            isUpdated = true;
            break;
          }
        }
        if (isUpdated == false) {
          VwLinkNode newLinkNode = VwLinkNode(
              nodeId: newNode.recordId,
              nodeType: newNode.nodeType,
              contentContext: VwContentContext(
                recordId: newNodeContentBaseModel.recordId,
                collectionName: newNodeContentBaseModel.collectionName,
              ),
              cache: newLinkNodeRendered,
              rendered: null,
              sync: null);

          currentLinkNodeList.add(newLinkNode);
        }
      }
    } catch (error) {}
  }

  static VwNode? extractNodeFromLinkNode(VwLinkNode currentLinkNode) {
    VwNode? returnValue;
    try {
      if (currentLinkNode.sync != null && currentLinkNode.sync!.node != null) {
        returnValue = currentLinkNode.sync!.node!;
      }

      if (returnValue == null &&
          currentLinkNode.rendered != null &&
          currentLinkNode.rendered!.node != null) {
        returnValue = currentLinkNode.rendered!.node!;
      }

      if (returnValue == null &&
          currentLinkNode.cache != null &&
          currentLinkNode.cache!.node != null) {
        returnValue = currentLinkNode.cache!.node!;
      }
    } catch (error) {}
    return returnValue;
  }

  static List<VwNode> extractNodeListFromLinkNodeList(
      List<VwLinkNode>? linkNodeList) {
    List<VwNode> returnValue = [];

    try {
      if (linkNodeList != null) {
        for (int la = 0; la < linkNodeList.length; la++) {
          VwLinkNode currentLinkNode = linkNodeList.elementAt(la);

          VwNode? currentNode = extractNodeFromLinkNode(currentLinkNode);

          if (currentNode != null) {
            returnValue.add(currentNode);
          }
        }
      }
      return returnValue;
    } catch (error) {}

    return [];
  }

  static VwClassEncodedJson? extractBaseModel(VwNodeContent nodeContent) {
    VwClassEncodedJson? returnValue;
    try {
      returnValue = nodeContent.linkbasemodel!.sync;
      if (returnValue == null) {
        returnValue = nodeContent.linkbasemodel!.rendered;
      }
      if (returnValue == null) {
        returnValue = nodeContent.linkbasemodel!.cache;
      }
    } catch (error) {}

    return returnValue;
  }

  static VwRowData? extractLinkRowCollection(VwNodeContent nodeContent) {
    VwRowData? returnValue;
    try {
      returnValue = nodeContent.linkRowCollection!.sync;

      if (returnValue == null) {
        returnValue = nodeContent.linkRowCollection!.rendered;
      }
      if (returnValue == null) {
        returnValue = nodeContent.linkRowCollection!.cache;
      }
    } catch (error) {}

    return returnValue;
  }

  static VwBaseModel? getBaseModelFromContent(VwNode node) {
    VwBaseModel? returnValue;
    try {
      if (node.nodeType == VwNode.ntnRowData) {
        if (node.content.rowData != null) {
          returnValue = node.content.rowData;
          node.content.rowData!.timestamp = node.timestamp;
        }
      } else if (node.nodeType == VwNode.ntnClassEncodedJson) {
        if (node.content.classEncodedJson != null &&
            node.content.classEncodedJson!.data != null) {
          returnValue =
              VwBaseModel.fromJson(node.content.classEncodedJson!.data!);
        }
      } else if (node.nodeType == VwNode.ntnLinkBaseModelCollection) {
        returnValue = VwBaseModel.fromJson(
            NodeUtil.extractBaseModel(node.content)!.data!);
      } else if (node.nodeType == VwNode.ntnLinkRowCollection) {
        returnValue = NodeUtil.extractLinkRowCollection(node.content);
      }
    } catch (error) {}

    return returnValue;
  }

  static VwRowData? convertVwBaseModelToRowData(Map<String, dynamic> object) {
    VwRowData? returnValue;

    try {
      List<VwFieldValue> fields = [];

      VwBaseModel baseModel = VwBaseModel.fromJson(object);

      for (int la = 0; la < object.keys.length; la++) {
        try {
          String currentKey = object[object.keys.elementAt(la)].toString();
          String currentElementString = object[currentKey].toString();
          dynamic currentElement = object[currentKey];

          if (currentKey == "recordId" ||
              currentKey == "timestamp" ||
              currentKey == "indexKey" ||
              currentKey == "attachments" ||
              currentKey == "collectionName" ||
              currentKey == "ref") {
            //do nothing
          } else {
            VwFieldValue currentFieldValue = VwFieldValue(
                fieldName: currentKey,
                valueString: currentElementString,
                value: currentElement);
            fields.add(currentFieldValue);
          }
        } catch (error) {
          print("Error on convertVwBaseModelToRowData: " + error.toString());
        }
      }
      returnValue = VwRowData(
          recordId: baseModel.recordId,
          timestamp: baseModel.timestamp,
          indexKey: baseModel.indexKey,
          attachments: baseModel.attachments,
          ref: baseModel.ref,
          collectionName: baseModel.collectionName,
          fields: fields);
    } catch (error) {}

    return returnValue;
  }

  static VwRowData? getRowDataFromNodeContentRecordCollection(VwNode node) {
    try {
      if (node.nodeType == VwNode.ntnRowData) {
        return node.content.rowData!;
      } else if (node.nodeType == VwNode.ntnLinkRowCollection) {
        return node.content.linkRowCollection?.rendered;
      } else if (node.nodeType == VwNode.ntnLinkBaseModelCollection) {
        return NodeUtil.convertVwBaseModelToRowData(
            node.content.linkbasemodel!.rendered!.data!);
      }
    } catch (error) {}
    return null;
  }

  static String?
      getValueStringFromContentRecordCollectionWithEnabledSubFieldName(
          VwNode node, String fieldName, String subFieldName) {
    String? returnValue;
    try {
      if (node.nodeType == VwNode.ntnRowData) {
        VwFieldValue? currentFieldValue =
            node.content!.rowData!.getFieldByName(fieldName);

        if (currentFieldValue != null) {

          if (currentFieldValue!.valueTypeId == VwFieldValue.vatValueLinkNode &&

              currentFieldValue.valueLinkNode != null) {
            VwNode? currentNode;
            if (currentFieldValue!.valueLinkNode!.rendered != null) {
              currentNode = currentFieldValue!.valueLinkNode!.rendered!.node;
            }

            if (currentNode == null &&
                currentFieldValue!.valueLinkNode!.cache != null) {
              currentNode = currentFieldValue!.valueLinkNode!.cache!.node;
            }

            if (currentNode != null) {
              if (currentNode!.content.rowData != null) {
                if (currentNode!.content.rowData!
                        .getFieldByName(subFieldName)!
                        .valueString !=
                    null) {
                  returnValue = currentNode!.content.rowData!
                      .getFieldByName(subFieldName)!
                      .valueString!;
                } else if (currentNode!.content.rowData!
                        .getFieldByName(subFieldName)!
                        .valueNumber !=
                    null) {
                  returnValue = currentNode!.content.rowData!
                      .getFieldByName(subFieldName)!
                      .valueNumber!
                      .toString();
                }
              } else if (currentNode!.content.classEncodedJson != null &&
                  currentNode!.content.classEncodedJson!.data != null) {
                returnValue = currentNode!
                    .content.classEncodedJson!.data![subFieldName]
                    .toString();
              }
            }
          }
          else if(currentFieldValue.valueTypeId==VwFieldValue.vatValueFormResponse && currentFieldValue.valueFormResponse!=null)
            {
             VwFieldValue?  currentSubFieldValue=currentFieldValue.valueFormResponse!.getFieldByName(subFieldName);

             if(currentSubFieldValue!=null)
               {
                 returnValue=currentSubFieldValue.valueString;
               }
            }
        }
      } else if (node.nodeType == VwNode.ntnLinkRowCollection) {
        VwLinkNode? currentLinkNode =
            NodeUtil.extractLinkRowCollection(node.content)!
                .getFieldByName(fieldName)!
                .valueLinkNode;

        if (currentLinkNode != null) {
          VwRowData? currentSubContentRowData =
              currentLinkNode.cache!.node!.content.linkRowCollection!.rendered;

          if (currentSubContentRowData == null) {
            currentSubContentRowData =
                currentLinkNode.cache!.node!.content.linkRowCollection!.cache;
          }

          if (currentSubContentRowData != null) {
            String? currentSubContentRowDataStringValue =
                currentSubContentRowData
                    .getFieldByName(subFieldName)!
                    .valueString;

            returnValue = currentSubContentRowDataStringValue;
          }
        }
      }
    } catch (error) {}
    return returnValue;
  }

  static DateTime?
      getValueDateTimeFromContentRecordCollectionWithEnabledSubFieldName(
          VwNode node, String fieldName, String subFieldName) {
    DateTime? returnValue;
    try {
      if (node.nodeType == VwNode.ntnLinkRowCollection) {
        returnValue = NodeUtil.extractLinkRowCollection(node.content)!
            .getFieldByName(fieldName)!
            .valueLinkNode!
            .cache!
            .node!
            .content
            .linkRowCollection!
            .rendered!
            .getFieldByName(subFieldName)!
            .valueDateTime;
      }
    } catch (error) {}
    return returnValue;
  }

  static String? getValueFromContentRecordCollection(
      {required VwNode node,
      required String fieldName,
      VwFieldDisplayFormat? fieldDisplayFormat,
      required String locale}) {
    String? returnValue;
    try {
      if (node.nodeType == VwNode.ntnRowData) {
        if (fieldName == "creatorUserId") {
          returnValue = node.content.rowData!.creatorUserId;
        } else {
          VwFieldValue? currentFieldValue =
              node.content.rowData!.getFieldByName(fieldName);

          if (currentFieldValue != null) {
            if (currentFieldValue.valueTypeId == VwFieldValue.vatString) {
              returnValue = currentFieldValue.valueString!.toString();
            } else if (currentFieldValue.valueTypeId ==
                    VwFieldValue.vatDateOnly ||
                currentFieldValue.valueTypeId == VwFieldValue.vatDateTime ||
                currentFieldValue.valueTypeId == VwFieldValue.vatTimeOnly) {
              returnValue = currentFieldValue.valueDateTime!.toString();

              if (fieldDisplayFormat != null) {
                returnValue = DisplayFormatUtil.renderDisplayFormat(
                    fieldDisplayFormat!, currentFieldValue, locale);
              }
            } else if (currentFieldValue.valueTypeId ==
                VwFieldValue.vatNumber) {
              returnValue = currentFieldValue.valueNumber!.toString();
              if (fieldDisplayFormat != null) {
                returnValue = DisplayFormatUtil.renderDisplayFormat(
                    fieldDisplayFormat!, currentFieldValue, locale);
              }
            }
          }
        }
      } else if (node.nodeType == VwNode.ntnFolder) {
        returnValue = node.toJson()[fieldName].toString();
      } else if (node.nodeType == VwNode.ntnClassEncodedJson) {
        RemoteApi.decompressClassEncodedJson(node.content.classEncodedJson!);

        if (node.content.classEncodedJson != null &&
            node.content.classEncodedJson!.data != null) {
          returnValue =
              node.content.classEncodedJson!.data![fieldName].toString();
        }
      } else if (node.nodeType == VwNode.ntnLinkBaseModelCollection) {
        returnValue = NodeUtil.extractBaseModel(node.content)!.data![fieldName];
      } else if (node.nodeType == VwNode.ntnLinkRowCollection &&
          node.content.linkRowCollection != null) {
        if (fieldName == "creatorUserId" || fieldName == "creatorUserName") {
          VwRowData? rowData;

          rowData = node.content.linkRowCollection!.rendered;

          if (rowData == null) {
            rowData = node.content.linkRowCollection!.cache;
          }

          if (rowData != null) {
            if (fieldName == "creatorUserId") {
              returnValue = rowData.creatorUserId;
            } else if (rowData!.creatorUserLinkNode != null) {
              VwNode? userNode;

              if (rowData!.creatorUserLinkNode!.rendered != null) {
                userNode = rowData!.creatorUserLinkNode!.rendered!.node;
              } else {
                userNode = rowData!.creatorUserLinkNode!.cache!.node;
              }

              if (userNode != null &&
                  NodeUtil.extractBaseModel(userNode!.content) != null) {
                try {
                  VwUser user = VwUser.fromJson(
                      NodeUtil.extractBaseModel(userNode!.content)!.data!);

                  if (fieldName == "creatorUserName") {
                    returnValue = user.username;
                  } else if (fieldName == "creatorMainRoleUserGroupId") {
                    returnValue = user.mainRoleUserGroupId;
                  } else if (fieldName == "creatorOrganizationMemberId") {
                    returnValue = user.organizationMemberId;
                  } else if (fieldName == "creatorCitizenId") {
                    returnValue = user.citizenId;
                  }
                } catch (error) {}
              }
            }
          }
        } else {
          returnValue = NodeUtil.extractLinkRowCollection(node.content)!
              .getFieldByName(fieldName)!
              .valueString;
        }
      }
    } catch (error) {}

    return returnValue;
  }
}
