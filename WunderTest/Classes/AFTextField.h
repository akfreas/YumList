@interface AFTextField : UITextField
@property (copy, nonatomic) void(^returnKeyboardButtonAction)(AFTextField *textField);
@property (copy, nonatomic) void(^didBeginEditingAction)(AFTextField *textField);
@property (copy, nonatomic) void(^didEndEditingAction)(AFTextField *textField);

-(void)setUnselectedBackground;
-(void)setSelectedBackground;

@end
