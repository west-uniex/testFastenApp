//
//  FTAUser.m
//  FastenTestApp
//
//  Created by Developer on 3/3/16.
//  Copyright © 2016 M. Kondratyuk. All rights reserved.
//

#import "FTAUser.h"

@implementation FTAUser


- (NSString *) description
{
    NSString *descString = nil;
    
    descString = [NSString stringWithFormat:@"\napi_token = %@\napi_token_expiration_date = %@\nsequence_id = %@\n\n", self.api_token,self.api_token_expiration_date, self.sequence_id];
    
    return descString;
}

@end
