//
//  AudioHandle.m
//  iComposer
//
//  Created by guangzhuiyuandev on 15/9/7.
//  Copyright (c) 2015年 lightcone. All rights reserved.
//

#import "AudioHandle.h"

@implementation AudioHandle
#pragma mark 切割音乐
///从startSeconds秒开始,截取长度为length的音频
+ (NSString *)cutMusic:(NSString *)recordFileName fromSeconds:(float)startSeconds timeLength:(float)length withIndex:(int)index{
    NSString *audioFullPath = [Constant getPathFromFileName:recordFileName withFileType:@".wav" withDir:@"record"];
    NSURL *audioURL = [NSURL fileURLWithPath:audioFullPath];
    AVURLAsset *URLAsset = [[AVURLAsset alloc] initWithURL:audioURL options:nil];
    int timeScale = URLAsset.duration.timescale;
    CMTime startTime = CMTimeMake(timeScale * startSeconds, timeScale);
    CMTime lengthTime = CMTimeMake(timeScale * length , timeScale);
    CMTimeRange timeRange = CMTimeRangeMake(startTime, lengthTime);
    
    NSDictionary *audioSetting = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [NSNumber numberWithFloat:44100.0],AVSampleRateKey,
                                  [NSNumber numberWithInt:1],AVNumberOfChannelsKey,
                                  [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,
                                  [NSNumber numberWithInt:kAudioFormatLinearPCM], AVFormatIDKey,
                                  [NSNumber numberWithBool:NO], AVLinearPCMIsFloatKey,
                                  [NSNumber numberWithBool:0], AVLinearPCMIsBigEndianKey,
                                  [NSNumber numberWithBool:NO], AVLinearPCMIsNonInterleaved,
                                  [NSData data], AVChannelLayoutKey, nil];
    
    AVAssetReader *assetReader = [AVAssetReader assetReaderWithAsset:URLAsset error:nil];
    assetReader.timeRange = timeRange;
    
    NSArray *tracks = [URLAsset tracksWithMediaType:AVMediaTypeAudio];
    
    AVAssetReaderAudioMixOutput *audioMixOutput = [AVAssetReaderAudioMixOutput
                                                   assetReaderAudioMixOutputWithAudioTracks:tracks
                                                   audioSettings:audioSetting];
    [assetReader canAddOutput:audioMixOutput];
    [assetReader addOutput:audioMixOutput];
    [assetReader startReading];

    
    NSString *dir = [[NSString alloc] initWithFormat:@"clip/%@",recordFileName];
    [Constant createDir:[NSTemporaryDirectory() stringByAppendingPathComponent:dir]];
    NSString *outPath = [Constant getPathFromFileName:[[NSString alloc]initWithFormat:@"%@_%d",recordFileName,index] withFileType:@".wav" withDir:dir];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:outPath] == YES) {
        [[NSFileManager defaultManager] removeItemAtPath:outPath error:nil];
    }
    
    NSURL *outURL = [NSURL fileURLWithPath:outPath];
    AVAssetWriter *assetWriter = [AVAssetWriter assetWriterWithURL:outURL
                                                          fileType:AVFileTypeWAVE
                                                             error:nil];
    
    AVAssetWriterInput *assetWriterInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeAudio
                                                                              outputSettings:audioSetting];
    assetWriterInput.expectsMediaDataInRealTime = NO;
    
    [assetWriter canAddInput:assetWriterInput];
    
    [assetWriter addInput:assetWriterInput];
    
    [assetWriter startWriting];
    
    [assetWriter startSessionAtSourceTime:kCMTimeZero];
    
    dispatch_queue_t queue = dispatch_queue_create("assetWriterQueue", NULL);
    
    BOOL __block isFinish = NO;
    
    [assetWriterInput requestMediaDataWhenReadyOnQueue:queue usingBlock:^{
        
        while (1)
        {
            if ([assetWriterInput isReadyForMoreMediaData]) {
                
                CMSampleBufferRef sampleBuffer = [audioMixOutput copyNextSampleBuffer];
                
                if (sampleBuffer) {
                    [assetWriterInput appendSampleBuffer:sampleBuffer];
                    CFRelease(sampleBuffer);
                } else {
                    [assetWriterInput markAsFinished];
                    isFinish = YES;
                    break;
                }
            }
        }
        
        [assetWriter finishWritingWithCompletionHandler:^{
        }];//finishWriting];
        
        NSLog(@"finish");
    }];
    while (isFinish == NO) {
        [NSThread sleepForTimeInterval:0.1f];
    }
    return outPath;
}

