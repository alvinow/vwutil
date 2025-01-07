//import 'dart:html';

import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:matrixclient2base/modules/base/vwdataformat/vwrowdata/vwrowdata.dart';
import 'package:matrixclient2base/modules/base/vwlinknode/vwlinknode.dart';
import 'package:matrixclient2base/modules/base/vwnode/vwnode.dart';
import 'package:vwutil/modules/util/nodeutil.dart';

class VwFlutterMapUtil{
  static List<LatLng> createPointsFromLocationLinkNodeList(List<VwLinkNode> linkNodeList){
    List<LatLng> returnValue=[];

    try
    {
      for(int la=0;la<linkNodeList.length;la++)
        {
          VwLinkNode currentLinkNode=linkNodeList[la];

          VwNode? currentNode= NodeUtil.getNode(linkNode: currentLinkNode);

          VwRowData? currentRowData= NodeUtil.getRowDataFromNodeContentRecordCollection(currentNode!);

         double latitude =  double.parse(currentRowData!.getFieldByName("latitude")!.valueString!);
         double longitude =  double.parse(currentRowData!.getFieldByName("longitude")!.valueString!);

          returnValue.add( LatLng(latitude, longitude));




        }

    }
    catch(error)
    {
      returnValue=[];
    }



    return returnValue;
  }
}