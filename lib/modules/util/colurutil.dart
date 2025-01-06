import 'dart:ui';

class ColorUtil{
  static Color parseColor(String hexColor){
   return  Color(int.parse(hexColor, radix: 16));
  }


}