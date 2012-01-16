//
//  ZipBundle.h
//  AppilityKids
//
//  Created by Dirk Theisen on 12.01.12.
//  Copyright (c) 2012 Objectpark Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZipFile.h"

@interface ZipBundle : NSBundle

@property (retain, nonatomic) ZipFile* zipFile;

/*" all the -path... methods only return path names relative to the zip file root. In order to retrieve the data from files at those paths, use the -dataWithContentsOfPath: method. "*/

@end



@interface NSBundle (ZipBundleExtensions)

- (NSData*) dataWithContentsOfPath: (NSString*) pathInZip;



@end