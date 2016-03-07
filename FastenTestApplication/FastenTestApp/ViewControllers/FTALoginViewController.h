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
