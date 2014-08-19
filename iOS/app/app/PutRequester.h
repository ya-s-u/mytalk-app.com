//
//  PutRequester.h
//  app
//
//  Created by MasanariKamoshita on 2014/08/19.
//  Copyright (c) 2014年 MasanariKamoshita. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PutRequester : NSObject
-(NSInteger)putJSON:(NSString *)msg puttingType:(NSInteger) type talkID:(NSString *) talkID;
@end
