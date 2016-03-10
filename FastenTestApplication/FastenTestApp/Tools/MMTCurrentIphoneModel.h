//
//  MMTCurrentIphoneModel.h
//  MyMojoTrialApp
//
//  Created by Developer on 2/21/16.
//  Copyright © 2016 M. Kondratyuk. All rights reserved.
//

@import UIKit;

@interface MMTCurrentIphoneModel : NSObject
{
    @private
    BOOL _isiPhone4;
    BOOL _isiPhone5;
    BOOL _isiPhone6;
    BOOL _isiPhone6Plus;
}

@property (nonatomic, readonly) BOOL isiPhone4;
@property (nonatomic, readonly) BOOL isiPhone5;
@property (nonatomic, readonly) BOOL isiPhone6;
@property (nonatomic, readonly) BOOL isiPhone6Plus;


+ (MMTCurrentIphoneModel *) sharedManager;


@end
