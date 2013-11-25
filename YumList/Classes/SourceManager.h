@class YumSource;

@interface SourceManager : NSObject


@property (strong, nonatomic) YumSource *currentYumSource;
@property (copy, nonatomic) void(^yumSourceChangedAction)(YumSource *);
@property (strong, nonatomic) NSMutableArray *changedActions;

+(YumSource *)currentYumSource;
+(void)setCurrentYumSource:(YumSource *)source;
+(void(^)(YumSource *))yumSourceChangedAction;
+(void)addYumSourceChangedAction:(void(^)(YumSource *))action;

@end
