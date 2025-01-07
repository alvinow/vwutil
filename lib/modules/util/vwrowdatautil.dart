import 'dart:convert';

import 'package:matrixclient2base/modules/base/vwdataformat/vwfiedvalue/vwfieldvalue.dart';
import 'package:matrixclient2base/modules/base/vwdataformat/vwrowdata/vwrowdata.dart';
import 'package:matrixclient2base/modules/base/vwlinknode/vwlinknode.dart';
import 'package:matrixclient2base/modules/base/vwnode/vwnode.dart';
import 'package:matrixclient2base/modules/base/vwuser/vwuser.dart';
import 'package:vwform/modules/listviewtitlecolumn/listviewtitlecolumn.dart';
import 'package:vwform/modules/vwform/vwformdefinition/vwformdefinition.dart';
import 'package:vwutil/modules/util/nodeutil.dart';

class VwRowDataUtil {

  static  void applyPresetValue(
  {required VwRowData targetFormResponse,required  VwRowData presetValues,required  VwFormDefinition formDefinition}) {
    try {
      if (presetValues != null) {
        targetFormResponse.recordId = presetValues!.recordId;
        for (int la = 0; la < presetValues!.fields!.length; la++) {
          VwFieldValue? presetFieldValue =
          presetValues!.fields!.elementAt(la);

          VwFieldValue? newRecordFieldValue =
          targetFormResponse.getFieldByName(presetFieldValue.fieldName);

          if (newRecordFieldValue == null) {
            if (targetFormResponse.fields == null) {
              targetFormResponse.fields = [];
            }
            targetFormResponse.fields!.add(presetFieldValue);
          } else {
            newRecordFieldValue.copyFrom(presetFieldValue);
          }


        }
      }
    } catch (error) {}
  }


  static VwRowData? copyRowDataInstance(VwRowData rowData){
    VwRowData? returnValue;
    try
        {
           Map<String,dynamic> newInstanceRowDataPre = rowData.toJson();

           String newInstanceRowDataString=json.encode(newInstanceRowDataPre) ;

           Map<String,dynamic> newInstanceRowDataPost=json.decode(newInstanceRowDataString);

           returnValue=VwRowData.fromJson(newInstanceRowDataPost);

        }
        catch(error)
    {

    }
    return returnValue;
  }

  static void updateFields(
      {required VwRowData current, required VwRowData candidate}) {
    try {
      List<VwFieldValue> updatedFields = [];
      List<VwFieldValue> nonUpdatedFields = [];
      List<VwFieldValue> newFields = [];

      if (current.fields != null && candidate.fields != null) {
        for (int la = 0; la < current.fields!.length; la++) {
          VwFieldValue currentFieldValue = current.fields!.elementAt(la);

          VwFieldValue? candidateFieldValue =
              candidate.getFieldByName(currentFieldValue.fieldName);

          if (candidateFieldValue != null) {
            updatedFields.add(candidateFieldValue);
          } else {
            nonUpdatedFields.add(currentFieldValue);
          }
        }

        for (int la = 0; la < candidate.fields!.length; la++) {
          VwFieldValue candidateFieldValue = candidate.fields!.elementAt(la);

          VwFieldValue? currentFieldValue =
              current.getFieldByName(candidateFieldValue.fieldName);

          if (currentFieldValue == null) {
            newFields.add(candidateFieldValue);
          }
        }
      }
      current.fields=[];
      current.fields!.addAll(updatedFields);
      current.fields!.addAll(nonUpdatedFields);
      current.fields!.addAll(newFields);
    } catch (error) {}
  }

  static List<String> getRecordIdListFromRowDataList(
      {required List<VwRowData> rowDataList}) {
    List<String> returnValue = [];
    try {
      for (int la = 0; la < rowDataList.length; la++) {
        VwRowData currentRowData = rowDataList.elementAt(la);

        returnValue.add(currentRowData.recordId);
      }
    } catch (error) {}
    return returnValue;
  }

