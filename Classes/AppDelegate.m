//
//  AppDelegate.m
//  CigoFirst
//
//  Created by zjugis on 12-10-9.
//  Copyright (c) 2012年 cigo. All rights reserved.
//

#import "AppDelegate.h"

#import "MasterViewController.h"
#import "Utility.h"

#pragma mark Private Interface

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //Magical Record
    [MagicalRecord setupCoreDataStackWithStoreNamed:@"CigoFirst.sqlite"];
    
    // Side bar
    // Override point for customization after application launch.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
        UINavigationController *navigationController = [splitViewController.viewControllers lastObject];
        splitViewController.delegate = (id)navigationController.topViewController;
        
    } else {
        //UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
        //MasterViewController *controller = (MasterViewController *)navigationController.topViewController;
        //controller.managedObjectContext = self.managedObjectContext;
        UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
        navigationController.title = NSLocalizedString(@"main_view_title", nil);
        navigationController.navigationBar.tintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"top_line_bg.png"]];
        //navigationController.navigationBar.alpha = 1.0f;
        navigationController.navigationBar.translucent = YES;
        NSDictionary *titleTextDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                       [UIColor blackColor], UITextAttributeTextColor,
                                       [UIColor clearColor], UITextAttributeTextShadowColor,
                                       nil];
        navigationController.navigationBar.titleTextAttributes = titleTextDict;
    }
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    // [self saveContext];
    [[NSManagedObjectContext MR_defaultContext]MR_save];
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
