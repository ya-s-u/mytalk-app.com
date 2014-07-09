//
//  AppDelegate.h
//  app
//
//  Created by MasanariKamoshita on 2014/06/25.
//  Copyright (c) 2014年 MasanariKamoshita. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    NSMutableDictionary* globalBox;
    NSString* sessionID;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSMutableDictionary* globalBox;
@property (strong, nonatomic) NSString* sessionID;
@property (nonatomic) BOOL successFlag;
@end