///从durationValue开始(seconds =  durationValue/timescale,durationValue必须整数),截取长度为durationLength的音频,不直接传秒的原因是duration.value才能准确切割方便变音变速的契合
+ (NSString *)cutMusic:(NSString *)recordFileName fromDurationValue:(long)durationValue withDurationLength:(long)durationLength withIndex:(int)index{
    NSString *audioFullPath = [Constant getPathFromFileName:recordFileName withFileType:@".wav" withDir:@"record"];
    NSURL *audioURL = [NSURL fileURLWithPath:audioFullPath];
    AVURLAsset *URLAsset = [[AVURLAsset alloc] initWithURL:audioURL options:nil];
    int timeScale = URLAsset.duration.timescale;
    CMTime startTime = CMTimeMake(durationValue, timeScale);
    CMTime lengthTime = CMTimeMake(durationLength , timeScale);
    CMTimeRange timeRange = CMTimeRangeMake(startTime, lengthTime);
    
    NSDictionary *audioSetting = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [NSNumber numberWithFloat:44100.0],AVSampleRateKey,
                                  [NSNumber numberWithInt:1],AVNumberOfChannelsKey,
                                  [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,
                                  [NSNumber numberWithInt:kAudioFormatLinearPCM], AVFormatIDKey,
                                  [NSNumber numberWithBool:NO], AVLinearPCMIsFloatKey,
                                  [NSNumber numberWithBool:0], AVLinearPCMIsBigEndianKey,
                                  [NSNumber numberWithBool:NO], AVLinearPCMIsNonInterleaved,
                                  [NSData data], AVChannelLayoutKey, nil];
    
    AVAssetReader *assetReader = [AVAssetReader assetReaderWithAsset:URLAsset error:nil];
    assetReader.timeRange = timeRange;
    
    NSArray *tracks = [URLAsset tracksWithMediaType:AVMediaTypeAudio];
    
    AVAssetReaderAudioMixOutput *audioMixOutput = [AVAssetReaderAudioMixOutput
                                                   assetReaderAudioMixOutputWithAudioTracks:tracks
                                                   audioSettings:audioSetting];
    [assetReader canAddOutput:audioMixOutput];
    [assetReader addOutput:audioMixOutput];
    [assetReader startReading];
    
    NSString *dir = [[NSString alloc] initWithFormat:@"clip/%@",recordFileName];
    [Constant createDir:[NSTemporaryDirectory() stringByAppendingPathComponent:dir]];
    NSString *outPath = [Constant getPathFromFileName:[[NSString alloc]initWithFormat:@"%@_%d",recordFileName,index] withFileType:@".wav" withDir:dir];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:outPath] == YES) {
        [[NSFileManager defaultManager] removeItemAtPath:outPath error:nil];
    }
    
    NSURL *outURL = [NSURL fileURLWithPath:outPath];
    AVAssetWriter *assetWriter = [AVAssetWriter assetWriterWithURL:outURL
                                                          fileType:AVFileTypeWAVE
                                                             error:nil];
    
    AVAssetWriterInput *assetWriterInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeAudio outputSettings:audioSetting];
    assetWriterInput.expectsMediaDataInRealTime = NO;
    
    [assetWriter canAddInput:assetWriterInput];
    [assetWriter addInput:assetWriterInput];
    
    [assetWriter startWriting];
    
    [assetWriter startSessionAtSourceTime:kCMTimeZero];
    
    dispatch_queue_t queue = dispatch_queue_create("assetWriterQueue", NULL);
    
    BOOL __block isFinish = NO;
    
    [assetWriterInput requestMediaDataWhenReadyOnQueue:queue usingBlock:^{
        
        while (1)
        {
            if ([assetWriterInput isReadyForMoreMediaData]) {
                
                CMSampleBufferRef sampleBuffer = [audioMixOutput copyNextSampleBuffer];
                
                if (sampleBuffer) {
                    [assetWriterInput appendSampleBuffer:sampleBuffer];
                    CFRelease(sampleBuffer);
                } else {
                    [assetWriterInput markAsFinished];
                    isFinish = YES;
                    break;
                }
            }
        }
        
        [assetWriter finishWritingWithCompletionHandler:^{
        }];
        
        NSLog(@"finish");
    }];
    
    while (isFinish == NO) {
        [NSThread sleepForTimeInterval:0.1f];
    }
    
    return outPath;
}

