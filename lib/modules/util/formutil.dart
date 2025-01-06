import 'package:matrixclient/modules/base/vwdataformat/vwfiedvalue/vwfieldvalue.dart';
import 'package:matrixclient/modules/base/vwdataformat/vwrowdata/vwrowdata.dart';
import 'package:matrixclient/modules/base/vwfilestorage/vwfilestorage.dart';
import 'dart:convert';

import 'package:matrixclient/modules/base/vwnode/vwnode.dart';
import 'package:matrixclient/modules/vwform/vwformdefinition/vwformdefinition.dart';
import 'package:matrixclient/modules/vwform/vwformdefinition/vwformfield/vwformfield.dart';
import 'package:matrixclient/modules/vwform/vwformdefinition/vwsectionformdefinition/vwsectionformdefinition.dart';
import 'package:matrixclient/modules/vwformpage/vwoldformpage.dart';

class FormUtil{

  static VwFormField? getFormField({
    required String fieldName,
    required VwFormDefinition formDefinition
}){
    VwFormField? returnValue;



    for(int la=0;la<formDefinition.sections.length;la++)
    {
      VwSectionFormDefinition currentSection=formDefinition.sections.elementAt(la);

      for(int lb=0;lb<currentSection.formFields.length;lb++)
      {
        VwFormField currentFormField=currentSection.formFields.elementAt(lb);

        if(currentFormField.fieldDefinition.fieldName==fieldName)
        {
          returnValue=currentFormField;
          break;
        }
      }

    }

    return returnValue;

  }

  /*
  static void extractSyncNodeResponseList(VwRowData formResponse,List<VwNode> uploadNodeResponseList )
  {
    for(int la=0;formResponse.fields!=null && la<formResponse.fields!.length;la++)
    {
      VwFieldValue currentFieldValue=formResponse.fields!.elementAt(la);
      if(currentFieldValue.syncNodeResponseList !=null && currentFieldValue.syncNodeResponseList!.length>0)
      {
        uploadNodeResponseList.addAll(currentFieldValue.syncNodeResponseList!);
      }
      else if(currentFieldValue.valueFormResponse!=null)
      {
        FormUtil.extractSyncNodeResponseList(currentFieldValue.valueFormResponse!,uploadNodeResponseList);
      }
      else if(currentFieldValue.valueRowData!=null)
      {
        FormUtil.extractSyncNodeResponseList(currentFieldValue.valueRowData!,uploadNodeResponseList);
      }
    }
  }*/

  static void extractVwFileStorage(VwRowData formResponse,List<VwFileStorage> uploadFileStorageList )
  {
    for(int la=0;formResponse.fields!=null && la<formResponse.fields!.length;la++)
    {
      VwFieldValue currentFieldValue=formResponse.fields!.elementAt(la);
      if(currentFieldValue.valueFieldFileStorage!=null && currentFieldValue.valueFieldFileStorage!.uploadFile!=null)
      {
        for(int lb=0;lb< currentFieldValue.valueFieldFileStorage!.uploadFile!.length;lb++)
        {
          VwFileStorage currentFileStorage=currentFieldValue.valueFieldFileStorage!.uploadFile!.elementAt(lb);



          if(currentFileStorage.clientEncodedFile!=null && currentFileStorage.clientEncodedFile!.fileDataEncodedBase64 !=null) {
            String cloneCurrentFileStorageString= json.encode(currentFileStorage.toJson());
            currentFileStorage.clientEncodedFile!.fileDataEncodedBase64 =null;
            VwFileStorage cloneVwFileStorage= VwFileStorage.fromJson(json.decode(cloneCurrentFileStorageString));
            uploadFileStorageList.add(cloneVwFileStorage);
          }
        }
      }
      else if(currentFieldValue.valueFormResponse!=null)
      {
        FormUtil.extractVwFileStorage(currentFieldValue.valueFormResponse!,uploadFileStorageList);
      }
      else if(currentFieldValue.valueRowData!=null)
      {
        FormUtil.extractVwFileStorage(currentFieldValue.valueRowData!,uploadFileStorageList);
      }
    }
  }

  static void nullifySyncDataOnStorageField(VwRowData formResponse){


    for(int la=0;formResponse.fields!=null && la<formResponse.fields!.length;la++)
      {
        VwFieldValue currentFieldValue=formResponse.fields!.elementAt(la);
        if(currentFieldValue.valueFieldFileStorage!=null && currentFieldValue.valueFieldFileStorage!.uploadFile!=null)
          {
            for(int lb=0;lb< currentFieldValue.valueFieldFileStorage!.uploadFile!.length;lb++)
              {
                VwFileStorage currentFileStorage=currentFieldValue.valueFieldFileStorage!.uploadFile!.elementAt(lb);
                if(currentFileStorage.clientEncodedFile!=null && currentFileStorage.clientEncodedFile!.fileDataEncodedBase64 !=null) {
                  currentFileStorage.clientEncodedFile!.fileDataEncodedBase64 =null;
                }
              }

          }
        else if(currentFieldValue.valueFormResponse!=null)
          {
            FormUtil.nullifySyncDataOnStorageField(currentFieldValue.valueFormResponse!);
          }
        else if(currentFieldValue.valueRowData!=null)
        {
          FormUtil.nullifySyncDataOnStorageField(currentFieldValue.valueFormResponse!);
        }
      }

  }
}