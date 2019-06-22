//
//  EmailAssistant.h
//  device_info
//
//  Created by wang animeng on 2019/6/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EmailAssistant : NSObject

+ (instancetype)share;

@property (nonatomic,strong) NSString * receiver;

- (void)sendEmail:(NSString*)title complete:(void (^)(BOOL success))complete;

@end

NS_ASSUME_NONNULL_END
