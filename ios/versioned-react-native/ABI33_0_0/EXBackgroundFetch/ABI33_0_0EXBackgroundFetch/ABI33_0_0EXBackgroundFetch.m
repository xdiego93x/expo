// Copyright 2018-present 650 Industries. All rights reserved.

#import <ABI33_0_0UMCore/ABI33_0_0UMDefines.h>
#import <ABI33_0_0EXBackgroundFetch/ABI33_0_0EXBackgroundFetch.h>
#import <ABI33_0_0EXBackgroundFetch/ABI33_0_0EXBackgroundFetchTaskConsumer.h>
#import <ABI33_0_0UMTaskManagerInterface/ABI33_0_0UMTaskManagerInterface.h>

@interface ABI33_0_0EXBackgroundFetch ()

@property (nonatomic, weak) id<ABI33_0_0UMTaskManagerInterface> taskManager;

@end

@implementation ABI33_0_0EXBackgroundFetch

ABI33_0_0UM_EXPORT_MODULE(ExpoBackgroundFetch);

- (void)setModuleRegistry:(ABI33_0_0UMModuleRegistry *)moduleRegistry
{
  _taskManager = [moduleRegistry getModuleImplementingProtocol:@protocol(ABI33_0_0UMTaskManagerInterface)];
}

ABI33_0_0UM_EXPORT_METHOD_AS(getStatusAsync,
                    getStatus:(ABI33_0_0UMPromiseResolveBlock)resolve
                    reject:(ABI33_0_0UMPromiseRejectBlock)reject)
{
  dispatch_async(dispatch_get_main_queue(), ^{
    resolve(@([self _getStatus]));
  });
}

ABI33_0_0UM_EXPORT_METHOD_AS(setMinimumIntervalAsync,
                    setMinimumInterval:(nonnull NSNumber *)minimumInterval
                    resolve:(ABI33_0_0UMPromiseResolveBlock)resolve
                    reject:(ABI33_0_0UMPromiseRejectBlock)reject)
{
  dispatch_async(dispatch_get_main_queue(), ^{
    NSTimeInterval timeInterval = [minimumInterval doubleValue];
    [[UIApplication sharedApplication] setMinimumBackgroundFetchInterval:timeInterval];
    resolve(nil);
  });
}

ABI33_0_0UM_EXPORT_METHOD_AS(registerTaskAsync,
                    registerTaskWithName:(nonnull NSString *)taskName
                    options:(nullable NSDictionary *)options
                    resolve:(ABI33_0_0UMPromiseResolveBlock)resolve
                    reject:(ABI33_0_0UMPromiseRejectBlock)reject)
{
  if (![_taskManager hasBackgroundModeEnabled:@"fetch"]) {
    return reject(
                  @"E_BACKGROUND_FETCH_DISABLED",
                  @"Background Fetch has not been configured. To enable it, add `fetch` to `UIBackgroundModes` in the application's Info.plist file.",
                  nil
                  );
  }

  @try {
    [_taskManager registerTaskWithName:taskName
                              consumer:ABI33_0_0EXBackgroundFetchTaskConsumer.class
                               options:options];
  }
  @catch (NSException *e) {
    return reject(e.name, e.reason, nil);
  }
  resolve(nil);
}

ABI33_0_0UM_EXPORT_METHOD_AS(unregisterTaskAsync,
                    unregisterTaskWithName:(nonnull NSString *)taskName
                    resolve:(ABI33_0_0UMPromiseResolveBlock)resolve
                    reject:(ABI33_0_0UMPromiseRejectBlock)reject)
{
  @try {
    [_taskManager unregisterTaskWithName:taskName consumerClass:[ABI33_0_0EXBackgroundFetchTaskConsumer class]];
  } @catch (NSException *e) {
    return reject(e.name, e.reason, nil);
  }
  resolve(nil);
}

# pragma mark - helpers

- (ABI33_0_0EXBackgroundFetchStatus)_getStatus
{
  UIBackgroundRefreshStatus refreshStatus = [[UIApplication sharedApplication] backgroundRefreshStatus];

  switch (refreshStatus) {
    case UIBackgroundRefreshStatusRestricted:
      return ABI33_0_0EXBackgroundFetchStatusRestricted;
    case UIBackgroundRefreshStatusDenied:
      return ABI33_0_0EXBackgroundFetchStatusDenied;
    case UIBackgroundRefreshStatusAvailable:
      return ABI33_0_0EXBackgroundFetchStatusAvailable;
  }
}

@end
