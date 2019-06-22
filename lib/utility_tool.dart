import 'dart:async';

import 'package:flutter/services.dart';

class UtilityTool {
  static const MethodChannel _channel =
      const MethodChannel('utility_tool');

  static Future rateStore(String url) async {
    Map<String,dynamic> para = {"appStore":url};
    await _channel.invokeMethod('rateStore',para);
  }

  static Future<bool> shareApp(String url,String title) async {
    Map<String,dynamic> para = {"url":url,"title":title};
    final bool result = await _channel.invokeMethod('shareApp',para);
    return result;
  }

  static Future<bool> sendEmail(String receiver) async {
    Map<String,dynamic> para = {"receiver":receiver};
    final bool result = await _channel.invokeMethod('sendEmail',para);
    return result;
  }
}
