//
//  MMTCurrentIphoneModel.m
//  MyMojoTrialApp
//
//  Created by Developer on 2/21/16.
//  Copyright © 2016 M. Kondratyuk. All rights reserved.
//

#import "MMTCurrentIphoneModel.h"

@interface MMTCurrentIphoneModel ()

@property (nonatomic, assign) BOOL isiPhone4;
@property (nonatomic, assign) BOOL isiPhone5;
@property (nonatomic, assign) BOOL isiPhone6;
@property (nonatomic, assign) BOOL isiPhone6Plus;


@end

@implementation MMTCurrentIphoneModel

@synthesize isiPhone4     = _isiPhone4;
@synthesize isiPhone5     = _isiPhone5;
@synthesize isiPhone6     = _isiPhone6;
@synthesize isiPhone6Plus = _isiPhone6Plus;


#pragma mark - Initialization

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        if (screenSize.width == 320  && screenSize.height == 480)
        {
            _isiPhone4 = YES;
            DLog(@"\ncurrent model iPhone4 \n\n\n");
        }
        else if (screenSize.width == 320  && screenSize.height == 568)
        {
            _isiPhone5 = YES;
            DLog(@"\ncurrent model iPhone5 \n\n\n");
        }
        else if (screenSize.width == 375 && screenSize.height == 667)
        {
            _isiPhone6 = YES;
            DLog(@"\ncurrent model iPhone6 \n\n\n");
        }
        else if (screenSize.width == 414 && screenSize.height == 736)
        {
            _isiPhone6Plus = YES;
            DLog(@"\ncurrent model iPhone6Plus \n\n\n");
        }
        else
        {
            DLog(@"We have NEW model of iPhone?\n\n\n");
        }
    }
    
    return self;
}

+ (MMTCurrentIphoneModel *) sharedManager
{
    static dispatch_once_t once;
    static MMTCurrentIphoneModel *__instance;
    dispatch_once(&once, ^()
                  {
                      __instance = [[MMTCurrentIphoneModel alloc] init];
                  });
    
    return __instance;
}



@end
