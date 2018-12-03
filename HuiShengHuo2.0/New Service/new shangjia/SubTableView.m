//
//  SubTableView.m
//  NestedTable
//

//

#import "SubTableView.h"

@implementation SubTableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.table.frame = self.bounds;
        [self addSubview:self.table];
    }
    return self;
}


-(LolitaTableView *)table{
    if (_table==nil) {
        _table = [[LolitaTableView alloc] initWithFrame:CGRectZero];
        _table.delegate = self;
        _table.dataSource = self;
        _table.showsVerticalScrollIndicator = NO;
        _table.tableFooterView = [UIView new];
        _table.type = LolitaTableViewTypeSub;
    }
    return _table;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;    //点击的时候无效果
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%u",arc4random_uniform(100)];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if ([_num isEqualToString:@"0"]) {
        return 50;
    }else{
        return 0;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if ([_num isEqualToString:@"0"]) {
        _cateArr = [[NSArray alloc] init];
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
        for (int i=0; i<_cateArr.count; i++) {
            [arr addObject:[[_cateArr objectAtIndex:i] objectForKey:@"category_cn"]];
        }
        WBLog(@"%@--%@",arr,_cateArr);
        UIView *backview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_width, 50)];
        backview.backgroundColor = [UIColor whiteColor];
        FSSegmentTitleView *titleView = [[FSSegmentTitleView alloc]initWithFrame:CGRectMake(0, 0, Main_width-60, 50) titles:arr delegate:nil indicatorType:3];
        titleView.backgroundColor = [UIColor whiteColor];
        [backview addSubview:titleView];
        return (UIView*)backview;
    }else{
        return nil;
    }
}



@end
