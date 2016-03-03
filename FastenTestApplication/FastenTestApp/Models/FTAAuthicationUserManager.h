//
//  FTAAuthicationUserManager.h
//  FastenTestApp
//
//  Created by Developer on 3/3/16.
//  Copyright © 2016 M. Kondratyuk. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FTAUser;

@interface FTAAuthicationUserManager : NSObject

@property (nonatomic, strong, readonly) FTAUser  * user;
@property (nonatomic, strong, readonly) NSString * lastAPIToken;

@property (nonatomic, strong, readonly) NSString * savedUsername;
@property (nonatomic, strong, readonly) NSString * savedPassword;

//@property (nonatomic, assign) BOOL networkIsReachable;

+ (FTAAuthicationUserManager *)sharedManager;

- (void)clearSessionToken;
- (void)clearSavedUsername;
- (void)clearSavedPassword;

- (void) loginWithUsername:(NSString *)username
                  password:(NSString *)password
                completion:(void(^)(FTAUser *user, NSError *error))completionBlock;


@end