  static void removeRowDataList(
      {required List<VwRowData> rowDataList,
      required List<String> deletedRowDataRecordIdList}) {
    try {
      List<int> indexDeletedList = [];

      for (int la = 0; la < rowDataList.length; la++) {
        VwRowData currentRowData = rowDataList.elementAt(la);
        if (deletedRowDataRecordIdList.contains(currentRowData.recordId) ==
            true) {
          indexDeletedList.add(la);
        }
      }

      int originalLength = rowDataList.length;
      for (int la = originalLength; la > 0; la--) {
        for (int lb = 0; lb < indexDeletedList.length; lb++) {
          int currentDeletedIndexValue = indexDeletedList.elementAt(lb);
          if (currentDeletedIndexValue == la) {
            rowDataList.removeAt(la);
          }
        }
      }
    } catch (error) {}
  }

  static void unsetValueLinkNodeRendered(VwRowData formResponse) {
    try {
      if (formResponse.syncFormResponseList != null) {
        List<VwRowData> currentRowDataList = formResponse.syncFormResponseList!;
        for (int la = 0; la < currentRowDataList.length; la++) {
          VwRowData currentRecord = currentRowDataList![la];
          unsetValueLinkNodeRendered(currentRecord);
        }
      }

      if (formResponse.renderedFormResponseList != null) {
        List<VwRowData> currentRowDataList =
            formResponse.renderedFormResponseList!;
        for (int la = 0; la < currentRowDataList.length; la++) {
          VwRowData currentRecord = currentRowDataList![la];
          unsetValueLinkNodeRendered(currentRecord);
        }
      }

      for (int la = 0; la < formResponse.fields!.length; la++) {
        VwFieldValue currentFieldValue = formResponse.fields!.elementAt(la);

        if (currentFieldValue.valueLinkNode != null) {
          currentFieldValue.valueLinkNode!.cache = null;
          currentFieldValue.valueLinkNode!.rendered = null;
        }

        if (currentFieldValue.valueLinkNodeList != null) {
          for (int lb = 0;
              lb < currentFieldValue.valueLinkNodeList!.length;
              lb++) {
            VwLinkNode currentLinkNode =
                currentFieldValue.valueLinkNodeList![lb];
            currentLinkNode.rendered = null;
            currentLinkNode.cache = null;
          }
        }

        if (currentFieldValue.valueFormResponse != null) {
          VwRowDataUtil.unsetValueLinkNodeRendered(
              currentFieldValue.valueFormResponse!);
        }

        if (currentFieldValue.valueRowData != null) {
          VwRowDataUtil.unsetValueLinkNodeRendered(
              currentFieldValue.valueRowData!);
        }
      }
    } catch (error) {}
  }

  static void cleanFieldValueRenderedFormResponseList(VwRowData formResponse) {
    try {
      if (formResponse.renderedFormResponseList != null) {
        formResponse.renderedFormResponseList = null;
      }
      for (int la = 0; la < formResponse.fields!.length; la++) {
        VwFieldValue currentFieldValue = formResponse.fields!.elementAt(la);
        currentFieldValue.renderedFormResponseList = null;
        //currentFieldValue.syncFormResponseList=null;

        if (currentFieldValue.valueRowData != null) {
          VwRowDataUtil.cleanFieldValueRenderedFormResponseList(
              currentFieldValue.valueRowData!);
        }

        if (currentFieldValue.valueFormResponse != null) {
          VwRowDataUtil.cleanFieldValueRenderedFormResponseList(
              currentFieldValue.valueFormResponse!);
        }
      }
    } catch (error) {}
  }

  static List<ListViewTitleColumn> createFormResponseTitle(
      {required String creatorUserId,
      required List<VwRowData> formResponseList}) {
    List<ListViewTitleColumn> returnValue = [];

    for (int la = 0; la < formResponseList.length; la++) {
      VwRowData currentNode = formResponseList.elementAt(la);

      if (currentNode.creatorUserId != null &&
          currentNode.creatorUserId == creatorUserId) {
        ListViewTitleColumn currentListViewTitleColumn =
            ListViewTitleColumn(caption: "anda", flex: 1);
        returnValue.add(currentListViewTitleColumn);
      } else {
        String username= currentNode.creatorUserId!;
        if(currentNode.creatorUserLinkNode!=null) {
          try {
            VwNode? userNode=  NodeUtil.getNode(linkNode: currentNode.creatorUserLinkNode!);

            if(userNode!=null)
            {
              VwUser user=VwUser.fromJson(userNode.content.classEncodedJson!.data!);
              username=user.displayname;
            }

          }
          catch(error)
          {

          }
        }


        ListViewTitleColumn currentListViewTitleColumn =
            ListViewTitleColumn(caption: username, flex: 1);
        returnValue.add(currentListViewTitleColumn);
      }
    }

    return returnValue;
  }

