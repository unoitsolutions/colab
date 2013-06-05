//
//  BCREvent.h
//  BusinessCardReader
//
//  Created by Pinuno Fuentes on 4/25/13.
//  Copyright (c) 2013 Pinuno Fuentes. All rights reserved.
//

#import "DBEvent.h"

@interface BCREvent : DBEvent

- (id)initWithDBEvent:(DBEvent *)_event;

- (NSMutableArray *)topicOptionList;
- (NSMutableArray *)followupOptionList;

@end
