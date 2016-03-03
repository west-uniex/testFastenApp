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


- (void)setupSockets
{
    NSURL *url = [NSURL URLWithString:@"ws://52.29.182.220:8080/customer-gateway/customer"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    SRWebSocket *rusSocket = [[SRWebSocket alloc] initWithURLRequest:request];
    rusSocket.delegate = self;
    [rusSocket open];
}


- (void)webSocketDidOpen:(SRWebSocket *)webSocket
{
    DLog(@"web socket: %@", webSocket);
    //NSString *helloMsg = @"{ \"type\":\"TYPE_OF_MESSAGE\",\"sequence_id\":\"09caaa73-b2b1-187e-2b24-683550a49b23\",\"data\":{}}";
    
    // Запрос для успешной операции аутентификации:
    NSString *helloMsg = @"{\"type\":\"LOGIN_CUSTOMER\",\"sequence_id\":\"a29e4fd0-581d-e06b-c837-4f5f4be7dd18\",\"data\":{\"email\":\"fpi@bk.ru\",\"password\":\"123123\"}}";
    
    //                                                                    fee454fe-39bc-4623-bb82-4faeebc35a32
    //NSString *helloMsg = @"{\"type\":\"LOGIN_CUSTOMER\",\"sequence_id\":\"fee454fe-39bc-4623-bb82-4faeebc35a32\",\"data\":{\"email\":\"fpi@bk.ru\",\"password\":\"123123\"}}";
    
    // Запрос для new customer
    //NSString *helloMsg = @"{\"type\":\"LOGIN_CUSTOMER\",\"sequence_id\":\"a29e4fd0-581d-e06b-c837-4f5f4be7dd19\",\"data\":{\"email\":\"mikitaatamanyuk@gmail.com\",\"password\":\"123123\"}}";
    
    //c9bf3bd5-3bc8-4d79-93ec-ca59843f8a88
    //NSString *helloMsg = @"{\"type\":\"LOGIN_CUSTOMER\",\"sequence_id\":\"c9bf3bd5-3bc8-4d79-93ec-ca59843f8a88\",\"data\":{\"email\":\"mikitaatamanyuk@gmail.com\",\"password\":\"123123\"}}";
    
    DLog(@"\nsent message: %@\n\n", helloMsg);
    [webSocket send:helloMsg];
}


- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message
{
     DLog(@"\nweb socket: %@\nmessage: %@\n\n", webSocket, message);
    //message = [[message stringByReplacingOccurrencesOfString:@"///" withString:@""] stringByReplacingOccurrencesOfString:@"\\\\\\" withString:@""];
    //message = [message gtm_stringByUnescapingFromHTML];
}


@end
