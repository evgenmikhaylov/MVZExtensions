//
//  UIApplication+MVZEXtensions.h
//
//  Created by Evgeny Mikhaylov on 21/10/2016.
//  Copyright © 2016 Evgeny Mikhaylov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIApplication (MVZEXtensions)

@property (nonatomic, readonly) NSArray<__kindof UIViewController *> *visibleViewControllers;

@end
