//
//  Trait.m
//  Mobile Mentch
//
//  Created by Ariel Chait on 3/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Trait.h"

@implementation Trait

@synthesize UniqueID, name, description, customDescription;

+(id)traitWithID:(NSString *)UniqueID name:(NSString *)name description:(NSString *)description customDescription:(NSString *)customDescription{
    
    Trait *newTrait = [[self alloc] init];
    newTrait.UniqueID = UniqueID;
    newTrait.name = name;
    newTrait.description = description;
    newTrait.customDescription = customDescription;
    return newTrait;
    
}

-(Boolean) create:(Trait *)trait{
    
    return TRUE;
}

-(Boolean) editId:(id)traitId withTrait:(Trait *)newTrait{
 
    return TRUE;
}

-(Boolean) deleteId:(id)traitId{
    
    return TRUE;
}

@end
