//
//  AppDelegate.m
//  XMPP
//
//  Created by Sir-Anne-Blair on 16/3/21.
//  Copyright © 2016年 anne-blair. All rights reserved.
//

#import "AppDelegate.h"
#import "XMPPFramework.h"
@interface AppDelegate ()<XMPPStreamDelegate>
@property (nonatomic,strong) XMPPStream * Stream;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.Stream=[[XMPPStream alloc]init];
    
    //添加代理
    dispatch_queue_t queue=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    [self.Stream addDelegate:self delegateQueue:queue];
    //创建一个登陆或注册用户名，domain:XMPP服务器的IP地址
    //resource :客户端设备的类型，随便写
    XMPPJID * jid=[XMPPJID jidWithUser:@"zhrmghg" domain:@"115.159.1.248" resource:@"iPhone 8s"];
    //把用户添加到XMPP流中
    self.Stream.myJID=jid;
    
    //和服务器建立连接
    [self.Stream connectWithTimeout:-1 error:nil];
    
    return YES;
}

#pragma mark _xmpp的代理方法
/**
 *  和服务器已经成功的建立了连接，
 */
-(void)xmppStreamDidConnect:(XMPPStream *)sender
{
    //
    NSLog(@"已经和服务器建立好连接了");
    //先建立连接发送账号，后建立连接后发送密码
   // [self.Stream registerWithPassword:@"007" error:nil];
    //注册新用户
    
    //登陆
    [self.Stream authenticateWithPassword:@"007" error:nil];
}
-(void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error
{
    NSLog(@"和服务器建立连接失败");
}
-(void)xmppStreamDidRegister:(XMPPStream *)sender
{
    NSLog(@"注册成功");
}
-(void)xmppStream:(XMPPStream *)sender didNotRegister:(DDXMLElement *)error
{
    NSLog(@"该用户已经存在");
}

-(void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
    NSLog(@"登陆成功");
    //告诉服务器在线
    XMPPPresence * session=[XMPPPresence presence];
    [self.Stream sendElement:session];
    //给好友发送消息
    XMPPJID * jid=[XMPPJID jidWithUser:@"f23ff" domain:@"115.159.1.248" resource:@"hah"];
    XMPPMessage * msg=[XMPPMessage messageWithType:@"chat" to:jid];
    [msg addBody:@"hello.world"];
    DDXMLNode * node=[DDXMLNode elementWithName:@"age" stringValue:@"王者"];
    [msg addChild:node];
    NSLog(@"%@",msg);
    [self.Stream sendElement:msg];
    
}
-(void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error
{
    NSLog(@"登陆失败，用户名，或密码错误");
}
//发送成功
-(void)xmppStream:(XMPPStream *)sender didSendMessage:(XMPPMessage *)message
{
    DDXMLNode * node=message.children[1];
    NSString * str=[node stringValue];
    NSString * str1=[node name];
    NSLog(@"%@--%@----%@",node,str,str1);
    NSLog(@"发送成功,内容是:%@",message.body);
}
-(void)xmppStream:(XMPPStream *)sender didFailToSendMessage:(XMPPMessage *)message error:(NSError *)error
{
    NSLog(@"发送失败");
}
-(void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message
{
    
    NSLog(@"收到了对方发过来的消息：%@",message.body);
}

@end
