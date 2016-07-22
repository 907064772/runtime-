//
//  main.m
//  runtime各种测试
//
//  Created by luodp on 16/7/12.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "person.h"
/**
 *  从这个类中获取自定义成员属性列表
 */
void getCustomMemberOfTHeClassProperties(){
    person *pers = [person sharedPerson];
    unsigned int outCount;
//    传入类和可写入的数量值返回值是数组
//    class_copyPropertyList(<#__unsafe_unretained Class cls#>, <#unsigned int *outCount#>)
    objc_property_t * properties = class_copyPropertyList([pers class], &outCount);
//    循环遍历这个数,取出数组的每个属性,打印出名字
    for (int i = 0; i<outCount; i++) {
        objc_property_t property = properties[i];
        NSLog(@"所有属性:%@",[NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding]);
    }
//    释放这个数组
    free(properties);

}
/**
 *  后去自定义成员属性
 */
void getCustomMemberOfTheClassProperty(){
    person *pers = [person sharedPerson];
//    传入类和属性名
//    class_getProperty(<#__unsafe_unretained Class cls#>, <#const char *name#>)
    objc_property_t property = class_getProperty([pers class], "customImage");
    NSLog(@"单一属性:%@",[NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding]);
    
    
}
/**
 *  为这个了类添加方法实现
 */
void addMethodForClass(){
    person *pers = [person sharedPerson];
//    传入需要添加的类,类声明,类实现,以及方法typeEncoding
    class_addMethod([pers class], @selector(getCustomMemberOfTheClassProperty), (IMP)getCustomMemberOfTheClassProperty, "v@:");
    [pers getCustomMemberOfTheClassProperty];
}
/**
 *  获取方法列表
 *
 *  @param count 方法列表的数量
 *
 *  @return 方法列表
 */
Method * getMethodListFormClass(int *count){
    person *pers = [person sharedPerson];
    unsigned int outCount = 0;
    Method *methodList = class_copyMethodList([pers class], &outCount);
    for (int index = 0; index<outCount; index++) {
        Method m = methodList[index];
          NSLog(@"方法名:%@",[NSString stringWithCString:sel_getName(method_getName(m)) encoding:NSUTF8StringEncoding]);
    }
    *count = outCount;
    free(methodList);
    return methodList;
}
/**
 *  替换掉方法实现
 */
void replaceMethodImplementation(){
//    传入类 方法声明  方法实现  方法实现的typeEncoding
    class_replaceMethod([[person sharedPerson] class], @selector(getMethodFormClass), (IMP)getMethodListFormClass, "v@:");
}
/**
 *  获取方法实现,以及使用IMP直接调用方法
 */
void getMethodImplementation(){
    person *p = [person sharedPerson];
//    获取方法实现,返回值是一个IMP类型
    IMP helloWorld = class_getMethodImplementation([p class], @selector(helloworld2));
//    这个方法实现没有参数.所以可以直接调用
    helloWorld();
}
/**
 *  响应方法
 */
void respondsToSelector(){
    person * p = [person sharedPerson];
    if (class_respondsToSelector([p class], @selector(respondsTest))) {
        NSLog(@"实现了");
    }else{
        NSLog(@"未响应");
    }
}
/**
 *  添加协议
 */
void addProtocolForClass(){
    person *p = [person sharedPerson];
    Protocol * protocol;
    class_addProtocol([p class], protocol);
}
/**
 *  该方法有点不会写
 */
void addPropertyForClass(){
    person *p = [person sharedPerson];
    objc_property_attribute_t attribute1;
    attribute1.name = "name1";
    attribute1.value = "1";
    objc_property_attribute_t attribute2;
    attribute2.name = "name2";
    attribute2.value = "2";
    objc_property_attribute_t attributes[] = {attribute1,attribute2};
    class_addProperty([p class], "name", attributes, 2);
}
/**
 *  获取协议列表
 */
void getProtocolList(){
    person *p = [person sharedPerson];
    unsigned int outCount = 0;
    Protocol * __unsafe_unretained * proList = class_copyProtocolList([p class], &outCount);
    for (int index = 0; index<outCount; index++) {
        Protocol *pro = proList[index];
        NSLog(@"协议名称:%s",protocol_getName(pro));
    }
}
void getVersion(){
    person *p = [person sharedPerson];
    NSLog(@"类版本:%d",class_getVersion([p class]));
}
void setVersion(){
    person *p = [person sharedPerson];
    class_setVersion([p  class], 1);
}
/**
 *  返回值类型
 */
void copyReturnType(){
    int outCount = 0;
    Method *methodList = getMethodListFormClass(&outCount);
    for (int index = 0; index<outCount; index ++) {
        Method m = methodList[index];
        NSLog(@"返回返回参数类型:%s",method_copyReturnType(m));
    }
}
/**
 *  方法参数类型
 */
void copyArgumentType(){
    person *p = [person sharedPerson];
    Method m = class_getInstanceMethod([p class], @selector(helloworld2));
//2016-07-14 17:14:45.882 runtime各种测试[3866:1747424] @ 第一个参数为self
    NSLog(@"%s", method_copyArgumentType(m, 0));
    
    
}
/**
 *  imagename
 */
void copyImageNames(){
    unsigned int outCount;
    const char ** nameList = objc_copyImageNames(&outCount);
    for (int index = 0; index<outCount; index++) {
        char *name = nameList[index];
        NSLog(@"%s",name);
    }
}

void getImageName(){
    person * p = [person sharedPerson];
    NSLog(@"%s",class_getImageName([p class]));
    
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
//        getCustomMemberOfTheClassProperty();
//        addMethodForClass();
        
//        getMethodListFormClass();
        
//        replaceMethodImplementation();
        
//        [[person sharedPerson] getMethodFormClass];
//        getMethodImplementation();
//        respondsToSelector();
//        addProtocolForClass();
//        getProtocolList();
//        setVersion();
//        getVersion();
//        copyReturnType();
//        copyArgumentType();
//        copyImageNames();
//        getImageName();
//
        [[person sharedPerson]run];
//        [[person sharedPerson] peer];
    }
    return 0;
}
