//
//  PutRequester.m
//  app
//
//  Created by MasanariKamoshita on 2014/08/19.
//  Copyright (c) 2014年 MasanariKamoshita. All rights reserved.
//

#import "PutRequester.h"
#import "LUKeychainAccess.h"

@implementation PutRequester
- (NSInteger)putJSON:(NSString *)msg puttingType:(NSInteger) type talkID:(NSString *) talkID{
    NSString *param = [[NSString alloc] init];
    if(type == 0){//アイコン
        param = [NSString stringWithFormat:@"icon=%@", msg];
    } else if(type == 1){//自分の名前
        param = [NSString stringWithFormat:@"author=%@", msg];
    } else if(type == 2){ //トークタイトル
        param = [NSString stringWithFormat:@"title=%@", msg];
        if([msg length] > 19) return 1;
    } else {// 共有設定
        param = [NSString stringWithFormat:@"shared=%@", msg];
    }
    
    NSArray *cookieTmp = [[LUKeychainAccess standardKeychainAccess] objectForKey:@"cookie"];
    NSArray *cookie = [NSArray arrayWithObjects:[cookieTmp objectAtIndex:([cookieTmp count] - 1)], nil];
    
    NSError *error = nil;
    NSHTTPURLResponse *response = nil;
    NSString *url = [NSString stringWithFormat:@"http://omoide.folder.jp/api/talks/%@",talkID];
    // NSHTTPCookieを作成
    NSDictionary *header = [NSHTTPCookie requestHeaderFieldsWithCookies:cookie];
    
    
    //リクエストを生成
    NSMutableURLRequest *request;
    request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"PUT"];
    [request setURL:[NSURL URLWithString:url]];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setTimeoutInterval:20];
    [request setAllHTTPHeaderFields:header];
    [request setHTTPBody:[param dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    //同期通信で送信
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (error != nil) {
        NSLog(@"送信エラー");
        return 1;
    }
    
    //取得したレスポンス
    NSInteger status = [(NSHTTPURLResponse*)response statusCode];
    NSLog(@"statuscode:%ld",status);
    
    if (status == 400) {
        NSLog(@"受信エラー");
        return 1;
    }
    //cookieを取得しようとしてみる
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    NSArray *cookieReceived = [NSHTTPCookie cookiesWithResponseHeaderFields:httpResponse.allHeaderFields forURL:response.URL];
    //cookieを取得できたら
    if([cookieReceived count] != 0){
        NSHTTPCookie *rescookie = [cookieReceived objectAtIndex:0];
        NSHTTPCookie *originalCookie = [cookie objectAtIndex:0];
        //SessionIDが変更があればCookieをKeyChainに保存する
        if(rescookie.value != originalCookie.value){
            [[LUKeychainAccess standardKeychainAccess] setObject:cookieReceived forKey:@"cookie"];
        };
    }
    
    return 0;
}
@end