+ (NSArray *)cutMusic:(NSString *)recordFileName startSecondsArray:(double[])secondsArray withArrayLength:(int)arrayLength{
    NSString *audioFullPath = [Constant getPathFromFileName:recordFileName withFileType:@".wav" withDir:@"record"];
    NSURL *audioURL = [NSURL fileURLWithPath:audioFullPath];
    AVURLAsset *URLAsset = [[AVURLAsset alloc] initWithURL:audioURL options:nil];
    int timeScale = URLAsset.duration.timescale;
    
    NSDictionary *audioSetting = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [NSNumber numberWithFloat:44100.0],AVSampleRateKey,
                                  [NSNumber numberWithInt:1],AVNumberOfChannelsKey,
                                  [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,
                                  [NSNumber numberWithInt:kAudioFormatLinearPCM], AVFormatIDKey,
                                  [NSNumber numberWithBool:NO], AVLinearPCMIsFloatKey,
                                  [NSNumber numberWithBool:0], AVLinearPCMIsBigEndianKey,
                                  [NSNumber numberWithBool:NO], AVLinearPCMIsNonInterleaved,
                                  [NSData data], AVChannelLayoutKey, nil];
    NSMutableArray *outputFileArray = [[NSMutableArray alloc] init];
    for (int index = 0; index < arrayLength-2 ; index++) {
        double startSeconds = secondsArray[index];
        float endSeconds = secondsArray[index+1];
        double length = endSeconds - startSeconds;
        CMTime startTime = CMTimeMake(timeScale * startSeconds, timeScale);
        CMTime lengthTime = CMTimeMake(timeScale * length , timeScale);
        CMTimeRange timeRange = CMTimeRangeMake(startTime, lengthTime);
        
        AVAssetReader *assetReader = [AVAssetReader assetReaderWithAsset:URLAsset error:nil];
        assetReader.timeRange = timeRange;
        
        NSArray *tracks = [URLAsset tracksWithMediaType:AVMediaTypeAudio];
        
        AVAssetReaderAudioMixOutput *audioMixOutput = [AVAssetReaderAudioMixOutput
                                                       assetReaderAudioMixOutputWithAudioTracks:tracks
                                                       audioSettings:audioSetting];
        [assetReader canAddOutput:audioMixOutput];
        [assetReader addOutput:audioMixOutput];
        [assetReader startReading];
        
        
        NSString *dir = [[NSString alloc] initWithFormat:@"clip/%@",recordFileName];
        [Constant createDir:[NSTemporaryDirectory() stringByAppendingPathComponent:dir]];
        NSString *outPath = [Constant getPathFromFileName:[[NSString alloc]initWithFormat:@"%@_%d",recordFileName,index] withFileType:@".wav" withDir:dir];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:outPath] == YES) {
            [[NSFileManager defaultManager] removeItemAtPath:outPath error:nil];
        }
        
        NSURL *outURL = [NSURL fileURLWithPath:outPath];
        AVAssetWriter *assetWriter = [AVAssetWriter assetWriterWithURL:outURL
                                                              fileType:AVFileTypeWAVE
                                                                 error:nil];
        
        AVAssetWriterInput *assetWriterInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeAudio
                                                                                  outputSettings:audioSetting];
        assetWriterInput.expectsMediaDataInRealTime = NO;
        
        [assetWriter canAddInput:assetWriterInput];
        
        [assetWriter addInput:assetWriterInput];
        
        [assetWriter startWriting];
        
        [assetWriter startSessionAtSourceTime:kCMTimeZero];
        
        dispatch_queue_t queue = dispatch_queue_create("assetWriterQueue", NULL);
        
        BOOL __block isFinish = NO;
        
        [assetWriterInput requestMediaDataWhenReadyOnQueue:queue usingBlock:^{
            
            while (1)
            {
                if ([assetWriterInput isReadyForMoreMediaData]) {
                    
                    CMSampleBufferRef sampleBuffer = [audioMixOutput copyNextSampleBuffer];
                    
                    if (sampleBuffer) {
                        [assetWriterInput appendSampleBuffer:sampleBuffer];
                        CFRelease(sampleBuffer);
                    } else {
                        [assetWriterInput markAsFinished];
                        isFinish = YES;
                        break;
                    }
                }
            }
            
            [assetWriter finishWritingWithCompletionHandler:^{
            }];//finishWriting];
            
            NSLog(@"finish-%d",index);
        }];
        
        while (isFinish == NO) {
            [NSThread sleepForTimeInterval:0.1f];
        }
        
        [outputFileArray addObject:outPath];
    }
    return outputFileArray;
}



