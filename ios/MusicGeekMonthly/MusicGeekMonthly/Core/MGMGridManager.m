
#import "MGMGridManager.h"

@interface MGMGridManager ()

@property NSUInteger rows;
@property NSUInteger columns;

@end

@implementation MGMGridManager

+ (NSArray*) rectsForRowSize:(NSUInteger)rowSize defaultRectSize:(CGFloat)defaultRectSize count:(NSUInteger)count
{
    NSMutableArray* array = [NSMutableArray arrayWithCapacity:count];
    [self populateArray:array withRectsForRowSize:rowSize defaultRectSize:defaultRectSize count:count xOffset:0.0f yOffset:0.0f];
    return [array copy];
}

+ (CGFloat) populateArray:(NSMutableArray*)array withRectsForRowSize:(NSUInteger)rowSize defaultRectSize:(CGFloat)defaultRectSize count:(NSUInteger)count xOffset:(CGFloat)xOffset yOffset:(CGFloat)yOffset
{
    if (count >= 2 * rowSize)
    {
        CGFloat nextY = [self populateArray:array withRectsForRowSize:rowSize defaultRectSize:defaultRectSize count:count - rowSize xOffset:xOffset yOffset:yOffset];
        return [self populateArray:array withRectsForRowSize:rowSize defaultRectSize:defaultRectSize count:rowSize xOffset:xOffset yOffset:nextY];
    }
    else if (count > rowSize)
    {
        if (count == (2 * rowSize) - 3)
        {
            CGFloat rectSize = defaultRectSize * 2.0f;
            CGRect rect = CGRectMake(xOffset, yOffset, rectSize, rectSize);
            [array addObject:[NSValue valueWithCGRect:rect]];

            CGFloat nextY = [self populateArray:array withRectsForRowSize:rowSize - 2 defaultRectSize:defaultRectSize count:rowSize - 2 xOffset:xOffset + (2.0 * defaultRectSize) yOffset:yOffset];
            return [self populateArray:array withRectsForRowSize:rowSize - 2 defaultRectSize:defaultRectSize count:rowSize - 2 xOffset:xOffset + (2.0 * defaultRectSize) yOffset:nextY];
        }
        else
        {
            NSUInteger row1Count;
            NSUInteger row2Count;
            if (count % 2 == 1)
            {
                row1Count = (count - 1) / 2;
                row2Count = count - row1Count;
            }
            else
            {
                row1Count = row2Count = count / 2;
            }
            CGFloat nextY = [self populateArray:array withRectsForRowSize:rowSize defaultRectSize:defaultRectSize count:row1Count xOffset:xOffset yOffset:yOffset];
            return [self populateArray:array withRectsForRowSize:rowSize defaultRectSize:defaultRectSize count:row2Count xOffset:xOffset yOffset:nextY];
        }
    }
    else if (count == rowSize)
    {
        for (NSInteger i = 0; i < count; i++)
        {
            CGFloat x = defaultRectSize * (CGFloat)i;
            CGRect rect = CGRectMake(x + xOffset, yOffset, defaultRectSize, defaultRectSize);
            [array addObject:[NSValue valueWithCGRect:rect]];
        }
        return yOffset + defaultRectSize;
    }
    else
    {
        CGFloat rectSize = defaultRectSize * rowSize / count;
        for (NSInteger i = 0; i < count; i++)
        {
            CGFloat x = rectSize * (CGFloat)i;
            CGRect rect = CGRectMake(x + xOffset, yOffset, rectSize, rectSize);
            [array addObject:[NSValue valueWithCGRect:rect]];
        }
        return yOffset + rectSize;
    }
}

@end
