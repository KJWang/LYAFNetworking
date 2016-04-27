//
//  LYServiceConfigLoader.m
//  LYAFNetworking
//
//  Created by Wang on 16/4/26.
//  Copyright © 2016年 云客. All rights reserved.
//

#import "LYServiceConfigLoader.h"
#import "RXMLElement.h"

static NSString *kIsExclusive = @"default_IsExclusive";
static NSString *kIsShowWaitbox = @"default_IsShowWaitbox";
static NSString *kIsShowError = @"default_IsShowError";
static NSString *kTimeout = @"default_Timeout";
static NSString *kEncoder = @"default_Encoder";
static NSString *kDecoder = @"default_Decoder";

static NSMutableDictionary *_defaultConfig;
static NSMutableDictionary *_methods;
static NSMutableDictionary *_urlProvider;

@implementation LYServiceConfigLoader

+ (void)load{
    [self loadServiceMethods];
}

+ (void)loadServiceMethods{
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"ServiceConfig" ofType:@"xml"];
    NSAssert([[NSFileManager defaultManager] fileExistsAtPath:filePath], @"使用这个请求方式，ServiceConfig.xml是不能缺少的，如果不想使用这个方式请求，请注释掉上面的 load 方法");
    RXMLElement *root = [RXMLElement elementFromXMLFile:@"ServiceConfig.xml"];
    _defaultConfig = [[NSMutableDictionary alloc] init];
    // 是否允许并发
    __block BOOL default_Exclusive = NO;
    __block BOOL default_ShowWaitbox = NO;
    __block BOOL default_ShowError = NO;
    __block NSInteger default_Timeout = 30;
    __block NSString *default_Encoder = @"";
    __block NSString *default_Decoder = @"";
    
    [root iterate:@"Defaults" usingBlock:^(RXMLElement *element) {
        default_Exclusive = [[element attribute:@"IsExclusive"] isEqualToString:@"true"];
        default_ShowError = [[element attribute:@"ShowError"] isEqualToString:@"true"];
        default_ShowWaitbox = [[element attribute:@"ShowWaitBox"] isEqualToString:@"true"];
        default_Timeout = [element attribute:@"Timeout"] ? [element attribute:@"Timeout"].intValue : 30;
        default_Decoder = [element attribute:@"Decoder"] ? [element attribute:@"Decoder"] : @"";
        default_Encoder = [element attribute:@"Encoder"] ? [element attribute:@"Encoder"] : @"";
        [_defaultConfig setObject:[NSNumber numberWithBool:default_Exclusive] forKey:kIsExclusive];
        [_defaultConfig setObject:[NSNumber numberWithBool:default_ShowWaitbox] forKey:kIsShowWaitbox];
        [_defaultConfig setObject:[NSNumber numberWithBool:default_ShowError] forKey:kIsShowError];
        [_defaultConfig setObject:[NSNumber numberWithInteger:default_Timeout] forKey:kTimeout];
        [_defaultConfig setObject:default_Decoder forKey:kDecoder];
        [_defaultConfig setObject:default_Encoder forKey:kEncoder];
    }];
    
    _urlProvider = [[NSMutableDictionary alloc] init];
    NSString *url = [[root attribute:@"UseTestEnvironment"] isEqualToString:@"true"] ? @"TestUrls.Url" : @"Urls.Url";
    [root iterate:url usingBlock:^(RXMLElement *element) {
        [_urlProvider setObject:[element attribute:@"Value"] forKey:[element attribute:@"Name"]];
    }];
    //    paramenterKeys
    _methods = [[NSMutableDictionary alloc] init];
    [root iterate:@"ServiceMethods.ServiceMethod" usingBlock:^(RXMLElement *element) {
        LYServiceMethod *mothed = [[LYServiceMethod alloc] init];
        mothed.name = [element attribute:@"Name"];
        mothed.isExclusive = [element attribute:@"IsExclusive"] ? [[element attribute:@"IsExclusive"] isEqualToString:@"true"] : default_Exclusive;
        mothed.showWaitBox = [element attribute:@"ShowWaitBox"] ? [[element attribute:@"ShowWaitBox"] isEqualToString:@"true"] : default_ShowWaitbox;
        mothed.showError = [element attribute:@"ShowError"] ? [[element attribute:@"ShowError"] isEqualToString:@"true"] : default_ShowError;
        mothed.decoderClass = [element attribute:@"Decoder"] ? [element attribute:@"Decoder"] : default_Decoder;
        mothed.encoderClass = [element attribute:@"Encoder"] ? [element attribute:@"Encoder"] : default_Encoder;
        mothed.modelClass = [element attribute:@"ModelClass"] ? [element attribute:@"ModelClass"] : @"LKBaseRequest";
        mothed.showError = [element attribute:@"ShowError"] ? [[element attribute:@"ShowError"] isEqualToString:@"true"] : default_ShowError;
        [mothed getUrl:[element attribute:@"Url"] urls:_urlProvider];
        mothed.mothed = [element attribute:@"Method"];
        mothed.paramenterKeys = [[element attribute:@"Parameters"] componentsSeparatedByString:@","];
        [_methods setObject:mothed forKey:mothed.name];
    }];
    NSLog(@"%d",_methods.count);
}


+ (LYServiceMethod *)serviceMethodWithName:(NSString *)name{
    return [_methods objectForKey:name];
}



@end


@implementation LYServiceMethod

- (void)getUrl:(NSString *)urlElement urls:(NSDictionary *)dict{
    NSUInteger u1 = [urlElement rangeOfString:@"["].location;
    NSUInteger u2 = [urlElement rangeOfString:@"]"].location;
    NSString *urlID = [urlElement substringWithRange:NSMakeRange(u1+1, u2-u1 - 1)];
    NSString *mothed = [urlElement substringFromIndex:u2 + 1];
    self.baseUrl = ((NSString *)dict[urlID]);
    self.requestUrl = mothed;
}

@end

