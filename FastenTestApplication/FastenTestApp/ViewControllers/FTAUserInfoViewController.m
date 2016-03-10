//
//  FTAUserInfoViewController.m
//  FastenTestApp
//
//  Created by Developer on 3/3/16.
//  Copyright © 2016 M. Kondratyuk. All rights reserved.
//

#import "FTAUserInfoViewController.h"
#import "FTALoginViewController.h"

#import "FTAUser.h"

#import "FTAAuthicationUserManager.h"

#import "SVProgresshud.h"


//static NSString * const messageAboutCorpPolicy = @"In order to comply with corporate policies, this file cannot be opened from your device's local memory.";

#define kSSPaleBlueColor [UIColor colorWithRed:0.31 green:0.46 blue:0.63 alpha:1]
#define kSSGrayBGColor [UIColor colorWithRed:0.87 green:0.87 blue:0.85 alpha:1]


@interface FTAUserInfoViewController () <FTALoginDelegate>

@property (weak, nonatomic) IBOutlet UITextView *userInfoTextView;
- (IBAction)webSocketCloseButtonDidTap:(id)sender;

@end

@implementation FTAUserInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    /*
    FTAAuthicationUserManager *authManager = [FTAAuthicationUserManager sharedManager];
    
    // If there is no session token, force the login screen. If there
    // is a session token, try to validate it
    
    if (!authManager.lastAPIToken)
    {
        [self showLoginScreen:nil];
    }
    else if (!authManager.user)
    {
        [self validateLogin];
    }
     */

}


-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    /*
    FTAAuthicationUserManager *authManager = [FTAAuthicationUserManager sharedManager];
    
    // If there is no session token, force the login screen. If there
    // is a session token, try to validate it
    
    if (!authManager.lastAPIToken)
    {
        [self showLoginScreen:nil];
    }
    else if (!authManager.user)
    {
        [self validateLogin];
    }
     */

}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    FTAAuthicationUserManager *authManager = [FTAAuthicationUserManager sharedManager];
    
    // If there is no API token or , force the login screen.
    
    if ( (authManager.lastAPIToken == nil) || (authManager.user.isAPI_Token_expired == YES) )
    {
        [self showLoginScreen:nil];
    }
    //else if (!authManager.user)
    //{
    //    [self validateLogin];
    //}
    else if ( authManager.user == self.currentUser)
    {
        DLog(@"\nALL GOOD\n\n");
    }
    else
    {
        ALog(@"BAD NEWS !!!");
    }
}

-  (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    //DLog(@" ");
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Data Loading Methods

- (void)validateLogin
{
    DLog(@" ");
    
    // Show the progress hud
    [SVProgressHUD setForegroundColor: kSSPaleBlueColor];
    [SVProgressHUD showWithStatus: @"Loading Your Account"
                         maskType: SVProgressHUDMaskTypeBlack];
    
    // Attempt a session validation
}


- (IBAction)showLoginScreen:(id)sender
{
    UIStoryboard *storyboard        = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    FTALoginViewController *loginVC = [storyboard instantiateViewControllerWithIdentifier:@"loginVC"];
    loginVC.delegate                = self;
    
    // If we are showing the login b/c they hit the logout button, then animate the
    // modal presentation. (we don't want the initial load presentation animated)
    BOOL animate = sender != nil;
    [self presentViewController:loginVC
                       animated:animate
                     completion:nil];
}


#pragma mark
#pragma mark    FTALoginDelegate conforming
#pragma mark



- (void)didFinishAuthentication:(FTAUser *)user
{
    DLog(@"\n\n");
    
    dispatch_async( dispatch_get_main_queue(),^(void)
    {
        self.currentUser = user;
        [self dismissViewControllerAnimated:YES completion:nil];
        //[self viewWillAppear:YES];
         self.userInfoTextView.text = [self.currentUser description];
    });
    
}


- (IBAction)webSocketCloseButtonDidTap:(id)sender
{
    DLog(@"\n \n\n");
    [[FTAAuthicationUserManager sharedManager] closeLoginWebSocket];
}
@end
