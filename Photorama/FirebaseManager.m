//
//  FirebaseManager.m
//  MeetGeek
//
//  Created by Flatiron School on 10/28/16.
//  Copyright © 2016 Julianne Goyena. All rights reserved.
//

#import "FirebaseManager.h"
#import "EventRequest.h"
#import "Constants.h"
@import FirebaseDatabase;

@interface FirebaseManager ()
@property (strong, nonatomic) FIRDatabaseReference *ref;

@end

@implementation FirebaseManager

+ (id)sharedManager {
    
    static FirebaseManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc]init];
    });
    return sharedManager;
    
}

- (instancetype) init {
    self = [super init];
    if (self) {
        self.requests = [NSMutableArray new];
        self.ref = [[[FIRDatabase database] reference] child:@"requests"];
        [self setup];
    }
    return self;
}

- (void) postEventRequest: (EventRequest *)eventRequest {
    
    NSNumber *eventId = @(eventRequest.event.eventId);
    NSString *eventName = eventRequest.event.name;
    NSMutableDictionary *requestDict = [NSMutableDictionary dictionaryWithDictionary:@{kEventId: eventId, kEventName: eventName, kUserName: eventRequest.name, kUserAge: eventRequest.age, kUserSex: eventRequest.sex, kUserComment: eventRequest.note}];
    
    FIRDatabaseReference *requestEventReference = [self.ref childByAutoId];
    [requestEventReference setValue: requestDict];
}

- (void) setup {
    [self.ref observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot *_Nonnull snapshot) {
        NSLog(@"%@", snapshot);
        EventRequest *request = [self createEventRequest: snapshot.value];
        [self.requests addObject:request];
        if (self.delegate && [self.delegate respondsToSelector:@selector(reloadRequests)]) {
            [self.delegate reloadRequests];
        }
    }];
    
}

- (EventRequest*)createEventRequest: (NSDictionary*)dictionary {
    
    Event *event = [[Event alloc] init];
    event.name = dictionary[kEventName];
    
    NSString *userName = dictionary[kUserName];
    NSString *userAge = dictionary[kUserAge];
    NSString *userSex = dictionary[kUserSex];
    NSString *userComment = dictionary[kUserComment];
    
    EventRequest *request = [[EventRequest alloc] initWithEvent:event name:userName age:userAge sex:userSex note:userComment];
    
    return request;
}

@end
