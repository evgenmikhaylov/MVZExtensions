//
//  UIApplication+MVZEXtensions.m
//
//  Created by Evgeny Mikhaylov on 21/10/2016.
//  Copyright © 2016 Evgeny Mikhaylov. All rights reserved.
//

#import "UIApplication+MVZEXtensions.h"
#import <objc/runtime.h>

@interface UIApplication ()

@property (nonatomic) NSArray<__kindof UIViewController *> *visibleViewControllers;

@end

@implementation UIApplication (MVZEXtensions)

- (void)setVisibleViewControllers:(NSArray<__kindof UIViewController *> *)visibleViewControllers {
    objc_setAssociatedObject(self, @selector(visibleViewControllers), visibleViewControllers, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSArray<UIViewController *> *)visibleViewControllers {
    NSArray<__kindof UIViewController *> *visibleViewControllers = objc_getAssociatedObject(self, @selector(visibleViewControllers));
    if (!visibleViewControllers) {
        visibleViewControllers = [[NSArray alloc] init];
        objc_setAssociatedObject(self, @selector(visibleViewControllers), visibleViewControllers, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return visibleViewControllers;
}

@end

@implementation UIViewController (UIApplication_MVZEXtensions)

+ (void)swizzleMethodWithOriginalSelector:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector {
    Class class = [self class];
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    if (didAddMethod) {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleMethodWithOriginalSelector:@selector(viewDidAppear:)
                               swizzledSelector:@selector(uiapplication_mvzextensions_viewDidAppear:)];
        [self swizzleMethodWithOriginalSelector:@selector(viewDidDisappear:)
                               swizzledSelector:@selector(uiapplication_mvzextensions_viewDidDisappear:)];
    });
}

- (void)uiapplication_mvzextensions_viewDidAppear:(BOOL)animated {
    __weak typeof (self) weakSelf = self;
    NSMutableArray<__kindof UIViewController *> *visibleViewControllers = [UIApplication sharedApplication].visibleViewControllers.mutableCopy;
    [visibleViewControllers addObject:weakSelf];
    [UIApplication sharedApplication].visibleViewControllers = visibleViewControllers.copy;
    [self uiapplication_mvzextensions_viewDidAppear:animated];
}

- (void)uiapplication_mvzextensions_viewDidDisappear:(BOOL)animated {
    NSMutableArray<__kindof UIViewController *> *visibleViewControllers = [UIApplication sharedApplication].visibleViewControllers.mutableCopy;
    [visibleViewControllers removeObject:self];
    [UIApplication sharedApplication].visibleViewControllers = visibleViewControllers.copy;
    [self uiapplication_mvzextensions_viewDidDisappear:animated];
}

@end
