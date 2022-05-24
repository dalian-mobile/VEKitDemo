//
//  OKStorageDemoViewController.m
//  App
//
//  Created by bytedance on 2022/1/30.
//

#import "OKStorageDemoViewController.h"

#if __has_include(<VESMStorage/VESMDBStorage.h>)

#import <VESMStorage/VESMDBStorage.h>
#import <VESMStorage/VESMKVStorage.h>
#import <VESMStorage/VESMFileStorage.h>
#import <VESMStorage/SM4Encryptor.h>

//Message.h
@interface Message : NSObject

@property int localID;
@property(retain) NSString *content;
@property(retain) NSDate *createTime;
@property(retain) NSDate *modifiedTime;
@property(assign) int unused; //You can only define the properties you need

@end

//Message.mm
@implementation Message

WCDB_IMPLEMENTATION(Message)
WCDB_SYNTHESIZE(Message, localID)
WCDB_SYNTHESIZE(Message, content)
WCDB_SYNTHESIZE(Message, createTime)
WCDB_SYNTHESIZE(Message, modifiedTime)

WCDB_PRIMARY(Message, localID)

WCDB_INDEX(Message, "_index", createTime)

@end


@interface Message (WCTTableCoding) <WCTTableCoding>

WCDB_PROPERTY(localID)
WCDB_PROPERTY(content)
WCDB_PROPERTY(createTime)
WCDB_PROPERTY(modifiedTime)

@end


@interface OKStorageDemoViewController()

@property (nonatomic,strong) VESMDBStorage *dbStore;
@property (nonatomic,strong) VESMKVStorage *kvStore;
@property (nonatomic,strong) VESMFileStorage *fileStore;
@property (nonatomic,strong) NSString *sm4Key;

@property (nonatomic,strong) NSArray *entries;

@end


@implementation OKStorageDemoViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUp];
    
    self.entries = @[@"DB插入",@"DB查询",@"DB查询失败",@"KV写入",@"KV读取",@"KV读取失败",@"文件写入",@"文件读取",@"文件读取失败"];
}

- (NSString *)title
{
    return @"国密存储";
}

- (NSString *)iconName
{
    return @"zip";
}

- (void)setUp
{
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"OKDBStorageTest.sqlite3"];
    self.dbStore = [VESMDBStorage storageWithPath:filePath encryptKey:@"password"];
//    self.dbStore = [VESMDBStorage storageWithPath:filePath encryptKey:[SM4Encryptor createSm4Key]];

    BOOL result = [self.dbStore.db createTableAndIndexesOfName:@"message"
                                              withClass:Message.class];
    if (!result) {
        NSLog(@"Database table create failed!");
    }
    
    
    self.kvStore = [VESMKVStorage storageWithName:@"OKKVStroage" encryptKey:[SM4Encryptor createSm4Key]];
    self.fileStore = [VESMFileStorage defaultStorage];
    self.sm4Key = [SM4Encryptor createSm4Key];
}



- (void)testDB
{
    //插入
    Message *message = [[Message alloc] init];
    message.localID = 2;
    message.content = @"Hello, WCDB!";
    message.createTime = [NSDate date];
    message.modifiedTime = [NSDate date];
    /*
     INSERT INTO message(localID, content, createTime, modifiedTime)
     VALUES(1, "Hello, WCDB!", 1496396165, 1496396165);
     */
    BOOL result = [self.dbStore.db insertObject:message
                                    into:@"message"];
    if (!result) {
        NSLog(@"Database insert failed!");
        [self alertWithMessage:@"Database insert failed!"];
    }
    
}

- (void)testDBQuery
{
    //查询
    //SELECT * FROM message ORDER BY localID
    NSArray<Message *> *message = [self.dbStore.db getObjectsOfClass:Message.class
                                                    fromTable:@"message"
                                                      orderBy:Message.localID.order()];
    NSLog(@"Query Result:%@",message);
    if (message.count > 0) {
        NSLog(@"Query Result:%@",message[0].content);
        [self alertWithMessage:[NSString stringWithFormat:@"Query Result:%@",message[0].content]];
    }
}


- (void)testDBQueryFailed
{
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"OKDBStorageTest.sqlite3"];
    VESMDBStorage *dbStore = [VESMDBStorage storageWithPath:filePath encryptKey:@"password1"];
    //查询
    //SELECT * FROM message ORDER BY localID
    NSArray<Message *> *message = [dbStore.db getObjectsOfClass:Message.class
                                                    fromTable:@"message"
                                                      orderBy:Message.localID.order()];
    NSLog(@"Query Result:%@",message);
    if (message.count > 0) {
        NSLog(@"Query Result:%@",message[0].content);
        [self alertWithMessage:[NSString stringWithFormat:@"Query Result:%@",message[0].content]];
    }
}


- (void)testKVSet
{
    [self.kvStore setObject:@"Hello,YYCache" forKey:@"testKey"];
}

- (void)testKVGet
{
    NSString *result = (NSString *)[self.kvStore objectForKey:@"testKey"];
    NSLog(@"%@",result);
    [self alertWithMessage:result];
}

- (void)testKVGetFailed
{
    VESMKVStorage *kvs = [VESMKVStorage storageWithName:@"OKKVStroage" encryptKey:[SM4Encryptor createSm4Key]];
    NSString *result = (NSString *)[kvs objectForKey:@"testKey"];
    NSLog(@"%@",result);
    [self alertWithMessage:result];
}

- (void)testFileWrite
{
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"fileStorageTest"];
    NSString *testInfo = @"Hello,FileData!";
    NSData *toWriteData = [testInfo dataUsingEncoding:NSUTF8StringEncoding];
    BOOL result = [self.fileStore createFileAtPath:filePath contents:toWriteData attributes:@{} encryptKey:self.sm4Key];
    NSLog(@"%d",result);
    [self alertWithMessage:[NSString stringWithFormat:@"write result:%d",result]];

}

- (void)testFileRead
{
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"fileStorageTest"];
    NSData *data = [self.fileStore contentsAtPath:filePath encryptKey:self.sm4Key];
    NSString *testInfo = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@",testInfo);
    [self alertWithMessage:testInfo];

}

- (void)testFileReadFailed
{
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"fileStorageTest"];
    NSData *data = [self.fileStore contentsAtPath:filePath encryptKey:[SM4Encryptor createSm4Key]];
    NSString *testInfo = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@",testInfo);
    [self alertWithMessage:testInfo];
}



#pragma mark - tableview

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.entries.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = self.entries[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        [self testDB];
    }else if(indexPath.row == 1){
        [self testDBQuery];
    }else if(indexPath.row == 2){
        [self testDBQueryFailed];
    }else if(indexPath.row == 3){
        [self testKVSet];
    }else if(indexPath.row == 4){
        [self testKVGet];
    }else if(indexPath.row == 5){
        [self testKVGetFailed];
    }else if(indexPath.row == 6){
        [self testFileWrite];
    }else if(indexPath.row == 7){
        [self testFileRead];
    }else if(indexPath.row == 8){
        [self testFileReadFailed];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UIAlertController *)alertWithMessage:(NSString *)message{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
//    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:ok];
//    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
    return alert;
}



@end


#else

@implementation OKStorageDemoViewController

@end

#endif
