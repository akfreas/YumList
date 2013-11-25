#import "SourceManager.h"
#import "YumSource.h"


@implementation SourceManager

-(id)init {
    self = [super init];
    if (self) {
        self.changedActions = [NSMutableArray array];
    }
    return self;
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

+(void)addYumSourceChangedAction:(void (^)(YumSource *))action {
    SourceManager *manager = [self sharedInstance];
    [manager.changedActions addObject:[action copy]];
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
    for (void(^block)(YumSource *) in managerInstance.changedActions) {
        block(currentYumSource);
    }
}

@end
