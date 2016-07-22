//
//  person.h
//  runtime各种测试
//
//  Created by luodp on 16/7/12.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol PersonAction <NSObject>

@optional

-(void)eat;

@end

@interface person : NSObject<PersonAction>
+(instancetype)sharedPerson;

-(void)helloworld2;
-(void)getCustomMemberOfTheClassProperty;
-(void)getMethodFormClass;

-(void)respondsTest;

-(void)run;
-(void)sleep;
-(void)peer;

@end
