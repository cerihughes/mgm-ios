//
//  SCConversions.m
//  Spotify Challenges
//
//  Created by Ceri Hughes on 29/03/2014.
//  Copyright (c) 2014 Ceri Hughes. All rights reserved.
//

#import "SCConversions.h"

typedef NS_ENUM(NSUInteger, SCConversionsUnit) {
    SCConversionsUnitUnknown,
    SCConversionsUnitThou,
    SCConversionsUnitInch,
    SCConversionsUnitFoot,
    SCConversionsUnitYard,
    SCConversionsUnitChain,
    SCConversionsUnitFurlong,
    SCConversionsUnitMile,
    SCConversionsUnitLeague
};

@implementation SCConversions

- (double) convert:(NSString*)conversionString
{
    NSArray* components = [conversionString componentsSeparatedByString: @" "];
    if (components.count == 4)
    {
        NSString* inputString = components[0];
        NSString* inputUnitString = components[1];
        NSString* outputUnitString = components[3];

        NSNumberFormatter* inputFormatter = [[NSNumberFormatter alloc] init];
        [inputFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        double inputDouble = [[inputFormatter numberFromString:inputString] doubleValue];
        SCConversionsUnit inputUnit = [self unitForUnitString:inputUnitString];
        SCConversionsUnit outputUnit = [self unitForUnitString:outputUnitString];
        double inputMultiple = [self multipleForInputUnit:inputUnit outputUnit:outputUnit];
        return inputDouble * inputMultiple;
    }
    return -1;
}

- (SCConversionsUnit) unitForUnitString:(NSString*)unitString
{
    if ([unitString isEqualToString:@"th"] || [unitString isEqualToString:@"thou"])
    {
        return SCConversionsUnitThou;
    }
    if ([unitString isEqualToString:@"in"] || [unitString isEqualToString:@"inch"])
    {
        return SCConversionsUnitInch;
    }
    if ([unitString isEqualToString:@"ft"] || [unitString isEqualToString:@"foot"])
    {
        return SCConversionsUnitFoot;
    }
    if ([unitString isEqualToString:@"yd"] || [unitString isEqualToString:@"yard"])
    {
        return SCConversionsUnitYard;
    }
    if ([unitString isEqualToString:@"ch"] || [unitString isEqualToString:@"chain"])
    {
        return SCConversionsUnitChain;
    }
    if ([unitString isEqualToString:@"fur"] || [unitString isEqualToString:@"furlong"])
    {
        return SCConversionsUnitFurlong;
    }
    if ([unitString isEqualToString:@"mi"] || [unitString isEqualToString:@"mile"])
    {
        return SCConversionsUnitMile;
    }
    if ([unitString isEqualToString:@"lea"] || [unitString isEqualToString:@"league"])
    {
        return SCConversionsUnitLeague;
    }
    return SCConversionsUnitUnknown;
}

- (double) multipleForInputUnit:(SCConversionsUnit)inputUnit outputUnit:(SCConversionsUnit)outputUnit
{
    static int _conversions[] = {0, 1000, 12, 3, 22, 10, 8, 3};

    double multiple = 1;

    for (int i = inputUnit; i < outputUnit; i++)
    {
        multiple /= _conversions[i];
    }

    for (int i = outputUnit; i < inputUnit; i++)
    {
        multiple *= _conversions[i];
    }

    return multiple;
}

@end
