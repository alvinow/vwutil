import 'package:intl/intl.dart';
import 'package:matrixclient/modules/base/vwdataformat/vwdataformattimestamp/vwdataformattimestamp.dart';

class VwDateUtil{
  static  VwDataFormatTimestamp nowTimestamp(){
    return  VwDataFormatTimestamp(created: DateTime.now(), updated: DateTime.now());
  }

  static String formatLocalTimeZone(DateTime dateTime){
    DateTime dateValue=dateTime.toLocal();
    return DateFormat().format(dateValue);
  }

  static String indonesianFormatLocalTimeZone(DateTime dateTime){
    DateTime dateValue=dateTime.toLocal();
    return DateFormat("dd MMM yyyy HH:mm").format(dateValue);
  }

  static String indonesianFormatLocalTimeZone_DateOnly(DateTime dateTime){
    DateTime dateValue=dateTime.toLocal();
    return DateFormat("dd MMM yyyy").format(dateValue);
  }

  static String indonesianFormatLocalTimeZone_TimeOnly(DateTime dateTime){
    DateTime dateValue=dateTime.toLocal();
    return DateFormat("HH:mm").format(dateValue);
  }

  static String indonesianShortFormatLocalTimeZone(DateTime dateTime){
    DateTime dateValue=dateTime.toLocal();

    return DateFormat("dd/MM/yy HH:mm").format(dateValue);
  }


}