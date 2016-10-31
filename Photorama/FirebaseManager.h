//
//  FirebaseManager.h
//  MeetGeek
//
//  Created by Flatiron School on 10/28/16.
//  Copyright © 2016 Julianne Goyena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EventRequest.h"

@protocol FirebaseManagerDelegate <NSObject>
-(void)reloadRequests;
@end

@interface FirebaseManager : NSObject

@property (nonatomic, strong) NSMutableArray<EventRequest*> *requests;
@property (nonatomic, weak) id <FirebaseManagerDelegate> delegate;

+ (id)sharedManager;
- (void)postEventRequest: (EventRequest *)eventRequest;

@end
