//
//  FileManager.h
//  FFTVisuals
//
//  Created by AntonioStilo on 28/08/16.
//  Copyright © 2016 AntonioStilo. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kMetaDataTitle @"title"
#define kMetaDataDate @"date"
#define kMetaDataAUDIOFile @"auFile"
#define kMetaDataMETAFile @"metaFile"
#define kMetaDataMIDIFile @"midiFile"

@interface FileManager : NSObject

@property (nonatomic,strong) NSArray *audioFiles;
@property (nonatomic,strong) NSArray *metaFiles;
@property (nonatomic,strong) NSArray *midiFiles;

+ (instancetype)sharedInstance;
-(NSDictionary*)prepareAudioFile;
-(BOOL)deleteAudioFile:(NSDictionary*)dictionary;
-(void)refershFilesList;

@end
