import 'dart:ui';

extension ext_on_string on String{



  Color get toColor{
    String str=replaceFirst("#", '');
    str='ff'+str;
    return Color(int.parse(str,radix: 16));
  }




}