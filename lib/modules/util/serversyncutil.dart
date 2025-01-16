import 'package:matrixclient2base/modules/base/vwapicall/synctokenblock/synctokenblock.dart';
import 'package:matrixclient2base/modules/base/vwclassencodedjson/vwclassencodedjson.dart';
import 'package:matrixclient2base/modules/base/vwdataformat/vwfiedvalue/vwfieldvalue.dart';
import 'package:matrixclient2base/modules/base/vwdataformat/vwrowdata/vwrowdata.dart';
import 'package:matrixclient2base/modules/base/vwfilestorage/vwfilestorage.dart';
import 'package:matrixclient2base/modules/base/vwnode/vwnode.dart';
import 'package:uuid/uuid.dart';
import 'package:vwform/modules/remoteapi/remote_api.dart';
import 'package:vwform/modules/vwnodeupsyncresultpackage/vwnodeupsyncresultpackage.dart';
import 'package:vwnodestoreonhive/vwnodestoreonhive/vwnodestoreonhive.dart';
import 'package:vwutil/modules/util/nodeutil.dart';
import 'package:vwutil/modules/util/vwdateutil.dart';

class ServerSyncUtil {
  static Future<VwNodeUpsyncResultPackage> syncNodeRowData(
      {required String graphqlServerAddress,
      required VwRowData rowData,
      List<VwFileStorage>? uploadFileStorageList,
      required String loginSessionId,
      required String ownerUserId}) async {
    VwNodeUpsyncResultPackage returnValue =
        VwNodeUpsyncResultPackage(nodeUpsyncResultList: []);
    try {
      SyncTokenBlock? syncTokenBlock = await VwNodeStoreOnHive.getToken(
          graphqlServerAddress: graphqlServerAddress,
          loginSessionId: loginSessionId.toString(),
          count: 1,
          apiCallId: "getToken");

      if (syncTokenBlock != null) {
        VwNode formResponseNode = NodeUtil.generateNodeRowData(
            rowData: rowData,
            upsyncToken: syncTokenBlock.tokenList.elementAt(0),
            parentNodeId: "response_" + rowData.formDefinitionId.toString(),
            ownerUserId: ownerUserId.toString());

        VwFieldValue fieldValueFormResponse = VwFieldValue(
            valueTypeId: VwFieldValue.vatClassEncodedJson,
            fieldName: "VwFormResponseNode",
            valueClassEncodedJson: VwClassEncodedJson(
                uploadFileStorageList: uploadFileStorageList,
                instanceId: formResponseNode.recordId,
                data: formResponseNode.toJson(),
                className: "VwNode"));

        RemoteApi.compressClassEncodedJson(
            fieldValueFormResponse.valueClassEncodedJson!);

        VwRowData apiCallParam = VwRowData(
            timestamp: VwDateUtil.nowTimestamp(),
            recordId: Uuid().v4(),
            fields: [fieldValueFormResponse]);

        returnValue = await RemoteApi.nodeUpsyncRequestApiCall(
            apiCallId: "syncNodeContent",
            apiCallParam: apiCallParam,
            loginSessionId: loginSessionId.toString());
      }
    } catch (error) {}
    return returnValue;
  }
}
