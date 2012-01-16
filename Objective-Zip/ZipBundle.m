//
//  ZipBundle.m
//  AppilityKids
//
//  Created by Dirk Theisen on 12.01.12.
//  Copyright (c) 2012 Objectpark Software. All rights reserved.
//

#import "ZipBundle.h"

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
 
- (id)initWithPath: (NSString*) bundlePath {
    
    BOOL isDirectory = NO;
    BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath: bundlePath isDirectory: &isDirectory];
    if (exists && ! isDirectory) {
        // expect zip file
        self.zipFile = [[[ZipFile alloc] initWithFilePath: bundlePath mode: ZipFileModeUnzip] autorelease];
        return self;
    }
        
    // otherwise, default behaviour:
    [self autorelease];
    return (id)[[NSBundle alloc] initWithPath: bundlePath];
}

- (NSData*) dataWithContentsOfPath: (NSString*) absoluteOrRelativePath {
    if ([self.zipFile locateFileInZip: absoluteOrRelativePath]) {
        ZipReadStream* readStream = [self.zipFile readCurrentFileInZip];
        return [readStream data];
    }
    return nil;
}

- (NSString *)pathForResource:(NSString *)name ofType:(NSString *)ext inDirectory:(NSString *)directory forLocalization:(NSString *)localizationName {
    NSString* subpath = self.zipFile.path.lastPathComponent;
    if (directory.length) {
        subpath = [subpath stringByAppendingPathComponent: directory];
    }
    NSString* localization = localizationName.length ? [NSString stringWithFormat: @"/%@.lproj", localizationName] : @"";
    NSString* filename = ext.length ? [name stringByAppendingPathExtension: ext] : name;
    NSString* pathInZip = [NSString stringWithFormat: @"%@%@/%@", subpath, localization, filename];
    return [self.zipFile locateFileInZip: pathInZip] ? pathInZip : nil;
}

- (NSString *)pathForResource:(NSString *)name ofType:(NSString *)ext {
    NSString* result = [self pathForResource: name ofType: ext inDirectory: nil forLocalization: nil];
    if (! result) {
        result = [self pathForResource: name ofType: ext inDirectory: nil forLocalization: @"en"];
    }
    return result;
}



@end

@implementation NSBundle (ZipBundleExtensions)


- (NSData*) dataWithContentsOfPath: (NSString*) absoluteOrRelativePath {
    return [NSData dataWithContentsOfMappedFile: absoluteOrRelativePath];
}


@end
