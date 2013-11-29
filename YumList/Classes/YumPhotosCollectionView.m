#import "YumPhotosCollectionView.h"
#import "NSFetchedResultsControllerFactory.h"
#import "YumItem.h"
#import "YumPhoto.h"
#import "YumPhotoCollectionCell.h"

@implementation YumPhotosCollectionView {
    NSFetchedResultsController *fetchController;
    NSMutableDictionary *sectionChanges;
    NSMutableDictionary *rowChanges;
}

static NSString *CellIdentifier = @"PhotoCell";

-(id)initWithYumItem:(YumItem *)item {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    self = [super initWithFrame:CGRectZero collectionViewLayout:layout];
    if (self) {
        self.item = item;
        [self registerClass:[YumPhotoCollectionCell class] forCellWithReuseIdentifier:CellIdentifier];
        self.delegate = self;
        self.dataSource = self;
        [self setupFetchController];
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
    [self reloadData];
}


#pragma mark UICollectionView DataSource Methods

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger numberOfRows = [[[fetchController sections] objectAtIndex:section] numberOfObjects];
    return numberOfRows;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    NSInteger numberOfSections = [[fetchController sections] count];
    return numberOfSections;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YumPhotoCollectionCell *cell = (YumPhotoCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    YumPhoto *photo = [fetchController objectAtIndexPath:indexPath];
    cell.photo = photo;
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(130, 130);
}

#pragma mark NSFetchedResultsController Delegate Methods

-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    
}

-(void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    
}

-(void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
}

@end
