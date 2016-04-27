//
//  LYServiceShell.h
//  LYAFNetworking
//
//  Created by Wang on 16/4/26.
//  Copyright © 2016年 云客. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LYServiceShell : NSObject

+ (void)XDTianJiaXingDong:(NSString *)uid KeHuID:(NSString *)keHuID Name:(NSString *)name Type:(int)type IsRepeat:(NSInteger)isRepeat actionTipTime:(NSString *)actionTipTime ActionType:(NSString *)actionType usingCallback:(void (^)(DCServiceContext*context,LYBaseResponseSM *retSM)) callback;


@end
