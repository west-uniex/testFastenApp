//
//  FTALoginViewController.h
//  FastenTestApp
//
//  Created by Developer on 3/3/16.
//  Copyright © 2016 M. Kondratyuk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FTAUser;

@protocol FTALoginDelegate <NSObject>

- (void)didFinishAuthentication:(FTAUser *)user;

@end

@interface FTALoginViewController : UIViewController

@property (nonatomic, weak) id<FTALoginDelegate> delegate;

@end


/*
 [userManager loginWithUsername:(NSString *)username
 password:(NSString *)password
 completion:^(SSUser *user, NSError *error)
 {
 // Errors can happen when we can't reach the server
 if (error)
 {
 [SVProgressHUD dismiss];
 self.loginLabel.text = @"An error occurred.";
 [self showErrorAlert:@"Could not complete login. Please check your network connection and try again."];
 }
 
 // Good login
 else if (user != nil)
 {
 // Save the values to the keychain (via the user manager)
 userManager.savedUsername = username;
 userManager.savedPassword = password;
 userManager.lastSessionToken = user.sessionToken;
 
 // Now that we have a user, get their locations
 SSAPIClient *client = [SSAPIClient sharedClient];
 [client fetchLocationsForUser:user
 completion:^(NSArray *locations, NSError *error)
 {
 if (error)
 {
 [SVProgressHUD showErrorWithStatus:@"Login Error"];
 self.loginLabel.text = @"A failure occurred during login. Please try again later.";
 self.usernameField.enabled = YES;
 self.passwordField.enabled = YES;
 self.loginButton.enabled = YES;
 }
 else
 {
 [SVProgressHUD dismiss];
 user.locations = locations;
 userManager.user = user;
 [self.delegate didFinishAuthentication:user];
 }
 }];
 
 }
 
 // No User
 else
 {
 // Hide the hud
 [SVProgressHUD showErrorWithStatus:@"Login Failed"];
 self.loginLabel.text = @"Invalid Username or Password.";
 }
 
 }];
 */