//
//  LYRequest.h
//  LYAFNetworking
//
//  Created by Wang on 16/4/26.
//  Copyright © 2016年 云客. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LYServiceConfigLoader.h"
#import "LYServiceContext.h"

@interface LYRequest : NSObject{
}

+ (LYRequest *)create:(NSString *)name parameters:(NSArray *)parms returnType:(Class)returnType;


- (void)startRequest:(void (^)(LYServiceContext *,id))callback;

@end
