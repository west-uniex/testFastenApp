//
//  FTAUser.h
//  FastenTestApp
//
//  Created by Developer on 3/3/16.
//  Copyright © 2016 M. Kondratyuk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FTAUser : NSObject

@property (nonatomic, strong) NSString *api_token;
@property (nonatomic, strong) NSString *sequence_id;
@property (nonatomic, strong) NSString *api_token_expiration_date;


@end
