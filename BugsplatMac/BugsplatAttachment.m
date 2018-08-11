//
//  BugsplatAttachment.m
//  BugsplatMac
//
//  Created by Geoff Raeder on 3/26/17.
//  Copyright © 2017 Bugsplat. All rights reserved.
//

#import "BugsplatAttachment.h"

@interface BugsplatAttachment ()

@property (nonatomic, strong) NSString *filename;
@property (nonatomic, strong) NSData *attachmentData;
@property (nonatomic, strong) NSString *contentType;

@end

@implementation BugsplatAttachment

- (instancetype)initWithFilename:(NSString *)filename attachmentData:(NSData *)attachmentData contentType:(NSString *)contentType
{
    if (self = [super init])
    {
        self.filename = filename;
        self.attachmentData = attachmentData;
        self.contentType = contentType;
    }
    
    return self;
}

@end
