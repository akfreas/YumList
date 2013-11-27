@class YumItem;

@interface YumPhotosCollectionView : UICollectionView <NSFetchedResultsControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

-(id)initWithYumItem:(YumItem *)item;

@property (strong, nonatomic) YumItem *item;

@end
