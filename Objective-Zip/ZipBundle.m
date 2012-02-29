//
//  ZipBundle.m
//  AppilityKids
//
//  Created by Dirk Theisen on 12.01.12.
//  Copyright (c) 2012 Objectpark Software. All rights reserved.
//

#import "ZipBundle.h"
#import "ZipWriteStream.h"

@implementation ZipBundle

@synthesize zipFile;


+ (id) bundleWithPath: (NSString*) bundlePath {
    BOOL isDirectory = NO;
    BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath: bundlePath isDirectory: &isDirectory];
    if (exists) {
        if (isDirectory) {
            return [super bundleWithPath: bundlePath];
        } else {
            // expect zip file
            return [[[self alloc] initWithPath: bundlePath] autorelease];
        }
    }
    return nil;
}

- (NSString*) bundlePath {
    return self.zipFile.path;
}
 
- (id)initWithPath: (NSString*) bundlePath mode: (ZipFileMode) mode {
    
    BOOL isDirectory = NO;
    BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath: bundlePath isDirectory: &isDirectory];
    if (exists && ! isDirectory) {
        // expect zip file
        self.zipFile = [[[ZipFile alloc] initWithFilePath: bundlePath mode: mode] autorelease];
        return self;
    }
        
    // otherwise, default behaviour:
    [self autorelease];
    return (id)[[NSBundle alloc] initWithPath: bundlePath];
}

- (id)initWithPath: (NSString*) bundlePath {
    return [self initWithPath: bundlePath mode: ZipFileModeUnzip];
}

- (NSData*) dataWithContentsOfPath: (NSString*) absoluteOrRelativePath {
    
    if (absoluteOrRelativePath.length) {
        if ([self.zipFile locateFileInZip: absoluteOrRelativePath]) {
            ZipReadStream* readStream = [self.zipFile readCurrentFileInZip];
            return [readStream data];
        }
    }
    return nil;
}


- (NSString *)pathForResource:(NSString *)name ofType:(NSString *)ext inDirectory:(NSString *)directory forLocalization:(NSString *)localizationName {
    
    if (! directory.length) directory = @"/";
    
//    NSString* subpath = self.zipFile.path.lastPathComponent;
//    if (directory.length) {
//        subpath = [subpath stringByAppendingPathComponent: directory];
//    }
    NSString* localizationComponent = localizationName ? [localizationName stringByAppendingPathExtension: @"lproj"] : @"";
    NSString* filename = ext.length ? [name stringByAppendingPathExtension: ext] : name;
    
    NSString* pathInZip = [directory stringByAppendingPathComponent: [localizationComponent stringByAppendingPathComponent: filename]];
    NSLog(@"Searching for file '%@' in %@", pathInZip, self);
    BOOL found = [self.zipFile locateFileInZip: pathInZip];
    if (found) {
        NSLog(@"Found file '%@'.", pathInZip);
    }
    return found ? pathInZip : nil;
}

- (NSString*) pathForResource: (NSString*) name ofType: (NSString*) ext inDirectory: (NSString*) directory {
    
    NSArray* langs = [NSLocale preferredLanguages];
    NSString *languageCode = [langs objectAtIndex: 0];
    NSString* result = [self pathForResource: name ofType: ext inDirectory: directory forLocalization: languageCode];
    
    if (! result) {
        static NSString* devLocale = nil;
        if (! devLocale) devLocale = [[[NSBundle mainBundle] developmentLocalization] retain];
        
        result = [self pathForResource: name ofType: ext inDirectory: directory forLocalization: devLocale];
        if (! result) {
            result = [self pathForResource: name ofType: ext inDirectory: directory forLocalization: nil];
        }
    }
    return result;
}

- (NSString*) pathForResource: (NSString*) name ofType: (NSString*) ext {
    return [self pathForResource: name ofType: ext inDirectory: nil];
}


@end

@implementation NSBundle (ZipBundleExtensions)


- (NSData*) dataWithContentsOfPath: (NSString*) absoluteOrRelativePath {
    
    if (! [absoluteOrRelativePath isAbsolutePath]) {
        absoluteOrRelativePath = [self.bundlePath stringByAppendingPathComponent: absoluteOrRelativePath];
    }
    
    return [NSData dataWithContentsOfMappedFile: absoluteOrRelativePath];
}


@end

