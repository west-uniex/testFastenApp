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

@property (nonatomic, strong) NSString * savedUsername;
@property (nonatomic, strong) NSString * savedPassword;

@property (nonatomic, strong) FTAUser  * user;
@property (nonatomic, strong) NSString * lastAPIToken;



@property (nonatomic, strong) SRWebSocket *serverSocket;
@property (nonatomic, strong) NSString *usernameInRequest;
@property (nonatomic, strong) NSString *passwordInRequest;
@property (nonatomic, strong) NSString *sequenceIdInRequest;
@property (nonatomic, copy)   void (^ completionBlockInRequest) (FTAUser *user, NSError *error); //FTACompletionBlock completionBlockInRequest;

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


- (void)loginWithUsername:(NSString *)username
                 password:(NSString *)password
               completion:(void(^)(FTAUser *user, NSError *error))completionBlock
{
    self.usernameInRequest        = username;
    self.passwordInRequest        = password;
    self.completionBlockInRequest = [completionBlock copy];
    self.sequenceIdInRequest      = [[NSUUID UUID] UUIDString];
    
    
    switch (_serverSocket.readyState)
    {
        case SR_CONNECTING:
             [_serverSocket open];
            break;
            
        case SR_OPEN:
            {
                //NSString *helloMsg = @"{\"type\":\"LOGIN_CUSTOMER\",\"sequence_id\":\"715c13b3-881a-9c97-b853-10be585a9747\",\"data\":{\"email\":\"fpi@bk.ru\",\"password\":\"123123\"}}";
                NSString *jsonLoginString = [self xxxLoginMessageFromPassword:password
                                                                        email:username
                                                                   sequenceId:self.sequenceIdInRequest];
                [_serverSocket send: (id)jsonLoginString];
            }
            break;
            
        case SR_CLOSING:
            {
                sleep(0);
            }
            break;
            
        case SR_CLOSED:
            {
                [_serverSocket open];
                sleep(0);
            }
            break;
        
    }
}

#pragma mark
#pragma mark    SRWebSocketDelegate
#pragma mark

- (void)webSocketDidOpen:(SRWebSocket *)webSocket
{
    DLog(@"web socket: %@", webSocket);
    
    NSString *jsonLoginString = [self xxxLoginMessageFromPassword:self.passwordInRequest
                                                            email:self.usernameInRequest
                                                       sequenceId:self.sequenceIdInRequest];
    
    DLog(@"\nsent message: %@\n\n", jsonLoginString);
    [webSocket send: jsonLoginString];
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error
{
    DLog(@"\nerror : %@\n\n", error);
    
    //[_serverSocket close];
    sleep(0);
}

- (void)webSocket:(SRWebSocket *)webSocket
 didCloseWithCode:(NSInteger)code
           reason:(NSString *)reason
         wasClean:(BOOL)wasClean
{
    DLog(@"\nreason : %@\n\n", reason);
     sleep(0);
}

- (void)webSocket:(SRWebSocket *)webSocket
   didReceivePong:(NSData *)pongPayload
{
    DLog(@"\npongPayload.length = %ul\n\n", pongPayload.length);
     sleep(0);
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
                NSString     *apiToken = dataDict[@"api_token"];
                ZAssert(apiToken, @"api token have to be");
                NSString *apiTokenExperationDate = dataDict[@"api_token_expiration_date"];
                ZAssert(apiTokenExperationDate, @"api_token_expiration_date have to be");
                
                FTAUser *user = [FTAUser new];
                user.api_token = apiToken;
                user.api_token_expiration_date = apiTokenExperationDate;
                user.sequence_id = self.sequenceIdInRequest;
                
                //
                self.user          = user;
                self.savedPassword = self.passwordInRequest;
                self.savedUsername = self.usernameInRequest;
                self.lastAPIToken  = user.api_token;
                
                self.completionBlockInRequest( user, nil);
                
            }
            else if ([type isEqualToString:@"CUSTOMER_ERROR"])
            {
                DLog(@"\nCUSTOMER_ERROR\n\n");
                NSDictionary *dataDict = respDictionary[@"data"];
                DLog(@"%@", dataDict);
                NSError *error = [NSError errorWithDomain:dataDict[@"error_description"]
                                                     code:2000
                                                 userInfo:dataDict];
                self.completionBlockInRequest( nil, error);
            }
            else if ([type isEqualToString:@"CUSTOMER_VALIDATION_ERROR"])
            {
                DLog(@"\nCUSTOMER_VALIDATION_ERROR\n\n");
                NSDictionary *dataDict = respDictionary[@"data"];
                DLog(@"%@", dataDict);
                NSError *error = [NSError errorWithDomain:dataDict[@"error_description"]
                                                     code:2100
                                                 userInfo:dataDict];
                self.completionBlockInRequest( nil, error);
            }
            else
            {
                ALog(@"НЕИЗВЕСТНЫЙ НАУКЕ ЗВЕРЬ");
            }
        }
    }
    
    //[_serverSocket close];
}


#pragma mark
#pragma mark    internal methods
#pragma mark


- (NSString *)xxxLoginMessageFromPassword:(NSString *)pass
                                    email:(NSString *)email
                               sequenceId:(NSString *)sequenceId
{
    NSString *result = nil;
    
    result = [NSString stringWithFormat: @"{\"type\":\"LOGIN_CUSTOMER\",\"sequence_id\":\"%@\",\"data\":{\"email\":\"%@\",\"password\":\"%@\"}}", sequenceId, email, pass];
    ZAssert(result, @"JSON string have to be created");
    return result;
}



#pragma mark
#pragma mark    clean resources
#pragma mark


- (void)dealloc
{
    DLog(@"\n \n\n");
    sleep(0);
}




@end
