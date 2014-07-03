//
//  Talk.h
//  app
//
//  Created by MasanariKamoshita on 2014/06/30.
//  Copyright (c) 2014年 MasanariKamoshita. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Talk : NSObject
// インスタンス変数
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger periodStart;
@property (nonatomic, assign) NSInteger periodEnd;
@property (nonatomic, assign) NSInteger member;
@property (nonatomic, assign) NSInteger icon;
@property (nonatomic, assign) NSInteger posts;

@end