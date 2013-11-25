@class YumSource;

@interface SourceManager : NSObject


@property (strong, nonatomic) YumSource *currentYumSource;
@property (copy, nonatomic) void(^yumSourceChangedAction)(YumSource *);

+(YumSource *)currentYumSource;
+(void)setCurrentYumSource:(YumSource *)source;
+(void(^)(YumSource *))yumSourceChangedAction;
+(void)setYumSourceChangedAction:(void(^)(YumSource *))action;

@end
