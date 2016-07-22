//
//  person.m
//  runtime各种测试
//
//  Created by luodp on 16/7/12.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "person.h"
#import "Dog.h"
#import <objc/runtime.h>
@interface person ()

@property (nonatomic,retain)NSImage * customImage;



@end


@implementation person

static char img_key; //has aunique address(identifier)

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addMethod];
        
//        [self getMethodFormClass];
    }
    return self;
}

- (NSImage *)customImage{
    return objc_getAssociatedObject(self,&img_key);
}

- (void)setCustomImage:(NSImage *)customImage{
    /**
     * Policies related to associative references.
     * These are options to objc_setAssociatedObject()
     */
//    typedef OBJC_ENUM(uintptr_t, objc_AssociationPolicy) {
//        OBJC_ASSOCIATION_ASSIGN = 0,           /**< Specifies a weak reference to the associated object. */
//        OBJC_ASSOCIATION_RETAIN_NONATOMIC = 1, /**< Specifies a strong reference to the associated object.
//                                                *   The association is not made atomically. */
//        OBJC_ASSOCIATION_COPY_NONATOMIC = 3,   /**< Specifies that the associated object is copied.
//                                                *   The association is not made atomically. */
//        OBJC_ASSOCIATION_RETAIN = 01401,       /**< Specifies a strong reference to the associated object.
//                                                *   The association is made atomically. */
//        OBJC_ASSOCIATION_COPY = 01403          /**< Specifies that the associated object is copied.
//                                                *   The association is made atomically. */
//    };
    objc_setAssociatedObject(self, &img_key, customImage, OBJC_ASSOCIATION_RETAIN);
   
}

void helloworld(){
    NSLog(@"helloWorld");

}
/**
 *  为这个类添加方法实现
 */
-(void)addMethod{
//    IMP 关键字 implemention
    class_addMethod([person class], @selector(helloworld2), (IMP)helloworld, "v@:");

    [self helloworld2];
    
}
//获取方法的typeEncoding
-(void)getMethodTypeEncoding{
    NSLog(@"type encoding %s",method_getTypeEncoding(class_getInstanceMethod([person class], @selector(setCustomImage:))));
    //    2016-07-14 10:44:00.418 runtime各种测试[1330:551826] type encoding v24@0:8@16
    //    v 该方法的返回值为void
    //    24 说明整个方法占用24个字节
    //    @0表示offset0的位置是self   不变
    //    :8 表示offset8的位置是SEL   不变
    //    @16表示offset16的位置为oc指针类型参数1 oc指针类型都是@,其余的基本类型为 i,c等等
}
//从类里获取一个方法的名字
-(void)getMethodFormClass{
    Method m = class_getInstanceMethod([self class], @selector(addMethod));
    NSLog(@"方法名:%@",[NSString stringWithCString:sel_getName(method_getName(m)) encoding:NSUTF8StringEncoding]);
    
}


+(instancetype)sharedPerson{
    static person *p;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        p = [person new];
    });
    return p;
}

//消息转发第一步,先从这个方法中查看能否获取到对象方法实现,能的话就返回yes,否则为no
+(BOOL)resolveInstanceMethod:(SEL)sel{
    if (sel == @selector(run)) {
        class_addMethod(self, sel, (IMP)helloworld, "v@:");
        return YES;
    }else if (sel == @selector(sleep)){
        return NO;
    }
    return  [super resolveInstanceMethod:sel];
}
//消息转发第二步,返回一个方法实现的类来进行调动改方法,aSelector是传入的调用哪个方法
-(id)forwardingTargetForSelector:(SEL)aSelector{
    return [Dog new];
}


//消息转发第三步,先生成方法签名,然后进行方法调用
-(NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector{
    if (aSelector == @selector(peer)) {
        return [NSMethodSignature signatureWithObjCTypes:"v@:"];
    }
    return [super methodSignatureForSelector:aSelector];
}
//方法调用,这是最后一步,消息转发越往后花费的代价就越大
-(void)forwardInvocation:(NSInvocation *)anInvocation{
    SEL aseleter = [anInvocation selector];
    Dog *dog = [Dog new];
    if ([dog respondsToSelector:aseleter]) {
        [anInvocation invokeWithTarget:dog];
    }
    
}



@end