#pragma mark 合并切割的音乐
+ (BOOL)mergeAudioFiles:(NSArray *)inputFilesPaths outputFilePath:(NSString *)outputFileFullPath withChannelNum:(NSInteger)channelNum willDeleteInputFilesPaths:(BOOL)willDelete
{
    NSMutableArray *inputFiles = [[NSMutableArray alloc] init];
    for (NSString *inputFilePath in inputFilesPaths) {
        [inputFiles addObject:[NSURL fileURLWithPath:inputFilePath]];
    }
    NSURL *outputURL = [NSURL fileURLWithPath:outputFileFullPath];
    
    BOOL success                                            = YES;
    OSStatus                            err                 = noErr;
    AudioStreamBasicDescription         outputFileFormat;
    NSUInteger                          numberOfChannels    = channelNum;
    ExtAudioFileRef						outputAudioFileRef  = NULL;
    
    [self setDefaultAudioFormatFlags:&outputFileFormat numChannels:numberOfChannels];
    
    UInt32 flags = kAudioFileFlags_EraseFile;
    err = ExtAudioFileCreateWithURL((__bridge CFURLRef)outputURL, kAudioFileWAVEType, &outputFileFormat, NULL, flags, &outputAudioFileRef);
    
    if (err)
    {
        success = NO;
        goto reterr;
    }
    
    for(NSURL *inputURL in inputFiles)
    {
        success =  [self writeAudioFileWithURL:inputURL
                         toAudioFileWithFormat:&outputFileFormat
                                 fileReference:outputAudioFileRef
                           andNumberOfChannels:numberOfChannels];
        if(!success)
        {
            break;
        }
    }
    
reterr:
    if (outputAudioFileRef)
    {
        ExtAudioFileDispose(outputAudioFileRef);
    }
    
    if(willDelete == YES){
        //删除之前切割的文件
        for(NSString *inputFilePath in inputFilesPaths){
            if ([[NSFileManager defaultManager]fileExistsAtPath:inputFilePath] == YES ) {
                [[NSFileManager defaultManager]removeItemAtPath:inputFilePath error:nil];
            }
        }
    }
    
    return success;
}

