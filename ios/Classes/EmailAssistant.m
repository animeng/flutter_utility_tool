//
//  EmailAssistant.m
//  device_info
//
//  Created by wang animeng on 2019/6/22.
//

#import "EmailAssistant.h"
#import <MessageUI/MessageUI.h>

@interface EmailAssistant()<MFMailComposeViewControllerDelegate>

@property(nonatomic,strong) MFMailComposeViewController * mailVC;
@property(nonatomic,strong) void (^completeBlock)(BOOL success);

@end

@implementation EmailAssistant

+ (instancetype)share
{
    static dispatch_once_t onceToken;
    static EmailAssistant * client_ = nil;
    dispatch_once(&onceToken, ^{
        client_ = [[EmailAssistant alloc] init];
    });
    return client_;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _mailVC = [[MFMailComposeViewController alloc] init];
        _mailVC.mailComposeDelegate = self;
    }
    return self;
}

- (void)sendEmail:(NSString*)title complete:(void (^)(BOOL success))complete {
    if ([MFMailComposeViewController canSendMail]) {
        UIViewController * rootVc = UIApplication.sharedApplication.keyWindow.rootViewController;
        self.completeBlock = complete;
        [self.mailVC setSubject:title];
        if (self.receiver != NULL) {
            [self.mailVC setToRecipients:@[self.receiver]];
        }
        [rootVc presentViewController:self.mailVC animated:YES completion:NULL];
    } else {
        if (complete != NULL) {
            complete(NO);
        }
    }
}
         
 - (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
     
   UIViewController * rootVc = UIApplication.sharedApplication.keyWindow.rootViewController;
    switch (result) {
        case MFMailComposeResultSent:{
            if (self.completeBlock != NULL) {
                self.completeBlock(true);
            }
            break;
        }
        case MFMailComposeResultSaved:
        case MFMailComposeResultCancelled:
        case MFMailComposeResultFailed:
        default: {
            if (self.completeBlock != NULL) {
                self.completeBlock(NO);
            }
            break;
        }
    }
    [rootVc dismissViewControllerAnimated:YES completion:NULL];
}

@end
