//
//  NSFileManager+MVZExtensions.h
//
//  Created by EvgenyMikhaylov on 12/3/15.
//

#import "NSFileManager+MVZExtensions.h"
#import "ReactiveCocoa.h"

@implementation NSFileManager (MDZAdditions)

#pragma mark - Directories

+ (NSString *)mvz_documentsDirectory {
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    return path;
}

+ (NSString *)mvz_cacheDirectory {
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    return path;
}

+ (NSString *)mvz_tempDirectory {
    
    NSString *path = NSTemporaryDirectory();
    return path;
}

#pragma mark - Attributes

- (RACSignal *)mvz_fileSystemFreeSizeSignal {
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSError *error = nil;
        NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:paths.lastObject error:&error];
        if (error) {
            [subscriber sendError:error];
        }
        else {
            [subscriber sendNext:dictionary[NSFileSystemFreeSize]];
            [subscriber sendCompleted];
        }
        return nil;
    }];
}

- (RACSignal *)mvz_attributesOfItemAtPathSignal:(NSString *)path {
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSError *error = nil;
        NSDictionary *attributes = [self attributesOfItemAtPath:path error:&error];
        if (error) {
            [subscriber sendError:error];
        }
        else {
            [subscriber sendNext:attributes];
            [subscriber sendCompleted];
        }
        return nil;
    }];
}

#pragma mark - Items

- (RACSignal *)mvz_createDirectoryAtPathSignal:(NSString *)path {
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        if ([self fileExistsAtPath:path]) {
            [subscriber sendNext:nil];
            [subscriber sendCompleted];
        }
        else {
            NSError *error = nil;
            [self createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
            if (error) {
                [subscriber sendError:error];
            }
            else{
                [subscriber sendNext:nil];
                [subscriber sendCompleted];
            }
        }
        return nil;
    }];

}

- (RACSignal *)mvz_copyItemAtPathSignal:(NSString *)atPath toPath:(NSString *)path {
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSError *error = nil;
        [self copyItemAtPath:atPath toPath:path error:&error];
        if (error) {
            [subscriber sendError:error];
        }
        else{
            [subscriber sendNext:nil];
            [subscriber sendCompleted];
        }
        return nil;
    }];
}

- (RACSignal *)mvz_copyItemsAtPathsSignal:(NSArray *)atPaths toPaths:(NSArray *)paths {
    
    NSMutableArray *signals = [[NSMutableArray alloc] init];
    [atPaths enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [signals addObject:[self mvz_copyItemAtPathSignal:obj toPath:paths[idx]]];
    }];
    return [RACSignal merge:signals];
}

- (RACSignal *)mvz_moveItemAtPathSignal:(NSString *)atPath toPath:(NSString *)path {
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSError *error = nil;
        [self moveItemAtPath:atPath toPath:path error:&error];
        if (error) {
            [subscriber sendError:error];
        }
        else{
            [subscriber sendNext:nil];
            [subscriber sendCompleted];
        }
        return nil;
    }];
}

- (RACSignal *)mvz_moveItemsAtPathsSignal:(NSArray *)atPaths toPaths:(NSArray *)paths {
    
    NSMutableArray *signals = [[NSMutableArray alloc] init];
    [atPaths enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [signals addObject:[self mvz_moveItemAtPathSignal:obj toPath:paths[idx]]];
    }];
    return [RACSignal merge:signals];
}

- (RACSignal *)mvz_removeItemAtPathSignal:(NSString *)path {
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        if ([self fileExistsAtPath:path]) {
            NSError *error = nil;
            [self removeItemAtPath:path error:&error];
            if (error) {
                [subscriber sendError:error];
            }
            else{
                [subscriber sendNext:nil];
                [subscriber sendCompleted];
            }
        }
        else {
            [subscriber sendNext:nil];
            [subscriber sendCompleted];
        }
        return nil;
    }];
}

- (RACSignal *)mvz_removeItemsAtPathsSignal:(NSArray *)paths {
    
    NSMutableArray *signals = [[NSMutableArray alloc] init];
    [paths enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [signals addObject:[self mvz_removeItemAtPathSignal:obj]];
    }];
    return [RACSignal merge:signals];
}

#pragma mark - Data

- (RACSignal *)mvz_saveDataSignal:(NSData *)data toPath:(NSString *)path {
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSError *error = nil;
        [data writeToFile:path options:NSDataWritingAtomic error:&error];
        if (error) {
            [subscriber sendError:error];
        }
        else {
            [subscriber sendNext:data];
            [subscriber sendCompleted];
        }
        return nil;
    }];
}

- (RACSignal *)mvz_saveDataArraySignal:(NSArray *)dataArray toPaths:(NSArray *)paths {
    
    NSMutableArray *signals = [[NSMutableArray alloc] init];
    [dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [signals addObject:[self mvz_saveDataSignal:obj toPath:paths[idx]]];
    }];
    return [RACSignal combineLatest:signals];    
}

#pragma mark - Images

- (RACSignal *)mvz_imageJPEGRepresentationSignal:(UIImage *)image compressionQuality:(CGFloat)compressionQuality {
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSData *imageData = UIImageJPEGRepresentation(image, compressionQuality);
        [subscriber sendNext:imageData];
        [subscriber sendCompleted];
        return nil;
    }];
}

- (RACSignal *)mvz_imagePNGRepresentaionSignal:(UIImage *)image {
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSData *imageData = UIImagePNGRepresentation(image);
        [subscriber sendNext:imageData];
        [subscriber sendCompleted];
        return nil;
    }];
}

- (RACSignal *)mvz_imageAtPathSignal:(NSString *)path {
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        UIImage *image = [[UIImage alloc] initWithContentsOfFile:path];
        [subscriber sendNext:image];
        [subscriber sendCompleted];
        return nil;
    }];
}

- (RACSignal *)mvz_imagesAtPathsSignal:(NSArray *)paths {
    
    NSMutableArray *signals = [[NSMutableArray alloc] init];
    [paths enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [signals addObject:[self mvz_imageAtPathSignal:obj]];
    }];
    return [RACSignal combineLatest:signals];
}

- (RACSignal *)mvz_saveImageJPEGRepresentationSignal:(UIImage *)image compressionQuality:(CGFloat)compressionQuality toPath:(NSString *)path {
    
    return [[[NSFileManager defaultManager] mvz_imageJPEGRepresentationSignal:image compressionQuality:compressionQuality]
            flattenMap:^RACStream *(NSData *imageData) {
                return [[NSFileManager defaultManager] mvz_saveDataSignal:imageData toPath:path];
            }];
}

- (RACSignal *)mvz_saveImagePNGRepresentaionSignal:(UIImage *)image toPath:(NSString *)path {
    
    return [[[NSFileManager defaultManager] mvz_imagePNGRepresentaionSignal:image]
            flattenMap:^RACStream *(NSData *imageData) {
                return [[NSFileManager defaultManager] mvz_saveDataSignal:imageData toPath:path];
            }];
}


@end