+ (BOOL)writeAudioFileWithURL:(NSURL *)inputURL
        toAudioFileWithFormat:(AudioStreamBasicDescription *)outputFileFormat
                fileReference:(ExtAudioFileRef)outputAudioFileRef
          andNumberOfChannels:(NSUInteger)numberOfChannels
{
    BOOL                                success             = YES;
    OSStatus                            err                 = noErr;
    AudioStreamBasicDescription			inputFileFormat;
    UInt32								thePropertySize     = sizeof(inputFileFormat);
    ExtAudioFileRef						inputAudioFileRef   = NULL;
    UInt8                               *buffer             = NULL;
    
    err = ExtAudioFileOpenURL((__bridge CFURLRef)inputURL, &inputAudioFileRef);
    if (err)
    {
        success = NO;
        goto reterr;
    }
    
    bzero(&inputFileFormat, sizeof(inputFileFormat));
    err = ExtAudioFileGetProperty(inputAudioFileRef, kExtAudioFileProperty_FileDataFormat, &thePropertySize, &inputFileFormat);
    if (err)
    {
        success = NO;
        goto reterr;
    }
    
    err = ExtAudioFileSetProperty(inputAudioFileRef, kExtAudioFileProperty_ClientDataFormat, sizeof(*outputFileFormat), outputFileFormat);
    if (err)
    {
        success = NO;
        goto reterr;
    }
    
    size_t bufferSize = 4096;
    buffer = malloc(bufferSize);
    assert(buffer);
    
    AudioBufferList conversionBuffer;
    conversionBuffer.mNumberBuffers = 1;
    conversionBuffer.mBuffers[0].mNumberChannels = numberOfChannels;
    conversionBuffer.mBuffers[0].mData = buffer;
    conversionBuffer.mBuffers[0].mDataByteSize = bufferSize;
    
    while (TRUE)
    {
        conversionBuffer.mBuffers[0].mDataByteSize = bufferSize;
        UInt32 frameCount = INT_MAX;
        
        if (inputFileFormat.mBytesPerFrame > 0)
        {
            frameCount = (conversionBuffer.mBuffers[0].mDataByteSize / inputFileFormat.mBytesPerFrame);
        }
        
        err = ExtAudioFileRead(inputAudioFileRef, &frameCount, &conversionBuffer);
        
        if (err)
        {
            success = NO;
            goto reterr;
        }
        
        if (frameCount == 0)
        {
            break;
        }
        
        err = ExtAudioFileWrite(outputAudioFileRef, frameCount, &conversionBuffer);
        
        if (err)
        {
            success = NO;
            goto reterr;
        }
    }
    
reterr:
    if (buffer != NULL)
        free(buffer);
    
    if (inputAudioFileRef)
    {
        ExtAudioFileDispose(inputAudioFileRef);
    }
    
    return success;
}

+ (void)setDefaultAudioFormatFlags:(AudioStreamBasicDescription*)audioFormatPtr
                       numChannels:(NSUInteger)numChannels
{
    bzero(audioFormatPtr, sizeof(AudioStreamBasicDescription));
    audioFormatPtr->mFormatID = kAudioFormatLinearPCM;
    audioFormatPtr->mSampleRate = 44100.0;
    audioFormatPtr->mChannelsPerFrame = numChannels;
    audioFormatPtr->mBytesPerPacket = 2 * numChannels;
    audioFormatPtr->mFramesPerPacket = 1;
    audioFormatPtr->mBytesPerFrame = 2 * numChannels;
    audioFormatPtr->mBitsPerChannel = 16;
    audioFormatPtr->mFormatFlags = kAudioFormatFlagsNativeEndian |
    kAudioFormatFlagIsPacked | kAudioFormatFlagIsSignedInteger;
}

#pragma mark 音乐重叠(混轨)
typedef struct wav_struct
{
    UInt32 file_size;
    UInt16 channel;//通道数，如2双声道的才能进行消除人声
    UInt32 frequency;//采样频率，如44100
    UInt32 bps;//如176400
    UInt16 sample_num_bit;//采样频率，样本位数,如16
    UInt32 data_size;//数据大小
    UInt16 header_bytes;//0x2c
    unsigned char *data;//具体音频数据,位数决定一个音乐样本的字节数，16位的则2个字节一个音频信号
} wav_struct;

typedef struct double_pointer{
    double *data;
    unsigned long N;
}double_pointer;

