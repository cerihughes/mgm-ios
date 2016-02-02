//
//  MGMXmlParser.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 22/02/2014.
//  Copyright (c) 2014 Ceri Hughes. All rights reserved.
//

#import "MGMXmlParser.h"

@interface MGMXmlParser () <NSXMLParserDelegate>

@property (strong) NSMutableArray* dictionaryStack;
@property (strong) NSMutableString* textInProgress;
@property (strong) NSError* error;

@end

@implementation MGMXmlParser

+ (NSDictionary*) dictionaryForXMLData:(NSData*)data error:(NSError**)error
{
    MGMXmlParser* reader = [[MGMXmlParser alloc] init];
    NSDictionary* rootDictionary = [reader objectWithData:data];
    if (error)
    {
        *error = reader.error;
    }
    return rootDictionary;
}

- (id) init
{
    if (self = [super init])
    {
        _dictionaryStack = [[NSMutableArray alloc] init];
        _textInProgress = [[NSMutableString alloc] init];
    }
    return self;
}

- (NSDictionary*) objectWithData:(NSData*)data
{
    // Initialize the stack with a fresh dictionary
    [self.dictionaryStack addObject:[NSMutableDictionary dictionary]];

    // Parse the XML
    NSXMLParser* parser = [[NSXMLParser alloc] initWithData:data];
    parser.delegate = self;
    BOOL success = [parser parse];

    // Return the stack's root dictionary on success
    if (success)
    {
        NSDictionary *resultDict = [self.dictionaryStack objectAtIndex:0];
        return resultDict;
    }

    return nil;
}

#pragma mark -
#pragma mark NSXMLParserDelegate

- (void) parser:(NSXMLParser*)parser didStartElement:(NSString*)elementName namespaceURI:(NSString*)namespaceURI qualifiedName:(NSString*)qName attributes:(NSDictionary*)attributeDict
{
    // Get the dictionary for the current level in the stack
    NSMutableDictionary *parentDict = [self.dictionaryStack lastObject];

    // Create the child dictionary for the new element, and initilaize it with the attributes
    NSMutableDictionary *childDict = [NSMutableDictionary dictionary];
    [childDict addEntriesFromDictionary:attributeDict];

    // If there's already an item for this key, it means we need to create an array
    id existingValue = [parentDict objectForKey:elementName];
    if (existingValue)
    {
        NSMutableArray *array = nil;
        if ([existingValue isKindOfClass:[NSMutableArray class]])
        {
            // The array exists, so use it
            array = (NSMutableArray *) existingValue;
        }
        else
        {
            // Create an array if it doesn't exist
            array = [NSMutableArray array];
            [array addObject:existingValue];

            // Replace the child dictionary with an array of children dictionaries
            [parentDict setObject:array forKey:elementName];
        }

        // Add the new child dictionary to the array
        [array addObject:childDict];
    }
    else
    {
        // No existing value, so update the dictionary
        [parentDict setObject:childDict forKey:elementName];
    }

    // Update the stack
    [self.dictionaryStack addObject:childDict];
}

- (void) parser:(NSXMLParser*)parser didEndElement:(NSString*)elementName namespaceURI:(NSString*)namespaceURI qualifiedName:(NSString*)qName
{
    // Update the parent dict with text info
    NSMutableDictionary *dictInProgress = [self.dictionaryStack lastObject];

    // Set the text property
    if ([self.textInProgress length] > 0)
    {
        [dictInProgress setObject:self.textInProgress forKey:MGM_XMLReader_TextNodeKey];

        // Reset the text
        self.textInProgress = [[NSMutableString alloc] init];
    }

    // Pop the current dict
    [self.dictionaryStack removeLastObject];
}

- (void) parser:(NSXMLParser*)parser foundCharacters:(NSString*)string
{
    // Build the text value
    [self.textInProgress appendString:string];
}

- (void) parser:(NSXMLParser*)parser parseErrorOccurred:(NSError*)parseError
{
    // Set the error pointer to the parser's error object
    self.error = parseError;
}

@end