//
//  TileGameAppDelegate.m
//  TileGame
//
//  Created by Ray Wenderlich on 5/18/10.
//  Copyright Ray Wenderlich 2010. All rights reserved.
//

#import "TileGameAppDelegate.h"
#import "cocos2d.h"
#import "HelloWorldScene.h"

@implementation TileGameAppDelegate

@synthesize window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    if ([launchOptions valueForKey:@"UIApplicationLaunchOptionsURLKey"])
    {
        // Open supplied file
        return [self application:application 
                         openURL:[launchOptions valueForKey:@"UIApplicationLaunchOptionsURLKey"] 
               sourceApplication:[launchOptions valueForKey:@"UIApplicationLaunchOptionsSourceApplicationKey"] 
                      annotation:nil];
    }
    if ([launchOptions valueForKey:@"UIApplicationLaunchOptionsSourceApplicationKey"]) {
        // Yes, we should open files from any application
        return YES;
    }
	// Init the window
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
	// cocos2d will inherit these values
	[window setUserInteractionEnabled:YES];	
	[window setMultipleTouchEnabled:YES];
	
	// Try to use CADisplayLink director
	// if it fails (SDK < 3.1) use the default director
	if( ! [CCDirector setDirectorType:CCDirectorTypeDisplayLink] )
		[CCDirector setDirectorType:CCDirectorTypeDefault];
	
	// Use RGBA_8888 buffers
	// Default is: RGB_565 buffers
	[[CCDirector sharedDirector] setPixelFormat:kPixelFormatRGBA8888];
	
	// Create a depth buffer of 16 bits
	// Enable it if you are going to use 3D transitions or 3d objects
//	[[CCDirector sharedDirector] setDepthBufferFormat:kDepthBuffer16];
	
	// Default texture format for PNG/BMP/TIFF/JPEG/GIF images
	// It can be RGBA8888, RGBA4444, RGB5_A1, RGB565
	// You can change anytime.
	[CCTexture2D setDefaultAlphaPixelFormat:kTexture2DPixelFormat_RGBA8888];
	
	// before creating any layer, set the landscape mode
	[[CCDirector sharedDirector] setDeviceOrientation:CCDeviceOrientationLandscapeLeft];
	[[CCDirector sharedDirector] setAnimationInterval:1.0/60];
	[[CCDirector sharedDirector] setDisplayFPS:YES];
	
	// create an openGL view inside a window
	[[CCDirector sharedDirector] attachInView:window];	
	[window makeKeyAndVisible];		
		
    // Default map name that's already included in bundle
	NSString *mapName = @"TileMap.tmx";
    if ([launchOptions valueForKey:@"OpenMap"]) {
        // we should open another file not the default
        mapName = [launchOptions valueForKey:@"OpenMap"];
    }
    // run the scene
    [[CCDirector sharedDirector] runWithScene: [HelloWorld sceneWithMap:mapName]];
    
    return YES; // everything went fine
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    // getting documents directory of our application
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *newFilePath = [documentsDirectory stringByAppendingPathComponent:[url lastPathComponent]];
    
    // copy map from Inbox directory, so we can access our tilesets
    // note that Apple says it's bad due to write limit of flash memory
    // if you want change the way cocos loads textures for tilemaps
    [[NSFileManager defaultManager] copyItemAtURL:url toURL:[NSURL fileURLWithPath:newFilePath] error:nil];
    
    if (!window) {
        // init our window and scene
        NSDictionary *dict = [NSDictionary dictionaryWithObject:newFilePath forKey:@"OpenMap"];
        [self application:application didFinishLaunchingWithOptions:dict];
    }
    else
    {
        // we are already running so just replace scene
        [[CCDirector sharedDirector] replaceScene: [HelloWorld sceneWithMap:newFilePath]];
    }
    
    return YES; // everything went smoothly
}

// start and stop animation when we are going out from or into background
-(void) applicationDidEnterBackground:(UIApplication*)application {
	[[CCDirector sharedDirector] stopAnimation];
}

-(void) applicationWillEnterForeground:(UIApplication*)application {
	[[CCDirector sharedDirector] startAnimation];
}

- (void)applicationWillResignActive:(UIApplication *)application {
	[[CCDirector sharedDirector] pause];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	[[CCDirector sharedDirector] resume];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
	[[CCTextureCache sharedTextureCache] removeUnusedTextures];
}

- (void)applicationWillTerminate:(UIApplication *)application {
	[[CCDirector sharedDirector] end];
}

- (void)applicationSignificantTimeChange:(UIApplication *)application {
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}

- (void)dealloc {
	[[CCDirector sharedDirector] release];
	[window release];
	[super dealloc];
}

@end
