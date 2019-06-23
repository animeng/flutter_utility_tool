#import "UtilityToolPlugin.h"
#import <StoreKit/StoreKit.h>
#import <UIKit/UIKit.h>
#import "EmailAssistant.h"

@implementation UtilityToolPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"utility_tool"
            binaryMessenger:[registrar messenger]];
  UtilityToolPlugin* instance = [[UtilityToolPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    
    if (![call.arguments isKindOfClass:[NSDictionary class]]) {
        result([FlutterError errorWithCode:@"invalid_argument"
                                   message:@"Argument type is not a Dictionary"
                                   details:call.arguments]);
        return;
    }
    if ([@"rateStore" isEqualToString:call.method]) {
        NSDictionary * para = (NSDictionary*)call.arguments;
        NSString * appId = (NSString*)para[@"appStore"];
        NSString * url = [NSString stringWithFormat:@"http://itunes.apple.com/cn/app/id%@?mt=8",appId];
        [self rateStore:url];
        result(nil);
    } else if ([@"shareApp" isEqualToString:call.method]) {
        NSDictionary * para = (NSDictionary*)call.arguments;
        NSString * url = (NSString*)para[@"url"];
        NSString * title = (NSString*)para[@"title"];
        [self shareApp:title url:url complete:^(BOOL success) {
            result(@(success));
        }];
    } else if ([@"sendEmail" isEqualToString:call.method]) {
        NSDictionary * para = (NSDictionary*)call.arguments;
        NSString * receiver = (NSString*)para[@"receiver"];
        [self sendEmail:receiver complete:^(BOOL success) {
            result(@(success));
        }];
    } else if ([@"requestNetwork" isEqualToString:call.method]) {
        [self requestNetwork:^(BOOL success) {
            result(@(success));
        }];
    } else {
        result(FlutterMethodNotImplemented);
    }
}

- (void)rateStore:(NSString*)url {
    if (@available(iOS 10.3, *)) {
        [SKStoreReviewController requestReview];
    } else {
        [UIApplication.sharedApplication openURL:[[NSURL alloc] initWithString:url]];
    }
}

- (void)shareApp:(NSString*)title url:(NSString*)url complete:(void (^)(BOOL success))complete {
    NSURL *shareURL = [NSURL URLWithString:url];
    NSArray *activityItems = [[NSArray alloc] initWithObjects:title, shareURL, nil];
    
    UIActivityViewController *vc = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    
    UIViewController * rootVc = UIApplication.sharedApplication.keyWindow.rootViewController;
    UIActivityViewControllerCompletionWithItemsHandler block = ^(UIActivityType activityType, BOOL completed, NSArray *returnedItems, NSError *activityError) {
        if (complete != NULL) {
            complete(completed);
        }
        [rootVc dismissViewControllerAnimated:YES completion:nil];
    };
    vc.completionWithItemsHandler = block;
    [rootVc presentViewController:vc animated:YES completion:nil];
}

- (void)sendEmail:(NSString*)receiver complete:(void (^)(BOOL success))complete {
    EmailAssistant.share.receiver = receiver;
    [EmailAssistant.share sendEmail:@"FeedBack" complete:complete];
}

- (void)requestNetwork:(void (^)(BOOL success))complete {
    NSURL * url = [[NSURL alloc] initWithString:@"https://apple.com"];
    NSURLSessionDataTask * task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        complete(error == NULL);
    }];
    [task resume];
}

@end
