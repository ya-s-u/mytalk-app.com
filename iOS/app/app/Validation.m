//
//  Validation.m
//  app
//
//  Created by MasanariKamoshita on 2014/07/06.
//  Copyright (c) 2014年 MasanariKamoshita. All rights reserved.
//

#import "Validation.h"

@implementation Validation
@synthesize returnMessage;

-(NSString*)mailaddressValid:(NSString*) tg{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    BOOL matched = [predicate evaluateWithObject: tg];
    if(![tg canBeConvertedToEncoding:NSASCIIStringEncoding])
    {
        return(@"メールアドレスに全角文字が含まれています。");
    }
    if(!matched){
        return(@"正しいメールアドレスを入力してください。");
    }
    return 0;
}
-(NSString*)passwordValid:(NSString*) tg{
    //!$%&'()*,/;>=?{}~
    NSString *passRegex = @"[A-Z0-9a-z._%+-~{}?=>;/,*()'&%$!]+";
    NSRange range1 = [tg rangeOfString:@"<"];
    NSRange range2 = [tg rangeOfString:@"&{"];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passRegex];
    BOOL matched = [predicate evaluateWithObject: tg];
    if(![tg canBeConvertedToEncoding:NSASCIIStringEncoding])
    {
        return(@"パスワードに全角文字が含まれています。");
    }
    if(!matched){
        return(@"正しいパスワードを入力してください。");
    }
    if(range1.location != NSNotFound){
        return(@"記号\"<\"は使用できbません。");
    }
    if(range2.location != NSNotFound){
        return(@"文字列\"&{\"は使用できません。");
    }

    return 0;
}
@end
