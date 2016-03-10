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

#define kSSPaleBlueColor [UIColor colorWithRed:0.31 green:0.46 blue:0.63 alpha:1]
#define kSSGrayBGColor   [UIColor colorWithRed:0.87 green:0.87 blue:0.85 alpha:1]


@interface FTAUserInfoViewController () <FTALoginDelegate>

@property (weak, nonatomic) IBOutlet UITextView *userInfoTextView;

@end

@implementation FTAUserInfoViewController


#pragma mark
#pragma mark - lifetime this viewcontroller view methods
#pragma mark


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.userInfoTextView setEditable: NO];
    self.view.backgroundColor = kSSGrayBGColor;
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //DLog(@"\n\n");
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    FTAAuthicationUserManager *authManager = [FTAAuthicationUserManager sharedManager];
    
    // If there is no API token or API token expired, force the login screen.
    
    BOOL isAPITokenExpired = authManager.user.isAPI_Token_expired;
    
    // for testing ...
    //isAPITokenExpired = YES;
    
    if ( authManager.lastAPIToken == nil )
    {
        DLog(@"\nFIRST ATEMPT TO ENTRY\n\n");
        [self showLoginScreen:nil];
    }
    else if ( isAPITokenExpired == YES )
    {
        DLog(@"\nAPI TOKEN EXPIRED\n\n");
        [self showLoginScreen:nil];
    }
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark
#pragma mark - Data Loading Methods
#pragma mark

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
        self.userInfoTextView.text = [self.currentUser description];
        
        [[FTAAuthicationUserManager sharedManager] closeLoginWebSocket];
    });
    
}

@end
