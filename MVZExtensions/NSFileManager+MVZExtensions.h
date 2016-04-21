//
//  NSFileManager+MVZExtensions.h
//
//  Created by EvgenyMikhaylov on 12/3/15.
//

#import <Foundation/Foundation.h>

@class RACSignal;

@interface NSFileManager (MVZExtensions)

+ (NSString *)mvz_documentsDirectory;
+ (NSString *)mvz_cacheDirectory;
+ (NSString *)mvz_tempDirectory;

- (RACSignal *)mvz_fileSystemFreeSizeSignal;
- (RACSignal *)mvz_attributesOfItemAtPathSignal:(NSString *)path;

- (RACSignal *)mvz_createDirectoryAtPathSignal:(NSString *)path;
- (RACSignal *)mvz_copyItemAtPathSignal:(NSString *)atPath toPath:(NSString *)path;
- (RACSignal *)mvz_copyItemsAtPathsSignal:(NSArray *)atPaths toPaths:(NSArray *)paths;
- (RACSignal *)mvz_moveItemAtPathSignal:(NSString *)atPath toPath:(NSString *)path;
- (RACSignal *)mvz_moveItemsAtPathsSignal:(NSArray *)atPaths toPaths:(NSArray *)paths;
- (RACSignal *)mvz_removeItemAtPathSignal:(NSString *)path;
- (RACSignal *)mvz_removeItemsAtPathsSignal:(NSArray *)paths;

- (RACSignal *)mvz_saveDataSignal:(NSData *)data toPath:(NSString *)path;
- (RACSignal *)mvz_saveDataArraySignal:(NSArray *)dataArray toPaths:(NSArray *)paths;

- (RACSignal *)mvz_imageJPEGRepresentationSignal:(UIImage *)image compressionQuality:(CGFloat)compressionQuality;
- (RACSignal *)mvz_imagePNGRepresentaionSignal:(UIImage *)image;
- (RACSignal *)mvz_imageAtPathSignal:(NSString *)path;
- (RACSignal *)mvz_imagesAtPathsSignal:(NSArray *)paths;
- (RACSignal *)mvz_saveImageJPEGRepresentationSignal:(UIImage *)image compressionQuality:(CGFloat)compressionQuality toPath:(NSString *)path;
- (RACSignal *)mvz_saveImagePNGRepresentaionSignal:(UIImage *)image toPath:(NSString *)path;

@end
