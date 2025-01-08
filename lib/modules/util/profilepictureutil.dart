import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:matrixclient2base/modules/base/vwnode/vwnode.dart';
import 'package:matrixclient2base/modules/base/vwuser/vwuser.dart';
import 'package:vwform/modules/vwappinstanceparam/vwappinstanceparam.dart';
import 'package:vwutil/modules/util/nodeutil.dart';

class ProfilePictureUtil {
  static String? getUrlProfilePicture(VwUser user) {
    String? returnValue;
    try {
      returnValue = user.urlProfilePicture!;
    } catch (error) {}
    return returnValue;
  }

  static Widget getProfilePictureWidget({required VwAppInstanceParam appInstanceParam, required String userId, double size=37}) {

    double externalSize=size;
    double internalSize=size*0.6;

    Widget returnValue =
        Stack(alignment: AlignmentDirectional.center, children: [
      Icon(
        Icons.circle,
        color: Colors.grey,
        size: externalSize,
      ),
      Icon(
        Icons.person,
        size: internalSize,
        color: Colors.white,
      )
    ]);

    try {
      String imageUrl=appInstanceParam.baseUrl+"profpic/"+appInstanceParam.loginResponse!.userInfo!.user.recordId;
      if (imageUrl != null) {
        returnValue = Container(
            width: externalSize,
            height: externalSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              image: DecorationImage(
                fit: BoxFit.fitHeight,
                image: NetworkImage(imageUrl),
              ),
            ));
      }
    } catch (error) {}

    return returnValue;
  }


  static Widget getUserProfilePictureFromNode({VwNode? node,required VwAppInstanceParam appInstanceParam, double size=37 }){
    Widget returnValue=Container();
    try {
      if (node != null) {
        returnValue= ProfilePictureUtil.getProfilePictureWidget(appInstanceParam: appInstanceParam,userId: NodeUtil.getUserClassFromLinkNodeClassEncodedJson(
            linkNode: node!.creatorUserLinkNode!)!.recordId );
      }
    }
    catch(error)
    {

    }
    return returnValue;
  }

  static Widget getUserProfilePictureFromAppInstanceParam(
  {required String baseUrl, required VwAppInstanceParam appInstanceParam,double size=37}) {
    String? userId;
    try {
      userId =
          appInstanceParam.loginResponse!.userInfo!.user.recordId;

      if(userId!=null)
        {
          return Container(
            //color: Colors.green,
            //margin: EdgeInsets.fromLTRB(0, 0, 0, 0),

              child: ProfilePictureUtil.getProfilePictureWidget(appInstanceParam: appInstanceParam,userId:userId!   ,size: size));
        }

    } catch (error) {}

    return Container();


  }
}
