//
//  LYServiceConfigLoader.h
//  LYAFNetworking
//
//  Created by Wang on 16/4/26.
//  Copyright © 2016年 云客. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LYServiceMethod;

@interface LYServiceConfigLoader : NSObject

+ (LYServiceMethod *)serviceMethodWithName:(NSString *)name;

@end



@interface LYServiceMethod : NSObject

@property (nonatomic,strong) NSString *decoderClass;
@property (nonatomic,strong) NSString *encoderClass;

//方法名
@property (retain, nonatomic) NSString* name;

//
@property (retain, nonatomic) NSString* baseUrl;

@property (retain, nonatomic) NSString* requestUrl;

@property (retain, nonatomic) NSString *mothed;

@property (nonatomic) BOOL isExclusive;

@property (nonatomic) BOOL showWaitBox;

@property (nonatomic) BOOL showError;

@property (nonatomic) NSTimeInterval timeout;

@property (retain, nonatomic) NSString* waitMessage;

@property (nonatomic,strong) NSArray *paramenterKeys;

@property (nonatomic,strong) NSString *modelClass;

- (void)getUrl:(NSString *)urlElement urls:(NSDictionary *)dict;


@end

