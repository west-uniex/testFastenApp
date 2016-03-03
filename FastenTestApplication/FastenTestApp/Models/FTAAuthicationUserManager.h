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

@property (nonatomic, strong) FTAUser  * user;
@property (nonatomic, strong) NSString * lastAPIToken;

@property (nonatomic, strong) NSString * savedUsername;
@property (nonatomic, strong) NSString * savedPassword;

//@property (nonatomic, assign) BOOL networkIsReachable;

+ (FTAAuthicationUserManager *)sharedManager;

- (void)clearSessionToken;
- (void)clearSavedUsername;
- (void)clearSavedPassword;

- (void) loginWithUsername:(NSString *)username
                  password:(NSString *)password
                completion:(void(^)(FTAUser *user, NSError *error))completionBlock;


@end
