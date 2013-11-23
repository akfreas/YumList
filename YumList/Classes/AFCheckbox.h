@interface AFCheckbox : UIButton


@property (nonatomic, assign) BOOL checked;
@property (copy, nonatomic) void(^buttonChecked)(BOOL);

@end
