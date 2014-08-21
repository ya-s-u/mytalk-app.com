//
//  AppDelegate.m
//  app
//
//  Created by MasanariKamoshita on 2014/06/25.
//  Copyright (c) 2014年 MasanariKamoshita. All rights reserved.
//

#import "AppDelegate.h"
#import "LUKeychainAccess.h"


//#import "talk.h"
//#import "TalkTableViewController.h"

@implementation AppDelegate

UIColor * textColor = nil;
UIFont * textFont = nil;
UIFont * textTitleFont = nil;
+ (void) initialize
{
    //全アプリの基本テキストカラー(#f9f9f9)
    if (textColor == nil) textColor = [UIColor colorWithRed:0.576 green:0.576 blue:0.576 alpha:1.0];
    //トーク画面の上部日付ラベル
    if (textFont == nil) textFont = [UIFont fontWithName:@"Hiragino Kaku Gothic ProN" size:13];
    //追加ヘルパーのタイトルラベル
    if (textTitleFont == nil) textTitleFont = [UIFont fontWithName:@"Hiragino Kaku Gothic ProN" size:16];
    //アイコンの数（のちのち追加）
    

}
- (BOOL)application:(UIApplication *)application openURL:(NSURL*)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    if( [[url pathExtension] isEqualToString:@"txt"] ){
        // ここでzipの処理.
        NSArray* paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES);
        NSString* pathDocumentRoot = [paths objectAtIndex:0];
        NSString*	pathTempText	= [pathDocumentRoot stringByAppendingPathComponent:[url lastPathComponent]];
        NSFileManager* fm	= [NSFileManager defaultManager];
        NSError* error = nil;
        if( [fm moveItemAtPath:[url path] toPath:pathTempText error:&error] ){
            NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:pathTempText];
            if (!fileHandle) {
                NSLog(@"ファイルがありません．");
                return NO;
            }
            NSData *data = [fileHandle readDataToEndOfFile];
            if(![self postJSON:data]) return NO;
            else {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                                    message:@"アップロード完了"
                                                                   delegate:nil
                                                          cancelButtonTitle:nil
                                                          otherButtonTitles:@"OK", nil];
                [alertView show];
                
            }
            [fileHandle closeFile];
            return YES;
        }
        return NO;
    }
    return NO;
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{

}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
   
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{

}

- (void)applicationWillTerminate:(UIApplication *)application
{

}
-(BOOL)postJSON:(NSData *) query{
    NSArray *cookieTmp = [[LUKeychainAccess standardKeychainAccess] objectForKey:@"cookie"];
    NSArray *cookie = [NSArray arrayWithObjects:[cookieTmp objectAtIndex:([cookieTmp count] - 1)], nil];
    
    NSError *error = nil;
    NSHTTPURLResponse *response = nil;
    NSString *url = @"http://omoide.folder.jp/api/talks";
    // NSHTTPCookieを作成
    NSDictionary *header = [NSHTTPCookie requestHeaderFieldsWithCookies:cookie];
    
    //リクエストを生成
    NSMutableURLRequest *request;
    request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"POST"];
    [request setURL:[NSURL URLWithString:url]];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setTimeoutInterval:20];
    [request setAllHTTPHeaderFields:header];
    [request setHTTPBody:query];
    
    //同期通信で送信
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (error != nil) {
        NSLog(@"送信エラー");
        return NO;
    }
    
    //取得したレスポンスをJSONパース
    NSInteger status = [(NSHTTPURLResponse*)response statusCode];
    NSLog(@"statuscode:%ld",status);
    if (status == 400) {
        NSLog(@"受信エラー");
        return NO;
    }
    //cookieを取得しようとしてみる
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    NSArray *cookies = [NSHTTPCookie cookiesWithResponseHeaderFields:httpResponse.allHeaderFields forURL:response.URL];
    //cookieを取得できたら
    if([cookies count] != 0){
        NSHTTPCookie *rescookie = [cookies objectAtIndex:0];
        //SessionIDが変更があればCookieをKeyChainに保存する
        NSHTTPCookie *originalCookie = [cookie objectAtIndex:0];
        //SessionIDが変更があればCookieをKeyChainに保存する
        if(rescookie.value != originalCookie.value){
            [[LUKeychainAccess standardKeychainAccess] setObject:cookies forKey:@"cookie"];
            
        };
    }
    return YES;
    
}

@end
