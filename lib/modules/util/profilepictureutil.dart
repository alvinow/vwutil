import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:matrixclient/appconfig.dart';
import 'package:matrixclient/modules/base/vwappinstanceparam/vwappinstanceparam.dart';
import 'package:matrixclient/modules/base/vwnode/vwnode.dart';
import 'package:matrixclient/modules/base/vwuser/vwuser.dart';
import 'package:matrixclient/modules/util/nodeutil.dart';

class ProfilePictureUtil {
  static String? getUrlProfilePicture(VwUser user) {
    String? returnValue;
    try {
      returnValue = user.urlProfilePicture!;
    } catch (error) {}
    return returnValue;
  }

  static Widget getProfilePictureWidget({String baseUrl=AppConfig.baseUrl+r"/profilepicture/",  String? urlProfilePicture, double size=37}) {

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
      String imageUrl=baseUrl+ urlProfilePicture!;
      if (urlProfilePicture != null) {
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


  static Widget getUserProfilePictureFromNode({VwNode? node, double size=37 }){
    Widget returnValue=ProfilePictureUtil.getProfilePictureWidget();
    try {
      if (node != null) {
        returnValue= ProfilePictureUtil.getProfilePictureWidget(size: size, urlProfilePicture: ProfilePictureUtil.getUrlProfilePicture(
            NodeUtil.getUserClassFromLinkNodeClassEncodedJson(
                linkNode: node!.creatorUserLinkNode!)!));
      }
    }
    catch(error)
    {

    }
    return returnValue;
  }

  static Widget getUserProfilePictureFromAppInstanceParam(
  {required VwAppInstanceParam appInstanceParam,double size=37}) {
    String? urlProfilePicture;
    try {
      urlProfilePicture =
          appInstanceParam.loginResponse!.userInfo!.user.urlProfilePicture;
    } catch (error) {}

    return Container(
      //color: Colors.green,
        //margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: ProfilePictureUtil.getProfilePictureWidget(urlProfilePicture: urlProfilePicture,size: size));
  }
}
