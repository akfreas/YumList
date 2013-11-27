#import "YumPhotosCollectionView.h"
#import "NSFetchedResultsControllerFactory.h"
#import "YumItem.h"
#import "YumPhoto.h"
#import "YumPhotoCollectionCell.h"

@implementation YumPhotosCollectionView {
    NSFetchedResultsController *fetchController;
}

static NSString *CellIdentifier = @"PhotoCell";

-(id)initWithYumItem:(YumItem *)item {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.item = item;
        self.delegate = self;
        self.dataSource = self;
        [self setupFetchController];
        [self registerClass:[YumPhotoCollectionCell class] forCellWithReuseIdentifier:CellIdentifier];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


-(void)setupFetchController {
    fetchController = [NSFetchedResultsControllerFactory fetchControllerForYumPhotosAttachedToItem:self.item];
    fetchController.delegate = self;
    [fetchController performFetch];
}


#pragma mark UICollectionView DataSource Methods

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [[[fetchController sections] objectAtIndex:section] count];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [[fetchController sections] count];
}

-(YumPhotoCollectionCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YumPhotoCollectionCell *cell = (YumPhotoCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    YumPhoto *photo = [fetchController objectAtIndexPath:indexPath];
    cell.photo = photo;
    return cell;
}

@end
