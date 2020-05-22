//
//  ZQUploadParam.m
//  Client
//
//  Created by apple on 2020/5/20.
//  Copyright © 2020 apple. All rights reserved.
//

#import "ZQUploadParam.h"

@implementation ZQUploadParam
/**
 上传格式
 if ([type isEqualToString:@"image"])
 {
     [formData appendPartWithFileData:data name:@"image" fileName:@"file.jpg" mimeType:@"image/jpeg"];
 }
 else if([type isEqualToString:@"video"])
 {
     [formData appendPartWithFileData:data name:@"file" fileName:@"testVideo.mp4" mimeType:@"application/octet-stream"];
 }
 else if([type isEqualToString:@"xls"]||[type isEqualToString:@"xlsx"])
 {
     [formData appendPartWithFileData:data name:@"file" fileName:[NSString stringWithFormat:@"file.%@",type] mimeType:@"application/octet-stream"];
 }
 else if([type isEqualToString:@"doc"]||[type isEqualToString:@"docx"])
 {
     [formData appendPartWithFileData:data name:@"file" fileName:[NSString stringWithFormat:@"file.%@",type] mimeType:@"application/msword"];
 }
 else if([type isEqualToString:@"ppt"]||[type isEqualToString:@"pptx"])
 {
     [formData appendPartWithFileData:data name:@"file" fileName:[NSString stringWithFormat:@"file.%@",type] mimeType:@"application/vnd.ms-powerpoint"];
 }
 */
@end