//这个当前只支持wav,数据块由data四个字符所在
wav_struct initWavParameter(FILE *file)
{
    
    wav_struct ms;
    
    fseek(file, 0, SEEK_END);
    ms.file_size = (UInt32)ftell(file);
    
    fseek(file, 0x16, SEEK_SET);
    fread(&ms.channel,sizeof(ms.channel),1,file);
    
    fseek(file, 0x18, SEEK_SET);
    fread(&ms.frequency,sizeof(ms.frequency),1,file);
    
    fseek(file,0x1c,SEEK_SET);
    fread(&ms.bps,sizeof(ms.bps),1,file);
    
    fseek(file,0x22,SEEK_SET);
    fread(&ms.sample_num_bit,sizeof(ms.sample_num_bit),1,file);
    
    //wav文件中0x22到data四字节之间有不同数据，因此要检索data，data之后的四个字节为文件大小，再之后为数据
    int idx = 0x24;
    while(1){
        char tmp_d,tmp_a,tmp_t,tmp_a2;
        fseek(file,idx,SEEK_SET);
        fread(&tmp_d,sizeof(char),1,file);
        fread(&tmp_a,sizeof(char),1,file);
        fread(&tmp_t,sizeof(char),1,file);
        fread(&tmp_a2,sizeof(char),1,file);
        if(tmp_d == 'd' && tmp_a == 'a'
           && tmp_t == 't' && tmp_a2 == 'a'){
            break;
        }
        idx++;
    }
    idx = idx + 4;
    fseek(file,idx,SEEK_SET);
    fread(&ms.data_size,sizeof(ms.data_size),1,file);
    
    idx = idx + 4;
    ms.header_bytes = idx;
    
    ms.data = (unsigned char *)malloc(sizeof(unsigned char)*ms.data_size);
    fseek(file,idx,SEEK_SET);
    fread(ms.data,sizeof(unsigned char),ms.data_size,file);
    
    return ms;
}

double_pointer* getWavData_audioHandle(char *fileName,double_pointer *voice_data){
    FILE *file;
    if ((file = fopen(fileName, "rb")) == NULL){
        printf("文件打开错误！");
        return NULL;
    }
    wav_struct ms = initWavParameter(file);
    unsigned long N = ms.data_size/2;//读入的文件应该是单声道的,分高低字节只除2不除4
    voice_data->N = N;
    voice_data->data = (double*)malloc(sizeof(double*)*voice_data->N);
    double bits_pow=pow(2,ms.sample_num_bit-1);//编码采用16位，则2^(16-1)=32768
    for (int i=0; i<ms.data_size; i=i+2) {
        unsigned long data_low = ms.data[i];
        unsigned long data_high = ms.data[i+1];
        double data_true = data_high * pow(2,ms.sample_num_bit/2)+data_low;
        long data_complement = 0;//数据的补码
        int data_sign = (int)(data_high / pow(2,ms.sample_num_bit/2-1));//取高位的符号位,128对应二进制的10000000,最高位才为1，为负数
        if (data_sign == 1){
            data_complement = data_true - pow(2,ms.sample_num_bit);
        }
        else{
            data_complement = data_true;
        }
        double double_data = (double)(data_complement/(double)bits_pow);//编码采用16位，则2^(16-1)=32768
        voice_data->data[i/2] = double_data;
    }
    fclose(file);
    free(ms.data);
    return voice_data;
}

double_pointer* addTwoDoublePointer(double_pointer *dataResult, double_pointer *dataAdd){
    unsigned long N = dataResult->N > dataAdd->N ? dataAdd->N : dataResult->N;
    for (int i=0; i<N; i++) {
        dataResult->data[i] += dataAdd->data[i];
    }
    return dataResult;
}

bool check(double_pointer *wav_datas[],int count){
    for (int i=0; i<count-1; i++) {
        if (wav_datas[i]->N != wav_datas[i+1]->N) {
            return false;
        }
    }
    return true;
}

