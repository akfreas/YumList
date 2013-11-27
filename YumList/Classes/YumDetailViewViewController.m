#import "YumDetailViewViewController.h"
#import "YumItem.h"
#import "PBWebViewController.h"

#define PostMadeThisButtonTakePhoto 1

#define PostUploadPhotoButtonUseLastPhotoTaken 0
#define PostUploadPhotoButtonPullFromLibrary 1
#define PostUploadPhotoButtonTakePicture 2

@interface YumDetailViewViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

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
    viewRecipeButton.backgroundColor = [UIColor crayolaJungleGreenColor];
    [self.view addSubview:viewRecipeButton];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:viewRecipeButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:mainImageView attribute:NSLayoutAttributeBaseline multiplier:1.0f constant:30.0f]];
}

-(void)addIMadeThisButton {
    UIButton *madeThisButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [madeThisButton setTitle:NSLocalizedString(@"I Made This", @"I made this button title.") forState:UIControlStateNormal];
    [madeThisButton addEventHandler:^(id sender) {
        [self presentActionSheetAfterIMadeThis];
    } forControlEvents:UIControlEventTouchUpInside];
    iMadeThisButton = madeThisButton;
    iMadeThisButton.backgroundColor = [UIColor crayolaJungleGreenColor];
    [self.view addSubview:iMadeThisButton];

}

-(void)presentActionSheetAfterIMadeThis {
    UIAlertView *alert = [UIAlertView alertViewWithTitle:NSLocalizedString(@"Awesome!\nDo you want to add a photo?", @"Prompt for do you want to add a photo.")];
    [alert addButtonWithTitle:NSLocalizedString(@"Not Now", @"'dont want to add photo now' button") handler:NULL];
    [alert addButtonWithTitle:@"Yes!" handler:^{
        [self presentTakePhotoActionSheet];
    }];
    [alert addButtonWithTitle:NSLocalizedString(@"Cancel", @"") handler:NULL];
    [alert show];
}

-(void)presentTakePhotoActionSheet {
    UIAlertView *alert = [UIAlertView alertViewWithTitle:NSLocalizedString(@"Take Photo", @"Get photo alertview title")];
    [alert addButtonWithTitle:NSLocalizedString(@"Use Last Photo In Library", @"Use last photo taken button title") handler:^{
        
    }];
    [alert addButtonWithTitle:NSLocalizedString(@"Photo Library", @"Photo library button title") handler:^{
        UIImagePickerController *controller = [self pickerControllerForLibrarySourceWithDelegate:self];
        [self presentViewController:controller animated:YES completion:NULL];
    }];
    NSArray *arr = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
    if ([arr count] > 0) {
        [alert addButtonWithTitle:NSLocalizedString(@"Take New Picture", @"Take new picture button title") handler:^{
            UIImagePickerController *controller = [self pickerControllerForCameraSourceWithDelegate:self];
            [self presentViewController:controller animated:YES completion:NULL];
        }];
    }
    [alert addButtonWithTitle:NSLocalizedString(@"Cancel", @"Cancel button title") handler:NULL];
    [alert show];
}

-(UIImagePickerController *)basePickerControllerWithDelegate:(id<UIImagePickerControllerDelegate, UINavigationControllerDelegate>)delegate {
    UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
    pickerController.delegate = delegate;
    pickerController.allowsEditing = YES;
    return pickerController;
}

-(UIImagePickerController *)pickerControllerForCameraSourceWithDelegate:(id<UIImagePickerControllerDelegate, UINavigationControllerDelegate>)delegate {
    UIImagePickerController *pickerController = [self basePickerControllerWithDelegate:delegate];
    pickerController.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
    return pickerController;
}

-(UIImagePickerController *)pickerControllerForLibrarySourceWithDelegate:(id<UIImagePickerControllerDelegate, UINavigationControllerDelegate>)delegate {
    UIImagePickerController *pickerController = [self basePickerControllerWithDelegate:delegate];
    pickerController.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:(UIImagePickerControllerSourceTypePhotoLibrary | UIImagePickerControllerSourceTypeSavedPhotosAlbum)];
    return pickerController;
}

-(void)setupInitialLayoutConstraints {
    NSDictionary *bindings = MXDictionaryOfVariableBindings(mainImageView, titleLabel);
    [self.view addConstraintWithVisualFormat:@"H:|-20-[mainImageView(100)]-[titleLabel]-|" bindings:bindings];
    [self.view addConstraintWithVisualFormat:@"V:|-20-[mainImageView(100)]" bindings:bindings];
    [self.view addConstraintWithVisualFormat:@"V:|-20-[titleLabel]" bindings:bindings];
}

-(void)setupPostButtonAddConstraints {
    NSDictionary *bindings = MXDictionaryOfVariableBindings(viewRecipeButton, iMadeThisButton);
    
    [self.view addConstraintWithVisualFormat:@"V:[viewRecipeButton(44)]" bindings:bindings];
    [self.view addConstraintWithVisualFormat:@"H:|-30-[viewRecipeButton]-30-|" bindings:bindings];
    [self.view addConstraintWithVisualFormat:@"V:[viewRecipeButton]-10-[iMadeThisButton(44)]" bindings:bindings];
    [self.view addConstraintWithVisualFormat:@"H:|-30-[iMadeThisButton]-30-|" bindings:bindings];
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
        [self addIMadeThisButton];
        [self setupPostButtonAddConstraints];
    }];
    [self addMainImageView];
    [self addRecipeTitleLabel];
    [self setupInitialLayoutConstraints];
}

-(void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

#pragma mark UIImagePickerController Delegate Methods

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

@end
