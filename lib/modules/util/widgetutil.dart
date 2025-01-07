import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vwform/modules/vwwidget/vwcircularprogressindicator/vwcircularprogressindicator.dart';

class WidgetUtil{
  static Widget loadingWidget(String caption) {


    return Scaffold(
        resizeToAvoidBottomInset: true,
        body:
            WidgetUtil.loadingWidgetDisableScaffold(caption));

  }

  static Widget loadingWidgetDisableScaffold(String caption) {
    List<Widget> children = <Widget>[
      SizedBox(
        width: 45,
        height: 45,
        child: VwCircularProgressIndicator(),
      ),
      Padding(
        padding: EdgeInsets.only(top: 16),
        child: Text(caption),
      ),
    ];

    return
      Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: children,
        )],
      );



  }
}