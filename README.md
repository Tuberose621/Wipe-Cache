- **设置界面中清除缓存的处理**---** 每个App几乎都有清除缓存的功能**

-------------------------------------------------------
**一**
-  手机上的磁盘缓存 == 从网络上下载的数据 + 写入的数据
-  手机上的磁盘缓存的数据类型 == 图片 + 多媒体文件(音频视频等)
-  它们存在于沙盒之中
- 这里要清除缓存，就要拿到沙盒中存在的缓存的大小，就是看我们下载的图片文件有多大，然后把它显示在cell当中 
- 因为我们下载图片用到是SDWebImage框架，所以我们要获取所下载图片的缓存大小，最简单的方法也是使用SDWebImage里面的东西--SDImageCache

![](http://upload-images.jianshu.io/upload_images/739863-c0eeb1da5fabd991.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


----------------------------------------
**二**
- 获取磁盘缓存的大小，它是一个单例
- 在我们Mac 和 iOS 中数据的大小不是以1024为单位的而是以1000为单位，不用弄混淆了

```objc
    // 这里打印出来的单位是Mb
    CYLog(@"%f", [SDImageCache sharedImageCache].getSize / 1000.0 / 1000.0);
    // 拿到沙盒的路径
    CYLog(@"%@", NSTemporaryDirectory());
```
![](http://upload-images.jianshu.io/upload_images/739863-fca21e4058df5303.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

----------------------------
**三**
- 沙盒的结构
  +  Ducuments中不允许放太大的文件，那里面的文件是要备份到iTunes中去的，也就是说要备份到苹果的云服务器中去。如果你把下载的缓存文件放在其中，苹果是不允许你的应用通过的
  + Library文件夹里面存放在缓存文件（整个缓存是在default文件夹中）
  + temp文件夹存放临时文件

![](http://upload-images.jianshu.io/upload_images/739863-cb5ec757324999d0.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


----------------------------------------------------
**四**
- **怎么去获取一个文件夹或者文件夹的大小呢？**
  + SDWebImage用了一个类：FileManager
  + 但它只能获取文件的大小，无法获取整个文件夹的大小

```objc
    // 文件管理者
    NSFileManager *mgr = [NSFileManager defaultManager];
```
- 怎么去找到default文件夹，拿到它的路径呢？
  
```objc
    // 先拿到caches文件夹路径（它返回的是数组，所以取第一个）
    NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString *file = [caches stringByAppendingPathComponent:@"default"];// 拼接的路径
//    NSString *file = [caches stringByAppendingString:@"default"];// 这是拼接的字符串
```
- 获取文件夹的属性

```objc
// 获得文件属性
// 它只给你文件夹这个壳子有多大，没有给里面的文件有多大
NSDictionary *attrs = [mgr attributesOfItemAtPath:file error:nil];
```
- 在Mac中不能直接拿到文件夹的大小，只能对文件夹进行一层一层的遍历，去拿到里面文件的大小，然后全部加起来
- 所以我们得遍历文件夹里面所以的文件，然后把里面所有文件的FileSize加起来
- **第一种方式**

```objc
    // 总大小
    NSInteger size = 0;

    // 文件路径
    // 先拿到caches文件夹路径（它返回的是数组，所以取第一个）
    NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString *file = [caches stringByAppendingPathComponent:@"default"];// 拼接的路径
//    NSString *file = [caches stringByAppendingString:@"default"];// 这是拼接的字符串

    // 文件管理者
    NSFileManager *mgr = [NSFileManager defaultManager];

    // 获得文件夹中的所有内容
//        NSArray *contents = [mgr contentsOfDirectoryAtPath:file error:nil];
//        它只能获得它当前文件夹的内容，不能往里面深挖，这里不用它
//        subpaths 获取文件夹里面文件的子路径，什么文件都能拿到了（文件夹能拿到，文件夹里面的文件也能拿到）
//        所以用subpaths就是做好的，只有给我们一个最根的文件夹，我们就能找到里面所有的文件，不需要一遍一遍递归去找了
    NSArray *subpaths = [mgr subpathsAtPath:file];
    for (NSString *subpath in subpaths) {
        // 获得全路径
        NSString *fullSubpath = [file stringByAppendingPathComponent:subpath];
        // 获得文件属性
        NSDictionary *attrs = [mgr attributesOfItemAtPath:fullSubpath error:nil];
//        size += [attrs[NSFileSize] integerValue];
        size += attrs.fileSize;
    }
```
- 这个方式是通过拼接所有的路径而去获取缓存的大小
- 但是我还有另外一种方式

- **第二种方式**

```objc
    // 总大小
    NSInteger size = 0;

    // 文件路径
    NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString *file = [caches stringByAppendingPathComponent:@"default"];

    // 文件管理者
    NSFileManager *mgr = [NSFileManager defaultManager];

    // 获得文件夹中的所有内容
    // enumerator遍历器，可以通过for..in..遍历所有的子路径
    NSDirectoryEnumerator *enumerator = [mgr enumeratorAtPath:file];
    for (NSString *subpath in enumerator) {
        // 获得全路径
        NSString *fullSubpath = [file stringByAppendingPathComponent:subpath];
        // 获得文件属性
        NSDictionary *attrs = [mgr attributesOfItemAtPath:fullSubpath error:nil];
//        size += [attrs[NSFileSize] integerValue];
//       通过key直接取出来
        size += attrs.fileSize;
    }
```

- 第二种方式的原理：怎么获取一个文件夹内容的大小，把一个文件夹给我，有了文件夹路径，有了manager，然后获得一个可以获取文件夹路径的遍历器，它通过for...in...可以遍历出所有文件夹的子路径。通过子路径生成一个完整的路径（全路径），我就获取所有子路径文件的大小。把它所有的文件夹大小加起来，就是我们总文件的大小。


- 下面是SDWebImage的实现方法：

```objc
- (NSUInteger)getSize {
    __block NSUInteger size = 0;
    dispatch_sync(self.ioQueue, ^{
        NSDirectoryEnumerator *fileEnumerator = [_fileManager enumeratorAtPath:self.diskCachePath];
        for (NSString *fileName in fileEnumerator) {
            NSString *filePath = [self.diskCachePath stringByAppendingPathComponent:fileName];
            NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
            size += [attrs fileSize];
        }
    });
    return size;
}

```
- SDWebImage底层在这里是怎么实现：把一个文件夹传进去，获取所有的迭代器，从迭代器中获取所有的子路径通过文件夹路径拼接一个文件名变成一个全路径，然后再通过attributes这个属性累加起来；但是，它是直接调用字典这种方法（我们是前面是通过key取出来的），而且是放在一个自己创建的一个串行队列中去的，也就是异步的
- 但是现在放在viewDidLoad中算，肯定是有问题的，比较耗时，我们得修改

----------------------------------------------------
**五**
- 我们先抽取一个分类（今后你给一个字符串给我，就能获取字符串对应路径的大小）
  + 但是严谨起见，分类中要考虑的问题：
      + 可能是个文件夹，也可能是个文件，所以先得判断这个文件存不存在，还要判断这个路径下是文件还是文件夹
      + 路径可能也会错，也得判断
- NSString+CYExtension.h文件中

```objc
#import <Foundation/Foundation.h>

@interface NSString (CYExtension)
- (NSInteger)fileSize;
@end
```
- NSString+CYExtension.m文件中

```objc
#import "NSString+CYExtension.h"

@implementation NSString (CYExtension)
// 判断一个路径是文件夹 or 文件
//    [[mgr attributesOfItemAtPath:self error:nil].fileType isEqualToString:NSFileTypeDirectory];

- (NSInteger)fileSize
{
    // 文件管理者
    NSFileManager *mgr = [NSFileManager defaultManager];
    // 是否为文件夹
    BOOL isDirectory = NO;
    // 这个路径是否存在
    BOOL exists = [mgr fileExistsAtPath:self isDirectory:&isDirectory];
    // 路径不存在
    if (exists == NO) return 0;

    if (isDirectory) { // 文件夹
        // 总大小
        NSInteger size = 0;
        // 获得文件夹中的所有内容
        NSDirectoryEnumerator *enumerator = [mgr enumeratorAtPath:self];
        for (NSString *subpath in enumerator) {
            // 获得全路径
            NSString *fullSubpath = [self stringByAppendingPathComponent:subpath];
            // 获得文件属性
            size += [mgr attributesOfItemAtPath:fullSubpath error:nil].fileSize;
        }
        return size;
    } else { // 文件
        return [mgr attributesOfItemAtPath:self error:nil].fileSize;
    }
}
@end
```

- 然后放入PCH文件中
- 所以今后想算一个文件夹或者文件的大小，你直接将这个分类拽走就行了，给我传一个路径就ok了
-----------------------------------------------------
**六**

- **在计算文件夹大小时，我们有过体验，文件夹大的话，要计算很长一段时间，所以`清除缓存和计算缓存大小都要放在子线程中`**
- **接下来我们就要将App中缓存的大小算出来，显示在cell中**
   - 如果我直接调用cacheFile.fileSize/1000.0/1000.0在cell中计算并显示，如果文件多了，缓存多了，文件夹层级结构多了，遍历起来就会很耗时，所以这个时候调用fileSize，里面的for循环就会遍历很久，就会卡顿了。
   - 这时候，你可能就会想到放在子线程，开启一个全局队列，把计算缓存的代码放在其中。但是其实放在这里是不太好的。因为子线程是不允许刷新UI界面的。如果你硬是要这么干呢，也可以，在子线程中把缓存大小算出来，然后又再开启一个主线程，显示缓存大小的文字（你会发现，是不会卡顿了，但是刚刚进入界面的时候，cell中是空白的，你拖拽之后才会显示出来）所以这样也是不推荐的

```objc
        // 计算大小
        dispatch_sync(dispatch_get_global_queue(0, 0), ^{
            // 计算缓存大小
            NSString *cacheFile = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"default"];
            NSString *text = [NSString stringWithFormat:@"清除缓存(%1.fMB)",cacheFile.fileSize / 1000.0 / 1000.0] / 1000.0];

            // 回到主线程
            dispatch_sync(dispatch_get_main_queue(), ^{
                self.textLabel.text = text;
            });
        });
```
- **对于这样一种特殊要求的cell，我们就自定义了--CYClearCacheCell**
- 将缓存路径写成一个宏，因为可能总是会用到

```objc
/** 缓存路径 */
#define CYCacheFile [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"default"]
```
   + 重写它的initWithStyle:方法
- 你如果不想用GCD，那就用NSOperationQueue，先在子线程中计算，然后在主线程中刷新，这样更加面向对象
- 一般当你计算缓存的时候，你最好弄一个圈圈在哪里转，这个时候用户不能点击；算完之后，圈圈消失，箭头出现，这个时候用户才可以点击

```objc
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.textLabel.text = @"清除缓存";

        // 禁止点击事件
        self.userInteractionEnabled = NO;

        // 右边显示圈圈
        UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [loadingView startAnimating];
        self.accessoryView = loadingView;

        // 计算大小
        [[[NSOperationQueue alloc] init] addOperationWithBlock:^{
            // 计算缓存大小
            NSInteger size = CYCacheFile.fileSize;
            NSString *text = [NSString stringWithFormat:@"清除缓存(%1.fMB)",size / 1000.0 / 1000.0] / 1000.0];

            // 回到主线程
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                self.textLabel.text = text;
                self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                self.accessoryView = nil;// accessoryView的优先级是高于UITableViewCellAccessoryDisclosureIndicator（没有指针指针就挂了）
                // 允许点击事件
                self.userInteractionEnabled = YES;
            }];
        }];
    }
    return self;
}
```
- 还有就是你清除缓存的地方，不一定是KB,MB.也可能是GB.所以得分情况判断

```objc
// 计算大小
        [[[NSOperationQueue alloc] init] addOperationWithBlock:^{
            // 计算缓存大小
            NSInteger size = CYCacheFile.fileSize;
            CGFloat unit = 1000.0;
            NSString *sizeText = nil;
            if (size >= unit * unit * unit) { // >= 1GB
                sizeText = [NSString stringWithFormat:@"%.1fGB", size / unit / unit / unit];
            } else if (size >= unit * unit) { // >= 1MB
                sizeText = [NSString stringWithFormat:@"%.1fMB", size / unit / unit];
            } else if (size >= unit) { // >= 1KB
                sizeText = [NSString stringWithFormat:@"%.1fKB", size / unit];
            } else { // >= 0B
                sizeText = [NSString stringWithFormat:@"%zdB", size];
            }
            NSString *text = [NSString stringWithFormat:@"%@(%@)", CYDefaultText, sizeText];
```
- 每个cell被点击选中的时候，默认都有一个颜色，通过实现代理方法，监听cell的点击，让系统默认的灰色在点击的时候不显现，这个有用

```objc
 - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 取消选中（你一点击，我就取消选中，那样的话，cell默认的灰色就不见了）
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
```

----------------------------------------------
**七**
- **那现在真的要清除缓存了**
  + 怎么清除呢？把文件夹删掉
- 删除整一个文件夹，如果东西多，它肯定删除得慢，耗时操作放在在子线程中进行
- 而且好多应用在清除缓存的时候都会弹出一个框提示，而且你还得将你的文字改过来（清除完了就没有大小了 ）
   + 有一个小细节，假设我们缓存算得比较慢的时候，可能还没算完，用户就去点击了，这样的话就不合理了。一般是要算完之后，才允许用户去点击。
   + 所以一进来的时候，就要禁止用户点击事件。回到主线程算完后，允许用户点击，而且在你清除掉之后，也应该禁止它点击（取决产品要求）这才是合理的

```objc
- (void)clearCache
{
    [SVProgressHUD showWithStatus:@"正在清除缓存" maskType:SVProgressHUDMaskTypeBlack];

    [[[NSOperationQueue alloc] init] addOperationWithBlock:^{
        [[NSFileManager defaultManager] removeItemAtPath:CYCacheFile error:nil];

        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [SVProgressHUD showSuccessWithStatus:@"清除成功"];

            self.textLabel.text = CYDefaultText;

            // 禁止点击事件
            self.userInteractionEnabled = NO;
        }];
    }];
}
```  

```objc
 // 清除缓存(这个方法是：你直接传一个行号给我，我返回这一行对应的cell给你，然后调用clearCache：方法就行了)
    CYClearCacheCell *cell = (CYClearCacheCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell clearCache];
```
-----------------------------------------------
**八**

- **清除缓存的逻辑：**
   + **首先，在我们的控制器中注册一下cell，告诉它这种标识对应这种类型的cell。在返回cell的时候就通过这种标识返回这个cell去。cell一旦返回就显示到界面里来了。**
   + **cell里面的功能呢？一旦初始化这个cell，我们首先设置文字为“清除缓存”。然后在它的右边显示一个圈圈让它转。在它转的过程中，我们在子线程中计算它缓存的大小。算完之后，我们就回到主线程，把缓存大小显示出来，并且把这个圈圈销毁掉，在最右边显示一个箭头。点击这个cell的时候，来到控制器，调用这个cell的clearCache：方法。一旦调用clearCache：方法。我们首先弹出一个框，告诉它:"正在清除缓存"，在子线程把文件夹给删掉(因为它可能很多，删除会删得很耗时)，删掉后，我们回到主线程，告诉它我们“清除成功”，并且把文字恢复成清除缓存**
------------------------------------------------
**九**
- **cell循环利用的问题**
- 你在设置界面，可不是只有一个“清除缓存”这样的cell，在应用中是还有许多其它cell的（这里我们假如将控制器设置为5组，每组5行。你会发现：其余的cell也变成和清除缓存一样的cell）这样的话就牵扯到一个问题：循环运用的问题：

![](http://upload-images.jianshu.io/upload_images/739863-7e107e5982b7cf28.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
   + **TableView中有许多的cell，你向上或者向下拖拽的时候，“清除缓存”的cell，被扔进了缓存池中，你再往上或者往下拖的时候，你就得取别的cell，但是缓存池中刚刚好有一个“清除缓存”的cell，（按照以前的开发模式，你就得把“清除缓存”的cell改成别的cell。如果你有拖拽一下，你又得把别的cell拿过来改成清除缓存的cell） 会有这样的麻烦问题。所以为了解决这样的麻烦问题，我们干脆这么做：只要“清除缓存”的cell和其他cell的标识不一样就行了，这样后面的cell循环利用的时候，就不会去拿我“清除缓存”的cell了（假设清除缓存cell的标识为A，其他cell为D。当我的清除缓存的cell被扔到了在缓存池中，而滑动操作又需要其它D类型的cell的时候，我们就去缓存池中去找，缓存池中没有D标识的，我们就新创建一个。反正后面需要D标识的就找D标识的cell，需要“清除缓存”的cell，就找A标识的cell。这样的话，我们A标识的cell永远都不会用错到其它地方去）**

![](http://upload-images.jianshu.io/upload_images/739863-97fd5194991a9bdc.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
- 今后遇到像这种“清除缓存”的cell，也就是所有cell中它最特殊的cell，其它cell和它完全不一样，也就是说其它cell不可能和它循环利用的这样的特殊的cell。一旦循环利用会很麻烦的，你干脆把它独立出来，搞一个全新的cell，给它注册一个全新的标识。
- 所以我们得判断，而且在判断之前，我们得先做一件事，注册两种类型的cell。到时候我们只认标识就可以了

```objc
static NSString * const CYClearCacheCellId = @"clearCache";
static NSString * const CYOtherCellId = @"other";
static NSString * const CYThirdCellId = @"third";
```
- 注册完后，也要判断

```objc
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) { // 清除缓存的cell
        CYClearCacheCell *cell = [tableView dequeueReusableCellWithIdentifier:CYClearCacheCellId];
        [cell updateStatus];
        return cell;
    } else if (indexPath.section == 1 && indexPath.row == 2) {
        return [tableView dequeueReusableCellWithIdentifier:CYThirdCellId];
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CYOtherCellId];
        cell.textLabel.text = [NSString stringWithFormat:@"%zd - %zd", indexPath.section, indexPath.row];
        return cell;
    }
}
```

![](http://upload-images.jianshu.io/upload_images/739863-c7d6e6dac9d5e618.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

- 所以这个时候，我们就可以放心大胆的把内容封装在CYClearCacheCell中了。因为它里面封装的内容只会显示在CYClearCacheCell上，不会影响到其他人。如果你的cell是要循环利用的，你封装到CYClearCacheCell中是不合适的，但是现在就可以放心大胆了。这个cell是独立的，没有人和他抢，所以内容显示到它身上就可以了，直接拿到它操作就可以了，所以这个cell是不会循环利用的。
    - 只不过还有一个小问题小细节的处理：在iOS中。默认有个特点：当你的程序进入后台，或者说你这个View暂时不在界面。就像当这个“清除缓存”的cell，离开屏幕，进入缓存池，它会将一些不必要的操作停掉，比如说动画。它就会将它里面的所有动画停掉，包括像imageView的一些动画，或者这个UIActivityIndicatorView的一些动画（转圈圈）它都会停掉，特别是你的涂层动画，核心动画它都会停掉。所以我们要进行状态的判断，来刷新界面）
    - 场景：用户点击清除缓存，又向下拖拽很快，本来还在转圈圈计算缓存大小，转圈圈动画停止了。这只是个小细节。也就是我我们要判断圈圈的状态：在拖拽时，cellForRowAtIndexPath:方法会调用，我们在这里进行一个圈圈状态的判断。如果算完了，我们就不需要圈圈。没算完，继续算，继续转圈圈，不能让他一往下拖，圈圈就消失了。

```objc
- (void)updateStatus
{
    if (self.accessoryView == nil) return;

    // 让圈圈继续旋转
    UIActivityIndicatorView *loadingView = (UIActivityIndicatorView *)self.accessoryView;
    [loadingView startAnimating];
}
```  

- 每一个用什么类型的cell，你通过标识就可以了，它会自动创建对应类型的cell，或者去缓存池中找。所以以后凡是你的tableview里面发现有好几种不一样的cell，而且感觉那个cell和其它cell根本没法循环利用，但是其它的大部分cell又可以循环利用，那就让大部分的cell用同样类型的标识就可以了，特殊的给定特殊的标识

---------------------------------------------
- 最后在CYSettingViewController.m文件中

```objc
#import "CYSettingViewController.h"
#import <SDImageCache.h>
#import "CYClearCacheCell.h"
#import "CYThirdCell.h"

@interface CYSettingViewController ()

@end

@implementation CYSettingViewController

static NSString * const CYClearCacheCellId = @"clearCache";
static NSString * const CYOtherCellId = @"other";
static NSString * const CYThirdCellId = @"third";

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"设置";
    self.view.backgroundColor = CYCommonBgColor;

    [self.tableView registerClass:[CYClearCacheCell class] forCellReuseIdentifier:CYClearCacheCellId];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CYOtherCellId];
    [self.tableView registerClass:[CYThirdCell class] forCellReuseIdentifier:CYThirdCellId];

    // 设置内边距(-25代表：所有内容往上移动25)
    self.tableView.contentInset = UIEdgeInsetsMake(CYCommonMargin - 35, 0, 0, 0);
}

#pragma mark - <数据源>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) { // 清除缓存的cell
        CYClearCacheCell *cell = [tableView dequeueReusableCellWithIdentifier:CYClearCacheCellId];
        [cell updateStatus];
        return cell;
    } else if (indexPath.section == 1 && indexPath.row == 2) {
        return [tableView dequeueReusableCellWithIdentifier:CYThirdCellId];
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CYOtherCellId];
        cell.textLabel.text = [NSString stringWithFormat:@"%zd - %zd", indexPath.section, indexPath.row];
        return cell;
    }
}

#pragma mark - <代理>
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 取消选中
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    // 清除缓存
    CYClearCacheCell *cell = (CYClearCacheCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell clearCache];
}
@end
```

- 在CYClearCacheCell.h文件中

```objc
#import <UIKit/UIKit.h>

@interface CYClearCacheCell : UITableViewCell

- (void)clearCache;
/**
 * 更新状态
 */
- (void)updateStatus;
@end
```
- 在CYClearCacheCell.m文件中

```objc
#import "CYClearCacheCell.h"
#import <SVProgressHUD.h>

/** 缓存路径 */
#define CYCacheFile [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"default"]

static NSString * const CYDefaultText = @"清除缓存";

@implementation CYClearCacheCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.textLabel.text = CYDefaultText;

        // 禁止点击事件
        self.userInteractionEnabled = NO;

        // 右边显示圈圈
        UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [loadingView startAnimating];
        self.accessoryView = loadingView;

        // 计算大小
        [[[NSOperationQueue alloc] init] addOperationWithBlock:^{
            // 计算缓存大小
            NSInteger size = CYCacheFile.fileSize;
            CGFloat unit = 1000.0;
            NSString *sizeText = nil;
            if (size >= unit * unit * unit) { // >= 1GB
                sizeText = [NSString stringWithFormat:@"%.1fGB", size / unit / unit / unit];
            } else if (size >= unit * unit) { // >= 1MB
                sizeText = [NSString stringWithFormat:@"%.1fMB", size / unit / unit];
            } else if (size >= unit) { // >= 1KB
                sizeText = [NSString stringWithFormat:@"%.1fKB", size / unit];
            } else { // >= 0B
                sizeText = [NSString stringWithFormat:@"%zdB", size];
            }
            NSString *text = [NSString stringWithFormat:@"%@(%@)", CYDefaultText, sizeText];

            // 回到主线程
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                self.textLabel.text = text;
                self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                self.accessoryView = nil;// accessoryView的优先级是高于UITableViewCellAccessoryDisclosureIndicator（没有指针指针就挂了）
                // 允许点击事件
                self.userInteractionEnabled = YES;
            }];
        }];
    }
    return self;
}

- (void)updateStatus
{
    if (self.accessoryView == nil) return;

    // 让圈圈继续旋转
    UIActivityIndicatorView *loadingView = (UIActivityIndicatorView *)self.accessoryView;
    [loadingView startAnimating];
}

- (void)clearCache
{
    [SVProgressHUD showWithStatus:@"正在清除缓存" maskType:SVProgressHUDMaskTypeBlack];

    [[[NSOperationQueue alloc] init] addOperationWithBlock:^{
        [[NSFileManager defaultManager] removeItemAtPath:CYCacheFile error:nil];

        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [SVProgressHUD showSuccessWithStatus:@"清除成功"];

            self.textLabel.text = CYDefaultText;

            // 禁止点击事件
            self.userInteractionEnabled = NO;
        }];
    }];
}

@end
```







- **项目地址：https://github.com/Tuberose621/Wipe-Cache**
**如果可以的话，Give me a star!**
