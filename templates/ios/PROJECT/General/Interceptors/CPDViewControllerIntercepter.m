//
//  CPDViewControllerIntercepter.m
//  PROJECT
//
//  Created by PROJECT_OWNER on TODAYS_DATE.
//  Copyright © TODAYS_YEAR PROJECT_OWNER. All rights reserved.
//

#import "CPDViewControllerIntercepter.h"
#import <Stinger/Stinger.h>
#import <ZKCategories/ZKCategories.h>
#import <UIKit/UIKit.h>

@interface CPDViewControllerIntercepter ()

@end

@implementation CPDViewControllerIntercepter

+ (void)load {
    [self manager];
}

+ (instancetype)manager {
    static dispatch_once_t onceToken;
    static CPDViewControllerIntercepter *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self == nil) return nil;
    
    @weakify(self);
    [UIViewController st_hookInstanceMethod:@selector(loadView)
                                            option:STOptionAfter
                                   usingIdentifier:@"__KAI_UIViewController_loadView_after"
                                         withBlock:^(id<StingerParams> params) {
                                             @strongify(self);
                                             [self loadView:params.slf];
                                         }];
   [UIViewController st_hookInstanceMethod:@selector(viewDidLoad)
                                    option:STOptionAfter
                           usingIdentifier:@"__KAI_UIViewController_viewDidLoad_after"
                                 withBlock:^(id<StingerParams> params) {
                                     @strongify(self);
                                     [self viewDidLoad:params.slf];
                                 }];
    return self;
}

- (void)loadView:(UIViewController *)viewController {
    static dispatch_once_t onceToken;
    static NSArray *controllers;
    dispatch_once(&onceToken, ^{
        controllers = @[@"UIViewController"];
    });
    
    if (![controllers containsObject:viewController.className]) {
        viewController.view.backgroundColor = [UIColor colorWithHexString:@"#F3F3F3"];
    }
}

- (void)viewDidLoad:(UIViewController *)viewController {
    if ([viewController respondsToSelector:NSSelectorFromString(@"setupViewConstraints")]) {
        [viewController safePerform:NSSelectorFromString(@"setupViewConstraints")];
    }
    if ([viewController respondsToSelector:NSSelectorFromString(@"bindViewModel")]) {
        [viewController safePerform:NSSelectorFromString(@"bindViewModel")];
    }
}

@end
