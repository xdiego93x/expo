// Copyright 2015-present 650 Industries. All rights reserved.

#import <Foundation/Foundation.h>

@interface ABI33_0_0EXDownloadDelegate : NSObject <NSURLSessionDownloadDelegate>

typedef void (^ABI33_0_0EXDownloadDelegateOnWriteCallback)(NSURLSessionDownloadTask *task, int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite);

typedef void (^ABI33_0_0EXDownloadDelegateOnDownloadCallback)(NSURLSessionDownloadTask *task, NSURL *location);

typedef void (^ABI33_0_0EXDownloadDelegateOnErrorCallback)(NSError *error);


- (instancetype)initWithId:(NSString *)uuid
                   onWrite:(ABI33_0_0EXDownloadDelegateOnWriteCallback)onWrite
                onDownload:(ABI33_0_0EXDownloadDelegateOnDownloadCallback)onDownload
                   onError:(ABI33_0_0EXDownloadDelegateOnErrorCallback)onError;

@end
