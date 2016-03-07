//
//  FTALoginViewController.m
//  FastenTestApp
//
//  Created by Developer on 3/3/16.
//  Copyright © 2016 M. Kondratyuk. All rights reserved.
//

#import "FTALoginViewController.h"
#import "FTAUser.h"
#import "FTAAuthicationUserManager.h"

#import "SVProgresshud.h"

@interface FTALoginViewController ()

@property (nonatomic, weak) IBOutlet UILabel *loginLabel;
@property (nonatomic, weak) IBOutlet UITextField *usernameField;
@property (nonatomic, weak) IBOutlet UITextField *passwordField;
@property (nonatomic, weak) IBOutlet UIButton *loginButton;
@property (nonatomic, weak) IBOutlet UIButton *clearInfoButton;

@property (weak, nonatomic) IBOutlet UITextView *errorTextFiled;

@end

@implementation FTALoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.errorTextFiled.editable = NO;
    self.errorTextFiled.text     = @"";
    self.errorTextFiled.hidden   = YES;
    
    // See if the username and password are in the keychain
    NSString *username = [[FTAAuthicationUserManager sharedManager] savedUsername];
    NSString *password = [[FTAAuthicationUserManager sharedManager] savedPassword];
    
    // If we have a saved username and password, assign them to the text fields
    if (username != nil)
    {
        self.usernameField.text = username;
    }
    
    if (password != nil)
    {
        self.passwordField.text = password;
    }
    
    // The login button should only be enabled when the
    // username and password text fields have values
    self.loginButton.enabled = [self loginButtonShouldBeEnabled];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark User Interface Methods

- (IBAction)clearButtonPressed:(id)sender
{
    FTAAuthicationUserManager *authManager = [FTAAuthicationUserManager sharedManager];
    
    // Delete the last login token, username, and password from the keychain
    // (via the user manager, the implementation details don't belong here
    [authManager clearSessionToken];
    [authManager clearSavedPassword];
    [authManager clearSavedUsername];
    
    // Set the username and password fields to blank and disable the login button
    self.usernameField.text = nil;
    self.passwordField.text = nil;
    self.loginButton.enabled = [self loginButtonShouldBeEnabled];
}

- (BOOL)loginButtonShouldBeEnabled
{
    return (self.usernameField.text.length > 0 && self.passwordField.text.length > 0);
}

- (void)showErrorAlert:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                    message:message
                                                   delegate:self cancelButtonTitle:@"Okay"
                                          otherButtonTitles:nil];
    [alert show];
}

- (IBAction)loginButtonPressed:(id)sender
{
    FTAAuthicationUserManager *authManager = [FTAAuthicationUserManager sharedManager];
    
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    
    // Show the progress hud
    [SVProgressHUD setForegroundColor:[UIColor colorWithRed:0.31 green:0.46 blue:0.63 alpha:1]];
    [SVProgressHUD showWithStatus:@"Logging In" maskType:SVProgressHUDMaskTypeBlack];
    
    /*
    __weak typeof(self)weakSelf = self;
    self.block = ^{
        __strong typeof(self)self = weakSelf;
        [self m1];
        [self m2];
        NSAssert(foo == bar, @"Cool assert!")
    };*/
    
     __weak __typeof__(self)weakSelf = self;
    [authManager loginWithUsername:username
                          password:password
                        completion:^(FTAUser *user, NSError *error)
     {
         [SVProgressHUD dismiss];
         __strong typeof(self)self = weakSelf;
         
         if (error)
         {
             DLog(@"\nerror: %@\n\n", error);
             
             [self.usernameField resignFirstResponder];
             [self.passwordField resignFirstResponder];
             self.errorTextFiled.text = [error.userInfo description];
             
             self.errorTextFiled.hidden   = NO;
         }
         else
         {
             DLog(@"\nuser: %@\n\n", user);

             [self.usernameField resignFirstResponder];
             [self.passwordField resignFirstResponder];
             
             [self.delegate didFinishAuthentication:user];
         }
         
     }];
    
    
}

# pragma mark UITextField Delegate

- (IBAction)textFieldsChanged:(id)sender
{
    self.loginButton.enabled = [self loginButtonShouldBeEnabled];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // Resign the responder so the keyboard will dismiss
    // when the user taps the return button
    [textField resignFirstResponder];
    return YES;
}




@end
