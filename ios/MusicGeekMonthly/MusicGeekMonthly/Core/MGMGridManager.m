
#import "MGMGridManager.h"

@interface MGMGridManager ()

@property NSUInteger rows;
@property NSUInteger columns;

@end

@implementation MGMGridManager
{
    BOOL** _grid;
}

+ (NSArray*) rectsForRows:(NSUInteger)rows columns:(NSUInteger)columns size:(CGFloat)size count:(NSUInteger)count
{
    NSMutableArray* array = [NSMutableArray arrayWithCapacity:count];
    MGMGridManager* mananger = [[MGMGridManager alloc] initWithRows:rows columns:columns];
    
    for (int i = 0; i < count; i++)
    {
        NSUInteger blockCount = (i == 0) ? 2 : 1;
        CGPoint location = [mananger nextEmptyLocationWithBlockCount:blockCount];
        CGFloat rectSize = size * blockCount;
        CGFloat rectX = size * location.x;
        CGFloat rectY = size * location.y;
        CGRect rect = CGRectMake(rectX, rectY, rectSize, rectSize);
        [array addObject:[NSValue valueWithCGRect:rect]];
    }

    return array;
}

- (id) initWithRows:(NSUInteger)rows columns:(NSUInteger)columns
{
    if (self = [super init])
    {
        self.rows = rows;
        self.columns = columns;

        _grid = (BOOL**) calloc(rows, sizeof(BOOL*));

        for (int i = 0; i < rows; i++)
        {
            _grid[i] = (BOOL*) calloc(columns, sizeof(BOOL));
        }
    }
    return self;
}

- (CGPoint) nextEmptyLocationWithBlockCount:(NSUInteger)blockCount
{
    CGPoint nextLocation;
    nextLocation.x = 0;
    nextLocation.y = 0;

    do
    {
        nextLocation = [self nextEmptyLocationFrom:nextLocation];
    }
    while ([self location:nextLocation canHoldBlockCount:blockCount] == NO);

    [self fillGridFromLocation:nextLocation withBlockCount:blockCount];
    
    return nextLocation;
}

- (CGPoint) nextEmptyLocationFrom:(CGPoint)location
{
    CGPoint nextLocation;
    nextLocation.x = NSNotFound;
    nextLocation.y = NSNotFound;

    NSUInteger x = location.x;
    NSUInteger y = location.y;
    while (y < self.columns)
    {
        while (x < self.rows)
        {
            if (_grid[x][y] == NO)
            {
                nextLocation.x = x;
                nextLocation.y = y;
                return nextLocation;
            }
            x++;
        }
        y++;
        x = 0;
    }

    return nextLocation;
}

- (BOOL) location:(CGPoint)location canHoldBlockCount:(NSUInteger)blockCount
{
    NSUInteger x = location.x;
    NSUInteger y = location.y;
    if (x + blockCount <= self.rows && y + blockCount <= self.columns)
    {
        NSUInteger maxX = x + blockCount;
        NSUInteger maxY = y + blockCount;
        while (x < maxX)
        {
            while (y < maxY)
            {
                if (_grid[x][y] == YES)
                {
                    return NO;
                }
                y++;
            }
            x++;
            y = location.y;
        }
        return YES;
    }
    return NO;
}

- (void) fillGridFromLocation:(CGPoint)location withBlockCount:(NSUInteger)blockCount
{
    NSUInteger x = location.x;
    NSUInteger y = location.y;
    NSUInteger maxX = x + blockCount;
    NSUInteger maxY = y + blockCount;
    while (x < maxX)
    {
        while (y < maxY)
        {
            _grid[x][y] = YES;
            y++;
        }
        x++;
        y = location.y;
    }
}

- (void) dealloc
{
	for(int i = 0; i < self.rows; i++)
    {
		free(_grid[i]);
    }
	free(_grid);}

@end
