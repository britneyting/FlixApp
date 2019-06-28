//
//  MovieViewController.m
//  FlixApp
//
//  Created by britneyting on 6/26/19.
//  Copyright © 2019 britneyting. All rights reserved.
//

#import "MovieViewController.h"
#import "MovieCell.h"
#import "UIImageView+AFNetworking.h"
#import "DetailsViewController.h"

@interface MovieViewController () <UITableViewDataSource, UITableViewDelegate> // this class implements this protocol. Protocol is a promise that you'll implement the methods inside the brackets. 1st protocol shows table view content, 2nd protocol knows how to respond to table view events (ex: scrolls, selects cell). Need to set rows and sections for 1st, but not 2nd

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *movies; // a private variable is declared using this _movies
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation MovieViewController


// The JSON file in this case is just one dictionary with one key, 'results'. Need to pull out more dictionaries from this dictionary.

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self fetchMovies];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchMovies) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0]; // insert refresh control instead of just adding it allows it to be within the first movie instead of the outside as happens when you use addSubview (see below)
//    [self.tableView addSubview:self.refreshControl]; // however, just adding the refresh control will cause the refresh to just spin forever. We need to add what function it calls when it's refreshed.
}
    
    // Do any additional setup after loading the view.
    // right after loading the view, we use this block of code to call data from JSON file and get the titles of movies.
    // however, after accessing the titles, we've only put it in a local variable. We want to be able to access it later for the viewtable. As a result, we create a property movies above and then access the object as self.movies
    // View tables allow you to copy the same layout over and over again


- (void)fetchMovies {
    
    [self.activityIndicator startAnimating];
    
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
        }
        else {
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            NSLog(@"%@", dataDictionary); // %@ means we're going to specify an object
            
            self.movies = dataDictionary[@"results"]; //accessing keys of dictionary using this syntax -- the key in this case is "results". Put the value of that key into an array.
            
            // for each dictionary (variable name = movie) in the array movies, print out the value of the key (key = 'title' in this case)
            for (NSDictionary *movie in self.movies) { // need to declare the variable type
                NSLog(@"%@", movie[@"title"]);
            }
            [self.tableView reloadData];
            // TODO: Get the array of movies
            // TODO: Store the movies in a property to use elsewhere
            // TODO: Reload your table view data
        }
        [self.refreshControl endRefreshing];
        
        [self.activityIndicator stopAnimating];
        
    }];
    [task resume];
    }

// tells you how many rows you have
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:
    (NSInteger)section {
    return self.movies.count; // 20 cells
}

// configures cell based on diff index path
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath { // indexPath has row and section
    
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell"]; // pass tableView to reuseable cell identifier that's named MovieCell
    
    NSLog(@"%@", [NSString stringWithFormat:@"row: %d, section %d", indexPath.row, indexPath.section]);
    
    NSDictionary *movie = self.movies[indexPath.row];
    cell.titleLabel.text = movie[@"title"]; // for each cell, sets title to whatever's in the API under 'title'
    cell.synopsisLabel.text = movie[@"overview"]; // for each cell, sets synopsis to whatever's in the API under 'overview'
    
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *posterURLString = movie[@"poster_path"];
    NSString *fullPosterURLString = [baseURLString stringByAppendingString:posterURLString];
    
    // NSURL checks to make sure link is a valid URL
    NSURL *posterURL = [NSURL URLWithString:fullPosterURLString];
    cell.posterView.image = nil;
    [cell.posterView setImageWithURL:posterURL];
    
 //   cell.textLabel.text = movie[@"title"]; // it only loads the rows that show on the screen
    return cell;
}

    


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//     Get the new view controller using [segue destinationViewController].
//     Pass the selected object to the new view controller
    
    UITableViewCell *tappedCell = sender;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
    NSDictionary *movie = self.movies[indexPath.row];
    DetailsViewController *detailsViewController = [segue destinationViewController];
    detailsViewController.movie = movie;
}

@end
