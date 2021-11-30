//
//  CPDAPIManagerIntercepter.m
//  PROJECT
//
//  Created by PROJECT_OWNER on TODAYS_DATE.
//  Copyright © TODAYS_YEAR PROJECT_OWNER. All rights reserved.
//

#import "CPDAPIManagerIntercepter.h"
#import <CTNetworking/CTNetworking.h>
#import <Stinger/Stinger.h>
#import <ZKCategories/ZKCategories.h>

@interface LJJAPIManagerIntercepter () <CTAPIManagerValidator, CTAPIManagerInterceptor>

@end

@implementation CPDAPIManagerIntercepter

+ (void)load {
    [self manager];
}

+ (instancetype)manager {
    static dispatch_once_t onceToken;
    static CPDAPIManagerIntercepter *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {

        @weakify(self);
        [CTAPIBaseManager st_hookInstanceMethod:@selector(init)
                                         option:STOptionAfter
                                usingIdentifier:@"__KAI_CTAPIBaseManager_init_after"
                                      withBlock:^(id<StingerParams> params) {
                                          @strongify(self);
                                          [self commonInit:params.slf];
                                      }];
        [CTAPIBaseManager st_hookInstanceMethod:@selector(cleanData)
                                         option:STOptionAfter
                                usingIdentifier:@"__KAI_CTAPIBaseManager_clearData_after"
                                      withBlock:^(id<StingerParams> params) {
                                          CTAPIBaseManager *request = params.slf;
                                          if ([request conformsToProtocol:@protocol(CTPagableAPIManager)]) {
                                              request.isFirstPage = YES;
                                              request.pageNumber  = 1;
                                          }
                                      }];
    }
    return self;
}
 
- (void)commonInit:(CTAPIBaseManager *)manager {
    manager.validator = self;

    if ([manager conformsToProtocol:@protocol(CTPagableAPIManager)]) {
        manager.interceptor = self;
        manager.pageNumber  = 1;
        manager.pageSize    = 20;
    }
}

- (NSDictionary *)reformParams:(NSDictionary *)params forAPIManager:(CTAPIBaseManager *)manager {
    return @{};
}

#pragma mark - :. CTAPIManagerValidator

// 验证接口请求参数
- (CTAPIManagerErrorType)manager:(CTAPIBaseManager *)manager isCorrectWithParamsData:(NSDictionary *)data {
    return CTAPIManagerErrorTypeNoError;
}

// 验证接口返回参数
- (CTAPIManagerErrorType)manager:(CTAPIBaseManager *)manager isCorrectWithCallBackData:(NSDictionary *)data {
    return CTAPIManagerErrorTypeNoError;
}

#pragma mark - CTAPIManagerInterceptor

- (BOOL)manager:(CTAPIBaseManager *_Nonnull)manager beforePerformSuccessWithResponse:(CTURLResponse *_Nonnull)response {
    return YES;
}

- (BOOL)manager:(CTAPIBaseManager *_Nonnull)manager beforePerformFailWithResponse:(CTURLResponse *_Nonnull)response {
    return YES;
}

@end
