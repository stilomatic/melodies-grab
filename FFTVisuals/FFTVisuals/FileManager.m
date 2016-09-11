//
//  FileManager.m
//  FFTVisuals
//
//  Created by AntonioStilo on 28/08/16.
//  Copyright © 2016 AntonioStilo. All rights reserved.
//

#import "FileManager.h"

#define AUDIO @"/audioSample"
#define METADATA @"/metadata"
#define MIDI @"/midi"

@interface FileManager ()
-(NSString*)fileDirectory;
-(NSString*)newFileName;
-(void)increment;
@end

@implementation FileManager

+ (instancetype)sharedInstance
{
    static FileManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[FileManager alloc] init];
        [sharedInstance refershFilesList];
    });
    return sharedInstance;
}

-(void)refershFilesList
{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *directory = [self fileDirectory];
    
    NSError *error;
    
    if ([fm fileExistsAtPath:[directory stringByAppendingString:AUDIO]] == NO) {
        [fm createDirectoryAtPath:[directory stringByAppendingString:AUDIO] withIntermediateDirectories:NO attributes:nil error:&error];
        
        if (error) {
            NSLog(@"[AUDIO Directory] %@", [error description]);
        }
    }
    
    if ([fm fileExistsAtPath:[directory stringByAppendingString:METADATA]] == NO) {
        [fm createDirectoryAtPath:[directory stringByAppendingString:METADATA] withIntermediateDirectories:NO attributes:nil error:&error];
        
        if (error) {
            NSLog(@"[METADATA Directory] %@", [error description]);
        }
    }
    
    if ([fm fileExistsAtPath:[directory stringByAppendingString:MIDI]] == NO) {
        [fm createDirectoryAtPath:[directory stringByAppendingString:MIDI] withIntermediateDirectories:NO attributes:nil error:&error];
        
        if (error) {
            NSLog(@"[MIDI Directory] %@", [error description]);
        }
    }

    self.audioFiles = [fm contentsOfDirectoryAtPath:[directory stringByAppendingString:AUDIO] error:nil];
    self.midiFiles = [fm contentsOfDirectoryAtPath:[directory stringByAppendingString:MIDI] error:nil];
    
    NSString *metadataDirectory = [directory stringByAppendingString:METADATA];
    NSArray *metas = [fm contentsOfDirectoryAtPath:metadataDirectory error:nil];
    NSMutableArray *dictionaries = [NSMutableArray new];
    for(NSString *name in metas){
        NSDictionary *tmpDict = [NSDictionary dictionaryWithContentsOfFile:[metadataDirectory stringByAppendingString:[NSString stringWithFormat:@"/%@",name]]];
        [dictionaries addObject:tmpDict];
    }
    
    self.metaFiles = [[dictionaries reverseObjectEnumerator] allObjects];
}

-(NSDictionary*)prepareAudioFile
{
    NSString *fileName = [self newFileName];
    NSString *directory = [self fileDirectory];
    
    NSString *filePath = [directory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@",AUDIO,[fileName stringByAppendingString:@".wav"]]];
    NSString *midifilePath = [directory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@",MIDI,[fileName stringByAppendingString:@".mid"]]];
    NSString *metadataFilePath = [directory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@",METADATA,[fileName stringByAppendingString:@".dic"]]];
    NSDictionary *outMetadata = @{kMetaDataTitle:[NSString stringWithFormat:@"Melody #%ld",[[NSUserDefaults standardUserDefaults] integerForKey:@"filesCount"]],
                        kMetaDataDate:[self formattedDate:fileName],
                        kMetaDataAUDIOFile:filePath,
                        kMetaDataMETAFile:metadataFilePath,
                        kMetaDataMIDIFile:midifilePath};
    
        [self increment];
    
    [outMetadata writeToFile:metadataFilePath atomically:YES];

    return  outMetadata;
}

-(BOOL)deleteAudioFile:(NSDictionary*)dictionary
{
    
    NSError *error = nil;
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL isAudioDeleted = [fm removeItemAtPath:[dictionary valueForKey:kMetaDataAUDIOFile] error:&error];
    BOOL isMetaDeleted = [fm removeItemAtPath:[dictionary valueForKey:kMetaDataMETAFile] error:&error];
    BOOL isMIDIDeleted = [fm removeItemAtPath:[dictionary valueForKey:kMetaDataMIDIFile] error:&error];
    
    if(error){
        NSLog(@"Error while deleting files %@",error.description);
    }
    
    return isAudioDeleted && isMetaDeleted && isMIDIDeleted;

}

-(NSString*)fileDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    return documentsDirectory;
}

-(NSString*)newFileName
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]];
    formatter.dateFormat = @"ddMMMyy_HHmmssSSS";
    return  [formatter stringFromDate:[NSDate date]];
}

-(NSString*)formattedDate:(NSString*)dateString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]];
    formatter.dateFormat = @"ddMMMyy_HHmmssSSS";
    NSDateFormatter *outformatter = [[NSDateFormatter alloc] init];
    [outformatter setLocale:[NSLocale currentLocale]];
    outformatter.timeStyle = NSDateFormatterMediumStyle;
    outformatter.dateFormat = @"dd MMM yy | hh:mm:ss a";
    NSDate *date = [formatter dateFromString:dateString];
    return  [outformatter stringFromDate:date];
}

-(void)increment
{
    NSInteger count = [[NSUserDefaults standardUserDefaults] integerForKey:@"filesCount"];
    count++;
    [[NSUserDefaults standardUserDefaults] setInteger:count forKey:@"filesCount"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