  static List<int> getIndexById(
      {required String recordId, required List<VwRowData> rowDataList}) {
    List<int> returnValue = [];

    for (int la = 0; la < rowDataList.length; la++) {
      VwRowData currentNode = rowDataList.elementAt(la);

      if (currentNode.recordId == recordId) {
        returnValue.add(la);
      }
    }

    return returnValue;
  }

  static List<VwRowData> getFormResponseByRecordId(
      {required List<VwRowData> formResponseList, required String recordId}) {
    List<VwRowData> returnValue = [];

    for (int la = 0; la < formResponseList.length; la++) {
      VwRowData currentNode = formResponseList.elementAt(la);
      if (currentNode == recordId) {
        returnValue.add(currentNode);
      }
    }

    return returnValue;
  }

  static List<VwRowData> getFormResponseByFieldName(
      {required List<VwRowData> formResponseList,
      required String fieldName,
      bool? readOnly = false}) {
    List<VwRowData> returnValue = [];

    for (int la = 0; la < formResponseList.length; la++) {
      VwRowData currentNode = formResponseList.elementAt(la);
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

  static List<VwRowData> getFormResponseByFieldNameAndUserId({
    required List<VwRowData> formResponseList,
    required String fieldName,
    required String userId,
  }) {
    List<VwRowData> returnValue = [];

    for (int la = 0; la < formResponseList.length; la++) {
      VwRowData currentNode = formResponseList.elementAt(la);
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

  static isEqual(
      {required VwFieldValue ref, required VwFieldValue currentFieldValue}) {
    bool returnValue = true;
    if (ref.valueTypeId == VwFieldValue.vatString) {
      if (ref.valueString != null) {
        returnValue = false;

        if (currentFieldValue.valueString != null &&
            (ref.valueString == currentFieldValue.valueString) == true) {
          returnValue = true;
        }
      }
    } else if (ref.valueTypeId == VwFieldValue.vatNumber) {
      if (ref.valueNumber != null) {
        returnValue = false;

        if (currentFieldValue.valueNumber != null &&
            (ref.valueNumber == currentFieldValue.valueNumber) == true) {
          returnValue = true;
        }
      }
    } else if (ref.valueTypeId == VwFieldValue.vatBoolean) {
      if (ref.valueBoolean != null) {
        returnValue = false;

        if (currentFieldValue.valueBoolean != null &&
            (ref.valueBoolean == currentFieldValue.valueBoolean) == true) {
          returnValue = true;
        }
      }
    }
    return returnValue;
  }

  static isFilterPassed({required VwRowData filter, required VwRowData input}) {
    bool returnValue = true;
    try {
      if (filter.fields != null && filter.fields!.length > 0) {
        for (int la = 0; la < filter.fields!.length; la++) {
          VwFieldValue currentFieldValueFilter = filter.fields!.elementAt(la);

          VwFieldValue? currentInputFieldValue =
              input.getFieldByName(currentFieldValueFilter.fieldName);

          if (currentInputFieldValue == null) {
            returnValue = false;
            break;
          } else if (VwRowDataUtil.isEqual(
                  ref: currentFieldValueFilter,
                  currentFieldValue: currentInputFieldValue) ==
              false) {
            returnValue = false;
            break;
          }
        }
      }
    } catch (error) {}
    return returnValue;
  }

  static List<String> getStringList(
      {required List<VwRowData> rowDataList, required String fieldName}) {
    List<String> returnValue = [];

    for (int la = 0; la < rowDataList.length; la++) {
      VwRowData currentRowData = rowDataList.elementAt(la);
      VwFieldValue? choiceValueFieldValue =
          currentRowData.getFieldByName(fieldName);
      if (choiceValueFieldValue != null &&
          choiceValueFieldValue.valueString != null) {
        String choiceValue = choiceValueFieldValue.valueString!;
        returnValue.add(choiceValue);
      }
    }
    return returnValue;
  }
}
