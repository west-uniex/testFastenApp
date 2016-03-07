//
//  ViewController.m
//  FastenTestApp
//
//  Created by Developer on 3/2/16.
//  Copyright © 2016 M. Kondratyuk. All rights reserved.
//

#import "ViewController.h"
#import "SRWebSocket.h"

@interface ViewController () <SRWebSocketDelegate>

- (IBAction)showLoginScreen:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSURL *url = [NSURL URLWithString:@"ws://52.29.182.220:8080/customer-gateway/customer"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    SRWebSocket *rusSocket = [[SRWebSocket alloc] initWithURLRequest:request];
    rusSocket.delegate = self;
    [rusSocket open];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark
#pragma mark    SRWebSocketDelegate
#pragma mark

- (void)webSocketDidOpen:(SRWebSocket *)webSocket
{
    NSString *UUID = [[NSUUID UUID] UUIDString];
    
    DLog(@"web socket: %@", webSocket);
    //NSString *helloMsg = @"{ \"type\":\"TYPE_OF_MESSAGE\",\"sequence_id\":\"09caaa73-b2b1-187e-2b24-683550a49b23\",\"data\":{}}";
    //                                                                        56134EF3-79FF-4104-B22B-8FD3D42C468E
    
    // Запрос для успешной операции аутентификации:
    //NSString *helloMsg = @"{\"type\":\"LOGIN_CUSTOMER\",\"sequence_id\":\"a29e4fd0-581d-e06b-c837-4f5f4be7dd18\",\"data\":{\"email\":\"fpi@bk.ru\",\"password\":\"123123\"}}";
    
    NSString *helloMsg = @"{\"type\":\"LOGIN_CUSTOMER\",\"sequence_id\":\"715c13b3-881a-9c97-b853-10be585a9747\",\"data\":{\"email\":\"fpi@bk.ru\",\"password\":\"123123\"}}";
    
    DLog(@"\nsent message: %@\n\n", helloMsg);
    [webSocket send:helloMsg];
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error
{
     DLog(@"\nerror : %@\n\n", error);
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
    DLog(@"\npongPayload.length = %lu\n\n", (unsigned long)pongPayload.length);
}
//
//   must have !!!
//

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message
{
     DLog(@"\nweb socket: %@\nmessage: %@\n\n", webSocket, message);
    //message = [[message stringByReplacingOccurrencesOfString:@"///" withString:@""] stringByReplacingOccurrencesOfString:@"\\\\\\" withString:@""];
    //message = [message gtm_stringByUnescapingFromHTML];
}



#pragma mark - UI Methods

- (IBAction)showLoginScreen:(id)sender
{
    
}
@end
