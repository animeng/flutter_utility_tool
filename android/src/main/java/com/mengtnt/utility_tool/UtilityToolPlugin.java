package com.mengtnt.utility_tool;

import android.app.Activity;
import android.content.Intent;
import android.net.Uri;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** UtilityToolPlugin */
public class UtilityToolPlugin implements MethodCallHandler {
  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "utility_tool");
    channel.setMethodCallHandler(new UtilityToolPlugin(registrar));
  }

  private final Registrar registrar;

  public UtilityToolPlugin(final Registrar registrar) {
    this.registrar = registrar;
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {

    switch (call.method) {
      case "requestNetwork" : {
        result.success(true);
        break;
      }
      case "shareApp" : {
        String url = call.argument("url").toString();
        String title = call.argument("title").toString();
        share(url,title);
        result.success(true);
        break;
      }
      case "rateStore" : {
        String appId = call.argument("googlePlay").toString();
        goToPlayStore(appId);
        result.success(true);
        break;
      }
      case "sendEmail" : {
        String receiver = call.argument("receiver").toString();
        sendEmail(receiver,result);
        break;
      }
      default:
        result.notImplemented();
        break;
    }
  }

  private void goToPlayStore(final String applicationId) {
    final Activity activity = registrar.activity();
    try {
      activity.startActivity(new Intent(Intent.ACTION_VIEW, Uri.parse("market://details?id=" + applicationId)));
    }
    catch(android.content.ActivityNotFoundException ex) {
      activity.startActivity(new Intent(Intent.ACTION_VIEW, Uri.parse("https://play.google.com/store/apps/details?id=" + applicationId)));
    }
  }

  private void share(String url, String title) {

    Intent shareIntent = new Intent();
    shareIntent.setAction(Intent.ACTION_SEND);
    Uri shareUri = Uri.parse(url);
    shareIntent.putExtra(Intent.EXTRA_STREAM, shareUri);
    Intent chooserIntent = Intent.createChooser(shareIntent, title /* dialog title optional */);
    if (registrar.activity() != null) {
      registrar.activity().startActivity(chooserIntent);
    } else {
      chooserIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
      registrar.context().startActivity(chooserIntent);
    }
  }

  private  void sendEmail(String receiver,Result result) {
    Intent i = new Intent(Intent.ACTION_SEND);
    i.setType("message/rfc822");
    i.putExtra(Intent.EXTRA_EMAIL  , new String[]{receiver});
    i.putExtra(Intent.EXTRA_SUBJECT, "Feedback");
    i.putExtra(Intent.EXTRA_TEXT   , "body of email");
    final Activity activity = registrar.activity();
    try {
      activity.startActivity(Intent.createChooser(i, "Send mail..."));
      result.success(true);
    } catch (android.content.ActivityNotFoundException ex) {
      result.success(false);
    }
  }

}
