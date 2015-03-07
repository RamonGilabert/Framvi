#import "SettingsViewController.h"

@interface SettingsViewController () <UITableViewDelegate, UITableViewDataSource>

@property CGFloat deviceHeight;
@property CGFloat deviceWidth;
@property UITableView *tableView;

@end

@implementation SettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.deviceWidth = [UIScreen mainScreen].bounds.size.width;
    self.deviceHeight = [UIScreen mainScreen].bounds.size.height;

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 70, self.deviceWidth, self.deviceHeight - 44) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = NO;

    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.deviceWidth, 70)];
    headerView.backgroundColor = [UIColor colorWithRed:0.73 green:0.27 blue:0.46 alpha:1];
    UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, self.deviceWidth, 65)];
    labelTitle.textAlignment = NSTextAlignmentCenter;
    labelTitle.text = @"MAIN SETTINGS";
    labelTitle.textColor = [UIColor whiteColor];
    labelTitle.font = [UIFont fontWithName:@"AvenirNext-Regular" size:19];
    UIButton *buttonGoBack = [[UIButton alloc] initWithFrame:CGRectMake(self.deviceWidth - 70, 5, 70, 65)];
    [buttonGoBack setTitle:@"Done" forState:UIControlStateNormal];
    [buttonGoBack addTarget:self action:@selector(onDoneButtonPressed:) forControlEvents:UIControlEventTouchUpInside];

    [headerView addSubview:labelTitle];
    [headerView addSubview:buttonGoBack];
    [self.view addSubview:headerView];
    [self.view addSubview:self.tableView];
}

#pragma mark - IBActions

- (IBAction)onDoneButtonPressed:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onSwitcherChange:(UISwitch *)sender
{
    CGPoint switcherPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:switcherPosition];

    if (indexPath.row == 0) {
        [[NSUserDefaults standardUserDefaults] setBool:![[NSUserDefaults standardUserDefaults] boolForKey:@"threeFinger"] forKey:@"threeFinger"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else if (indexPath.row == 1) {
        [[NSUserDefaults standardUserDefaults] setBool:![[NSUserDefaults standardUserDefaults] boolForKey:@"autoconnectFramer"] forKey:@"autoconnectFramer"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else if (indexPath.row == 2) {
        [[NSUserDefaults standardUserDefaults] setBool:![[NSUserDefaults standardUserDefaults] boolForKey:@"swipeLeftRight"] forKey:@"swipeLeftRight"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

#pragma mark - UITableView methods

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CellID"];
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    UISwitch *switcherToRemember = [[UISwitch alloc] initWithFrame:CGRectMake(self.deviceWidth - 70, (cell.frame.size.height - 20)/2, 100, 50)];
    [switcherToRemember addTarget:self action:@selector(onSwitcherChange:) forControlEvents:UIControlEventValueChanged];
    [cell addSubview:switcherToRemember];

    if (indexPath.row == 0) {
        cell.textLabel.text = @"Three finger tap";
        cell.detailTextLabel.text = @"To show the top bar";

        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"threeFinger"]) {
            switcherToRemember.on = YES;
        } else {
            switcherToRemember.on = NO;
        }
    } else if (indexPath.row == 1) {
        cell.textLabel.text = @"Autoconnect to FramerJS";
        cell.detailTextLabel.text = @"Say it to you once you open it";

        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"autoconnectFramer"]) {
            switcherToRemember.on = YES;
        } else {
            switcherToRemember.on = NO;
        }
    } else if (indexPath.row == 2) {
        cell.textLabel.text = @"Swipe left and right";
        cell.detailTextLabel.text = @"To go back and forward";

        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"swipeLeftRight"]) {
            switcherToRemember.on = YES;
        } else {
            switcherToRemember.on = NO;
        }
    }

    return cell;
}

@end
