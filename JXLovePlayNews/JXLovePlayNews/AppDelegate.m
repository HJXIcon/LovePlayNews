//
//  AppDelegate.m
//  JXLovePlayNews
//
//  Created by mac on 17/7/25.
//  Copyright © 2017年 JXIcon. All rights reserved.
//

#import "AppDelegate.h"
#import "LPTabBarController.h"
#import "LPADLaunchController.h"
#import <JPFPSStatus.h>
#import <CocoaLumberjack/CocoaLumberjack.h>
#import <CocoaLumberjack/DDTTYLogger.h>

//!!DDLog 必须配置打印级别
#ifdef DEBUG
static const DDLogLevel ddLogLevel = DDLogLevelVerbose;
#else
static const DDLogLevel ddLogLevel = DDLogLevelWarning;
#endif


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self addMainWindow];
    
    [self addADLaunchController];
    
    
#if defined(DEBUG)||defined(_DEBUG)
    [[JPFPSStatus sharedInstance] open];
    
#endif
    
    
    /**！
     1.@DDLog（整个框架的基础）
     2.@DDASLLogger（发送日志语句到苹果的日志系统，以便它们显示在Console.app上）
     3.@DDTTYLoyger（发送日志语句到Xcode控制台，如果可用）
     4.@DDFIleLoger（把日志语句发送至文件）
     */
    
    
    //开启使用 XcodeColors
    setenv("XcodeColors", "YES", 0);
    
    //检测
    char *xcode_colors = getenv("XcodeColors");
    if (xcode_colors && (strcmp(xcode_colors, "YES") == 0))
    {
        // XcodeColors is installed and enabled!
        NSLog(@"XcodeColors is installed and enabled");
    }
    //开启DDLog 颜色
    [[DDTTYLogger sharedInstance] setColorsEnabled:YES];
    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor blueColor] backgroundColor:nil forFlag:DDLogFlagVerbose];
    
    //配置DDLog
    [DDLog addLogger:[DDTTYLogger sharedInstance]]; // TTY = Xcode console
    [DDLog addLogger:[DDASLLogger sharedInstance]]; // ASL = Apple System Logs
    
    DDFileLogger *fileLogger = [[DDFileLogger alloc] init]; // File Logger
    fileLogger.rollingFrequency = 60 * 60 * 24; // 24 hour rolling
    fileLogger.logFileManager.maximumNumberOfLogFiles = 7;
    [DDLog addLogger:fileLogger];
    
    //针对单个文件配置DDLog打印级别，尚未测试
    //    [DDLog setLevel:DDLogLevelAll forClass:nil];
    
    NSLog(@"NSLog");
    DDLogVerbose(@"Verbose");
    DDLogDebug(@"Debug");
    DDLogInfo(@"Info");
    DDLogWarn(@"Warn");
    DDLogError(@"Error");
    
    DDLogError(NSHomeDirectory());
    
    
    
    return YES;
}


- (void)addADLaunchController
{
    UIViewController *rootViewController = self.window.rootViewController;
    LPADLaunchController *launchController = [[LPADLaunchController alloc]init];
    [rootViewController addChildViewController:launchController];
    launchController.view.frame = rootViewController.view.frame;
    [rootViewController.view addSubview:launchController.view];
}

- (void)addMainWindow
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [[LPTabBarController alloc]init];
    [self.window makeKeyAndVisible];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
