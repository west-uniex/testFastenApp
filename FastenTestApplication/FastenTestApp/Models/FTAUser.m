//
//  FTAUser.m
//  FastenTestApp
//
//  Created by Developer on 3/3/16.
//  Copyright © 2016 M. Kondratyuk. All rights reserved.
//

#import "FTAUser.h"

@interface FTAUser ()

@property (nonatomic, strong) NSDateFormatter *    sRFC3339DateFormatter;

@end


@implementation FTAUser


- (NSDateFormatter *)sRFC3339DateFormatter
{
    if(_sRFC3339DateFormatter == nil)
    {
        NSLocale *                  enUSPOSIXLocale;
        enUSPOSIXLocale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
        
        _sRFC3339DateFormatter = [[NSDateFormatter alloc] init];
        [_sRFC3339DateFormatter setLocale:enUSPOSIXLocale];
        [_sRFC3339DateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"];
        [_sRFC3339DateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    }
    
    return _sRFC3339DateFormatter;
}


- (BOOL)isAPI_Token_expired
{
    NSDate *now = [NSDate date];
    NSDate *apiTokenExpirationDate = [self.sRFC3339DateFormatter dateFromString:_api_token_expiration_date];
    
    if ( [apiTokenExpirationDate compare: now] == NSOrderedAscending)
    {
        return YES;
    }
    
    return NO;
}



- (NSString *) description
{
    NSString *descString = nil;
    
    descString = [NSString stringWithFormat:@"\napi_token = %@\n\napi_token_expiration_date = %@\n\nsequence_id = %@\n\n", self.api_token,self.api_token_expiration_date, self.sequence_id];
    
    return descString;
}


@end
