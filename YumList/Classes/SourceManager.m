#import "SourceManager.h"
#import "YumSource.h"


@implementation SourceManager {
}

+(SourceManager *)sharedInstance {
    static SourceManager *sharedInstance;
    if (sharedInstance == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            sharedInstance = [SourceManager new];
        });
    }
    return sharedInstance;
}

+(void)setYumSourceChangedAction:(void (^)(YumSource *))action {
    SourceManager *manager = [self sharedInstance];
    manager.yumSourceChangedAction = action;
}

+(void (^)(YumSource *))yumSourceChangedAction {
    SourceManager *manager = [self sharedInstance];
    return manager.yumSourceChangedAction;
}

+(YumSource *)currentYumSource {
    return [[self sharedInstance] currentYumSource];
}

+(void)setCurrentYumSource:(YumSource *)currentYumSource {
    SourceManager *managerInstance = [self sharedInstance];
    managerInstance.currentYumSource = currentYumSource;
    if (managerInstance.yumSourceChangedAction != NULL) {
        managerInstance.yumSourceChangedAction(currentYumSource);
    }
}

@end
