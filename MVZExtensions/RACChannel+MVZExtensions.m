//
//  RACChannel+MVZExtensions.m
//
//  Created by Evgeny Mikhaylov on 31/08/16.
//  Copyright © 2016 Igor. All rights reserved.
//

#import "RACChannel+MVZExtensions.h"

@implementation RACChannel (MVZExtensions)

+ (RACChannelTerminal *)channelTerminalWithSignal:(RACSignal *)signal nextBlock:(void(^)(id x))nextBlock {
    RACChannel *channel = [[RACChannel alloc] init];
    [signal subscribe:channel.leadingTerminal];
    [channel.leadingTerminal subscribeNext:nextBlock];
    return channel.followingTerminal;
}

@end
