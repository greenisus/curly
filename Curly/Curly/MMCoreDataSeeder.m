//
//  MMCoreDataSeeder.m
//  Curly
//
//  Created by Mike Mayo on 10/5/13.
//  Copyright (c) 2013 Mike Mayo. All rights reserved.
//

#import "MMCoreDataSeeder.h"

@implementation MMCoreDataSeeder

+ (NSManagedObjectContext *)managedObjectContext {
    return [MMAppDelegate context];
}

+ (void)seedMethod:(NSString *)name {

    NSEntityDescription *entity = [NSEntityDescription entityForName:@"MMHTTPMethod" inManagedObjectContext:self.managedObjectContext];
    MMHTTPMethod *method = [[MMHTTPMethod alloc] initWithEntity:entity insertIntoManagedObjectContext:self.managedObjectContext];
    method.name = name;
    method.userCreated = @(NO);
    method.created = [NSDate date];
    [self.managedObjectContext insertObject:method];
    
}

+ (void)seedUserAgent:(NSString *)grouping name:(NSString *)name agent:(NSString *)agent {

    NSEntityDescription *entity = [NSEntityDescription entityForName:@"MMUserAgent" inManagedObjectContext:self.managedObjectContext];
    MMUserAgent *userAgent = [[MMUserAgent alloc] initWithEntity:entity insertIntoManagedObjectContext:self.managedObjectContext];
    userAgent.grouping = grouping;
    userAgent.name = name;
    userAgent.agent = agent;
    userAgent.userCreated = @(NO);
    userAgent.created = [NSDate date];
    [self.managedObjectContext insertObject:userAgent];
    
}

+ (void)seed {
    
    [self seedMethod:@"GET"];
    [self seedMethod:@"POST"];
    [self seedMethod:@"PATCH"];
    [self seedMethod:@"PUT"];
    [self seedMethod:@"DELETE"];
    [self seedMethod:@"HEAD"];
//    [self seedMethod:@"OPTIONS"];
//    [self seedMethod:@"TRACE"];
//    [self seedMethod:@"CONNECT"];
    
//    [self seedUserAgent:@"" name:NSLocalizedString(@"No User Agent", nil) agent:@""];
    
    // clients
    [self seedUserAgent:NSLocalizedString(@"Clients", nil) name:@"Curly" agent:@"Curly 2.0"];
    
    // browsers
    [self seedUserAgent:NSLocalizedString(@"Browsers", nil) name:@"Safari" agent:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9) AppleWebKit/537.71 (KHTML, like Gecko) Version/7.0 Safari/537.71"];
    [self seedUserAgent:NSLocalizedString(@"Browsers", nil) name:@"Mobile Safari" agent:@"Mozilla/5.0 (iPhone; CPU iPhone OS 7_0_2 like Mac OS X) AppleWebKit/537.51.1 (KHTML, like Gecko) Version/7.0 Mobile/11A501 Safari/9537.53"];
    // todo: iPad and iPod Touch
    [self seedUserAgent:NSLocalizedString(@"Browsers", nil) name:@"Chrome" agent:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_0) AppleWebKit/537.31 (KHTML, like Gecko) Chrome/26.0.1410.65 Safari/537.31"];
    [self seedUserAgent:NSLocalizedString(@"Browsers", nil) name:@"Firefox" agent:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Firefox/24.0"];
    [self seedUserAgent:NSLocalizedString(@"Browsers", nil) name:@"Internet Explorer 10" agent:@"Mozilla/5.0 (compatible; MSIE 10.0; Windows NT 6.2; Trident/6.0)"];
    
    // bots
    [self seedUserAgent:NSLocalizedString(@"Bots", nil) name:@"Googlebot" agent:@"Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)"];
    [self seedUserAgent:NSLocalizedString(@"Bots", nil) name:@"Bingbot" agent:@"Mozilla/5.0 (compatible; bingbot/2.0; +http://www.bing.com/bingbot.htm)"];
    [self seedUserAgent:NSLocalizedString(@"Bots", nil) name:@"Yahoo! Slurp" agent:@"Mozilla/5.0 (compatible; Yahoo! Slurp; http://help.yahoo.com/help/us/ysearch/slurp)"];
    
    // clients
    
    NSError *error = nil;
    [self.managedObjectContext save:&error];
    
    if (error) {
        DLog(@"Error seeding database: %@", error);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:NSLocalizedString(@"There was a problem creating the initial data for Curly.", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"Dismiss", nil) otherButtonTitles:nil];
        [alert show];
    }
    
}

@end
