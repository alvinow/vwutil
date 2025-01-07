import 'package:matrixclient2base/modules/base/vwfilestorage/vwfilestorage.dart';

class FileStorageUtil{
  static VwFileStorage ? getFileStorageById({required String fileStorageId,required List<VwFileStorage> fileStorageList }){

    for(int la=0;la<fileStorageList.length;la++)
    {
      VwFileStorage currentFileStorage=fileStorageList.elementAt(la);
      if(currentFileStorage.recordId==fileStorageId)
      {
        return currentFileStorage;
      }
    }
    return null;
  }
}