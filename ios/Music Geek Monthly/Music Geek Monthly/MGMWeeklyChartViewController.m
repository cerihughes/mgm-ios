
#import "MGMWeeklyChartViewController.h"
#import "MGMLastFmDao.h"
#import "MGMLastFmGroupAlbum.h"

@interface MGMWeeklyChartViewController()

@property (strong) NSArray* albums;

@end

@implementation MGMWeeklyChartViewController

- (id) init
{
    if (self = [super init])
    {
    }
    return self;
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    MGMLastFmDao* dao = [[MGMLastFmDao alloc] init]; // TODO: Get from core.

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
    {
        // Search in a background thread...
        self.albums = [dao topWeeklyAlbums];
        for (MGMLastFmGroupAlbum* album in self.albums)
        {
            [dao updateAlbumInfo:album];
        }
        
        dispatch_async( dispatch_get_main_queue(), ^
        {
            // ... but update the UI in the main thread...
        });
    });

}


@end
