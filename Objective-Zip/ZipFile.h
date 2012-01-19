//
//  ZipFile.h
//  Objective-Zip v. 0.7.2
//
//  Created by Gianluca Bertani on 25/12/09.
//  Copyright 2009-10 Flying Dolphin Studio. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without 
//  modification, are permitted provided that the following conditions 
//  are met:
//
//  * Redistributions of source code must retain the above copyright notice, 
//    this list of conditions and the following disclaimer.
//  * Redistributions in binary form must reproduce the above copyright notice, 
//    this list of conditions and the following disclaimer in the documentation 
//    and/or other materials provided with the distribution.
//  * Neither the name of Gianluca Bertani nor the names of its contributors 
//    may be used to endorse or promote products derived from this software 
//    without specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
//  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
//  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
//  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE 
//  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
//  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
//  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
//  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
//  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
//  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
//  POSSIBILITY OF SUCH DAMAGE.
//

#import <Foundation/Foundation.h>

#include "zip.h"
#include "unzip.h"
#import "ZipWriteStream.h"
#import "ZipReadStream.h"
#import "FileInZipInfo.h"

@interface ZipFile : NSObject {
	NSString *_filePath;
	ZipFileMode _mode;

@private
	zipFile _zipFile;
	unzFile _unzFile;
}

- (id) initWithFilePath:(NSString *)filePath mode:(ZipFileMode)mode;

- (ZipWriteStream *) writeFileIntoZipWithName:(NSString *)fileNameInZip compressionLevel:(ZipCompressionLevel)compressionLevel;
- (ZipWriteStream *) writeFileIntoZipWithName:(NSString *)fileNameInZip fileDate:(NSDate *)fileDate compressionLevel:(ZipCompressionLevel)compressionLevel;
- (ZipWriteStream *) writeFileIntoZipWithName:(NSString *)fileNameInZip fileDate:(NSDate *)fileDate compressionLevel:(ZipCompressionLevel)compressionLevel password:(NSString *)password crc32:(NSUInteger)crc32;

- (void) copyFileFromFilePath: (NSString*) filePath
             intoZipDirectory: (NSString*) pathInZip 
             compressionLevel: (ZipCompressionLevel)compressionLevel;

- (NSString*) path;

- (NSUInteger) fileCount;
- (NSArray *) allFileInZipInfos;

- (void) goToFirstFileInZip;
- (BOOL) goToNextFileInZip;
- (BOOL) locateFileInZip:(NSString *)fileNameInZip;

- (FileInZipInfo *) getCurrentFileInZipInfo;

- (ZipReadStream *) readCurrentFileInZip;
- (ZipReadStream *) readCurrentFileInZipWithPassword:(NSString *)password;

- (void) close;

@end
