//
//  LYRequest.m
//  LYAFNetworking
//
//  Created by Wang on 16/4/26.
//  Copyright © 2016年 云客. All rights reserved.
//

#import "LYRequest.h"

@interface LYRequest ()

@property (nonatomic,unsafe_unretained) Class returnType;
@property (nonatomic,strong) LYServiceMethod *serviceMethod;
@property (nonatomic,strong) NSArray *parameterValues;
@property (nonatomic,strong) id callback;
@property (nonatomic,assign) BOOL isAborted;
@end

@implementation LYRequest

+ (LYRequest *)create:(NSString *)name parameters:(NSArray *)parms returnType:(Class)returnType{
    LYRequest *request = [[LYRequest alloc] init];
    request.returnType = returnType;
    LYServiceMethod *method = [LYServiceConfigLoader serviceMethodWithName:name];
    if (!method) {
        NSLog(@"警告 ：请确认 service_metadata.xml 文件中是否 有%@ 的节点",name);
    }
    request.serviceMethod = method;
    request.parameterValues = parms;
    return request;
}

- (void)startRequest:(void (^)(LYServiceContext *,id))callback{
    self.callback = callback;
}


@end
