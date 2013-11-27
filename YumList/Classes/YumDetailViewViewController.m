#import "YumDetailViewViewController.h"
#import "YumItem.h"
#import "PBWebViewController.h"

@interface YumDetailViewViewController ()

@end

@implementation YumDetailViewViewController {
    
    UIImageView *mainImageView;
    UILabel *titleLabel;
    UIButton *viewRecipeButton;
    UIButton *iMadeThisButton;
    UIButton *addPhotoButton;
}


-(id)initWithYumItem:(YumItem *)yumItem {
    self = [super init];
    
    if (self) {
        self.yumItem = yumItem;
        self.title = yumItem.title;
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    return self;
}

-(void)addMainImageView {
    
    UIImage *mainImage = [UIImage imageWithData:_yumItem.image scale:[UIApplication sharedApplication].keyWindow.screen.scale];
    mainImageView = [[UIImageView alloc] initWithImage:mainImage];
    mainImageView.contentMode = UIViewContentModeScaleAspectFill;
    mainImageView.layer.masksToBounds = YES;
    [self.view addSubview:mainImageView];
    
}

-(void)addRecipeTitleLabel {
    titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.view addSubview:titleLabel];
    titleLabel.text = _yumItem.title;
    titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    titleLabel.numberOfLines = 10;
    [titleLabel sizeToFit];
}

-(void)addExternalRecipeButton {
    UIButton * externalViewRecipeButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [externalViewRecipeButton setTitle:NSLocalizedString(@"View Recipe", @"Button to view recipe in webview.") forState:UIControlStateNormal];
    [externalViewRecipeButton addEventHandler:^(id sender) {
        PBWebViewController *externalView = [[PBWebViewController alloc] init];
        externalView.URL = [NSURL URLWithString:_yumItem.externalURL];
        [self.navigationController pushViewController:externalView animated:YES];
    } forControlEvents:UIControlEventTouchUpInside];
    viewRecipeButton = externalViewRecipeButton;
    viewRecipeButton.backgroundColor = [UIColor colorWithHue:146.0f saturation:0.40f brightness:0.65f alpha:1.0f];
    [self.view addSubview:viewRecipeButton];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:viewRecipeButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:mainImageView attribute:NSLayoutAttributeBaseline multiplier:1.0f constant:30.0f]];
    NSDictionary *bindings = MXDictionaryOfVariableBindings(viewRecipeButton);
    [self.view addConstraintWithVisualFormat:@"V:[viewRecipeButton(44)]" bindings:bindings];
    [self.view addConstraintWithVisualFormat:@"H:|-30-[viewRecipeButton]-30-|" bindings:bindings];
}

-(void)setupLayoutConstraints {
    NSDictionary *bindings = MXDictionaryOfVariableBindings(mainImageView, titleLabel);
    [self.view addConstraintWithVisualFormat:@"H:|-20-[mainImageView(100)]-[titleLabel]-|" bindings:bindings];
    [self.view addConstraintWithVisualFormat:@"V:|-20-[mainImageView(100)]" bindings:bindings];
    [self.view addConstraintWithVisualFormat:@"V:|-20-[titleLabel]" bindings:bindings];
}

-(void)setYumItem:(YumItem *)yumItem {
    _yumItem = yumItem;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
    [_yumItem populatePropertiesFromExternalService:^(YumItem *item){
        [self addExternalRecipeButton];
        titleLabel.text = item.title;
        [titleLabel sizeToFit];
    }];
    [self addMainImageView];
    [self addRecipeTitleLabel];
    [self setupLayoutConstraints];
}

-(void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

@end
