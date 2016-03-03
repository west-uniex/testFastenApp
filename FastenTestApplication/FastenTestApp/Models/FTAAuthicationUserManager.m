//
//  FTAAuthicationUserManager.m
//  FastenTestApp
//
//  Created by Developer on 3/3/16.
//  Copyright © 2016 M. Kondratyuk. All rights reserved.
//

#import "FTAAuthicationUserManager.h"
#import "FTAUser.h"

#import "SRWebSocket.h"
#import "MMKeychain.h"

typedef int(^FTACompletionBlock)(void(^)(FTAUser *user, NSError *error));


@interface FTAAuthicationUserManager () <SRWebSocketDelegate>

@property (nonatomic, strong) SRWebSocket *serverSocket;

@property (nonatomic, strong) NSString *usernameInRequest;
@property (nonatomic, strong) NSString *passwordInRequest;
@property (nonatomic, copy)  FTACompletionBlock completionBlockInRequest;

@end

@implementation FTAAuthicationUserManager

@synthesize serverSocket = _serverSocket;

- (instancetype)initWithServerSocket:(SRWebSocket *) serverSocket
{
    self = [super init];
    
    if (self)
    {
        ZAssert(serverSocket, @"We have to init server socket!");
        _serverSocket          = serverSocket;
        _serverSocket.delegate = self;
    }
    
    return self;
}


+ (FTAAuthicationUserManager *)sharedManager
{
    static FTAAuthicationUserManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *url = [NSURL URLWithString:@"ws://52.29.182.220:8080/customer-gateway/customer"];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        SRWebSocket *serverSocket = [[SRWebSocket alloc] initWithURLRequest:request];
        _sharedManager = [[FTAAuthicationUserManager alloc] initWithServerSocket:serverSocket];
    });
    
    return _sharedManager;
}

- (void)setupSockets
{
    NSURL *url = [NSURL URLWithString:@"ws://52.29.182.220:8080/customer-gateway/customer"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    SRWebSocket *rusSocket = [[SRWebSocket alloc] initWithURLRequest:request];
    
    
    rusSocket.delegate = self;
    [rusSocket open];
}



#pragma mark Properties and Methods

- (NSString *)lastSessionToken
{
    NSString *token = [MMKeychain stringForKey:@"sessionToken"];
    return token;
}

- (void)setLastSessionToken:(NSString *)sessionToken
{
    [MMKeychain setString:sessionToken forKey:@"sessionToken"];
}

- (NSString *)savedPassword
{
    return [MMKeychain stringForKey:@"password"];
}

- (void)setSavedPassword:(NSString *)savedPassword
{
    [MMKeychain setString:savedPassword forKey:@"password"];
}

- (NSString *)savedUsername
{
    return [MMKeychain stringForKey:@"username"];
}

- (void)setSavedUsername:(NSString *)savedUsername
{
    [MMKeychain setString:savedUsername forKey:@"username"];
}

- (void)clearSessionToken
{
    [MMKeychain deleteStringForKey:@"sessionToken"];
}

- (void)clearSavedUsername
{
    [MMKeychain deleteStringForKey:@"username"];
}

- (void)clearSavedPassword
{
    [MMKeychain deleteStringForKey:@"password"];
}


- (void) loginWithUsername:(NSString *)username
                  password:(NSString *)password
                completion:(void(^)(FTAUser *user, NSError *error))completionBlock
{
    self.usernameInRequest = username;
    self.passwordInRequest = password;
    self.completionBlockInRequest = [completionBlock copy];
    
    [_serverSocket open];

}


#pragma mark
#pragma mark    SRWebSocketDelegate
#pragma mark

- (void)webSocketDidOpen:(SRWebSocket *)webSocket
{
    DLog(@"web socket: %@", webSocket);
    //NSString *helloMsg = @"{ \"type\":\"TYPE_OF_MESSAGE\",\"sequence_id\":\"09caaa73-b2b1-187e-2b24-683550a49b23\",\"data\":{}}";
    
    // Запрос для успешной операции аутентификации:
    //NSString *helloMsg = @"{\"type\":\"LOGIN_CUSTOMER\",\"sequence_id\":\"a29e4fd0-581d-e06b-c837-4f5f4be7dd18\",\"data\":{\"email\":\"fpi@bk.ru\",\"password\":\"123123\"}}";
    
    //                                                                    fee454fe-39bc-4623-bb82-4faeebc35a32
    NSString *helloMsg = @"{\"type\":\"LOGIN_CUSTOMER\",\"sequence_id\":\"715c13b3-881a-9c97-b853-10be585a9747\",\"data\":{\"email\":\"fpi@bk.ru\",\"password\":\"123123\"}}";
    
    // Запрос для new customer
    //NSString *helloMsg = @"{\"type\":\"LOGIN_CUSTOMER\",\"sequence_id\":\"a29e4fd0-581d-e06b-c837-4f5f4be7dd19\",\"data\":{\"email\":\"mikitaatamanyuk@gmail.com\",\"password\":\"123123\"}}";
    
    //c9bf3bd5-3bc8-4d79-93ec-ca59843f8a88
    //NSString *helloMsg = @"{\"type\":\"LOGIN_CUSTOMER\",\"sequence_id\":\"c9bf3bd5-3bc8-4d79-93ec-ca59843f8a88\",\"data\":{\"email\":\"mikitaatamanyuk@gmail.com\",\"password\":\"123123\"}}";
    
    DLog(@"\nsent message: %@\n\n", helloMsg);
    [webSocket send:helloMsg];
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error
{
    DLog(@"\nerror : %@\n\n", error);
    
    [_serverSocket close];
    sleep(0);
}

- (void)webSocket:(SRWebSocket *)webSocket
 didCloseWithCode:(NSInteger)code
           reason:(NSString *)reason
         wasClean:(BOOL)wasClean
{
    DLog(@"\nreason : %@\n\n", reason);
}

- (void)webSocket:(SRWebSocket *)webSocket
   didReceivePong:(NSData *)pongPayload
{
    DLog(@"\npongPayload.length = %lu\n\n", pongPayload.length);
}

//
//   must have !!!
//

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message
{
    DLog(@"\nweb socket: %@\nmessage: %@\n\n", webSocket, message);
    NSString * jsonString = (NSString *)message ;
    NSData * data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError * error = nil;
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (!json)
    {
        DLog(@"\nerror: %@", error);
    }
    else
    {
        if ( [json isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *respDictionary = (NSDictionary *)json;
            NSString *type = respDictionary[@"type"];
            
            if ([type isEqualToString:@"CUSTOMER_API_TOKEN"])
            {
                DLog(@"\nCUSTOMER_API_TOKEN\n\n");
                NSDictionary *dataDict = respDictionary[@"data"];
                NSString     *apiToken = dataDict[apiToken];
                ZAssert(apiToken, @"api token have to be");
                NSString *apiTokenExperationDate = dataDict[@"api_token_expiration_date"];
                ZAssert(apiTokenExperationDate, @"api_token_expiration_date have to be");
                
                FTAUser *user = [FTAUser new];
                user.api_token = apiToken;
                user.api_token_expiration_date = apiTokenExperationDate;
                self.completionBlockInRequest( user, nil);
            }
            else if ([type isEqualToString:@"CUSTOMER_ERROR"])
            {
                DLog(@"\nCUSTOMER_ERROR\n\n");
            }
            else
            {
                ALog(@"НЕИЗВЕСТНЫЙ НАУКЕ ЗВЕРЬ");
            }
            
            sleep(0);
        }
        
        
    }
    
    
    
    
    sleep(0);
    
}






@end
