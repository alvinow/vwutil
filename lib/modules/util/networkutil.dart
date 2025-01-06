import 'package:get_ip_address/get_ip_address.dart';
class NetworkUtil{
  static Future<String> getIp() async{
       return await IpAddress().getIpAddress();
  }
}