//
//  CPDAPIManagerIntercepter.h
//  PROJECT
//
//  Created by PROJECT_OWNER on TODAYS_DATE.
//  Copyright © TODAYS_YEAR PROJECT_OWNER. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CTAPIBaseManager;

NS_ASSUME_NONNULL_BEGIN

@interface CPDAPIManagerIntercepter : NSObject

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
- (id)copy NS_UNAVAILABLE;
- (id)mutableCopy NS_UNAVAILABLE;

+ (instancetype)manager;

- (NSDictionary *)reformParams:(NSDictionary *)params forAPIManager:(CTAPIBaseManager *)manager;

@end

NS_ASSUME_NONNULL_END
