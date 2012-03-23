//
//  Trait.h
//  Mobile Mentch
//
//  Created by Ariel Chait on 3/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Trait : NSObject {
    NSString *UniqueID;
    NSString *name;
    NSString *description;
    NSString *customDescription;
}

@property(nonatomic, copy) NSString *UniqueID, *name, *description, *customDescription;

+(id)traitWithID:(NSString *)UniqueID name:(NSString *)name description:(NSString *)description customDescription:(NSString *)customDescription;

-(Boolean) create:(Trait *)trait;
-(Boolean) editId:(id)traitId withTrait:(Trait *)newTrait;
-(Boolean) deleteId:(id)traitId;


@end