void writeResultFile(double_pointer *result_wav_data,char* outputFileName,char* fileName){
    unsigned long N = result_wav_data->N;
    FILE *originalFile;
    if ((originalFile = fopen(fileName, "rb")) == NULL){
        printf("混轨时文件打开错误！");
        return ;
    }
    wav_struct ms = initWavParameter(originalFile);
    FILE *output_file_new;
    if ((output_file_new = fopen(outputFileName, "w+")) == NULL){
        printf("输出文件打开或写入错误！");
        return;
    }
    for(int i=0; i<ms.header_bytes; i++)
    {
        fseek(originalFile,i,SEEK_SET);
        char tmp;
        fread(&tmp,sizeof(char),1,originalFile);
        fprintf(output_file_new,"%c",tmp);
    }
    for(int i=0; i<N; i++){
        unsigned long data_new_high;
        unsigned long data_new_low;
        long data_complement = (long)(pow(2,ms.sample_num_bit-1) * result_wav_data->data[i]);
        int sign = -1;
        if(data_new_high >= pow(2,ms.sample_num_bit/2-1)){
            sign = -1;
        }else{
            sign = 1;
        }
        unsigned long data_true;
        if(sign == -1){
            data_true = data_complement + pow(2,ms.sample_num_bit);
        }else{
            data_true = data_complement;
        }
        data_new_low = (unsigned long)(data_true % (unsigned long)pow(2,ms.sample_num_bit/2));
        data_new_high = (unsigned long)((data_true - data_new_low)/pow(2,ms.sample_num_bit/2));
        //这里写字节数据
        fwrite(&data_new_low,sizeof(unsigned char),1,output_file_new);//新声道
        fwrite(&data_new_high,sizeof(unsigned char),1,output_file_new);
    }
    fclose(originalFile);
    fclose(output_file_new);
    free(ms.data);
}

+ (BOOL)mixAudio:(NSArray *)inputFilesPaths outputFilePath:(NSString *)outputFilePath willDeleteInputFilesPaths:(BOOL)willDelete;{
    int count = (int)[inputFilesPaths count];
    double_pointer *wav_datas[count];
    for(int i =0; i<count; i++){
        const char *fileNameTmp = [[inputFilesPaths objectAtIndex:i] cStringUsingEncoding:NSASCIIStringEncoding];
        char fileName[strlen(fileNameTmp)+1];
        strcpy(fileName, fileNameTmp);
        wav_datas[i] = (double_pointer *)malloc(sizeof(double_pointer));
        getWavData_audioHandle(fileName,wav_datas[i]);
    }
    //    if (!check(wav_datas,count)){
    //        printf("长度不一样哦");
    //        return NO;
    //    }
    double_pointer *wav_data_result = wav_datas[0];
    for (int i=1; i<count; i++) {
        addTwoDoublePointer(wav_data_result,wav_datas[i]);
        free(wav_datas[i]->data);
        free(wav_datas[i]);
    }
    
    const char *outputFileNameTmp = [outputFilePath cStringUsingEncoding:NSASCIIStringEncoding];
    char outputFileName[strlen(outputFileNameTmp)+1];
    strcpy(outputFileName, outputFileNameTmp);
    
    const char *fileNameTmp = [[inputFilesPaths objectAtIndex:0] cStringUsingEncoding:NSASCIIStringEncoding];
    char fileName[strlen(fileNameTmp)+1];
    strcpy(fileName, fileNameTmp);
    
    writeResultFile(wav_data_result,outputFileName,fileName);
    free(wav_data_result->data);
    free(wav_data_result);
    
    if (willDelete == YES) {
        //删除之前切割的文件
        for(NSString *inputFilePath in inputFilesPaths){
            if ([[NSFileManager defaultManager]fileExistsAtPath:inputFilePath] == YES ) {
                [[NSFileManager defaultManager]removeItemAtPath:inputFilePath error:nil];
            }
        }
    }
    
    if ([[NSFileManager defaultManager]fileExistsAtPath:outputFilePath] == YES ) {
        return YES;
    }else{
        return NO;
    }
}

@end
