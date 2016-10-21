//
//  RACChannel+MVZExtensions.h
//
//  Created by Evgeny Mikhaylov on 31/08/16.
//  Copyright © 2016 Igor. All rights reserved.
//

#import "ReactiveCocoa.h"

#define RACChannelTwoWayBinding(firstChannelTerminal, secondChannelTerminal) \
if (firstChannelTerminal && secondChannelTerminal) \
{ \
RACChannelTerminal *_firstChannelTerminal = firstChannelTerminal; \
RACChannelTerminal *_secondChannelTerminal = secondChannelTerminal; \
[_firstChannelTerminal subscribe:_secondChannelTerminal]; \
[_secondChannelTerminal subscribe:_firstChannelTerminal]; \
} \
else NSLog(@"WARNING: firstChannel or secondChannel is nil!");

#define RACChannelTwoWayBindingTakeUntil(firstChannelTerminal, secondChannelTerminal, takeUntilSignal) \
if (firstChannelTerminal && secondChannelTerminal) \
{ \
RACChannelTerminal *_firstChannelTerminal = firstChannelTerminal; \
RACChannelTerminal *_secondChannelTerminal = secondChannelTerminal; \
RACDisposable *firstDisposable = [_firstChannelTerminal subscribe:_secondChannelTerminal]; \
RACDisposable *secondDisposable = [_secondChannelTerminal subscribe:_firstChannelTerminal]; \
[takeUntilSignal subscribeNext:^(id x) { \
[firstDisposable dispose]; \
[secondDisposable dispose]; \
}]; \
} \
else NSLog(@"WARNING: firstChannel or secondChannel is nil!");

@interface RACChannel (MVZExtensions)

+ (RACChannelTerminal *)channelTerminalWithSignal:(RACSignal *)signal nextBlock:(void(^)(id x))nextBlock;

@end
