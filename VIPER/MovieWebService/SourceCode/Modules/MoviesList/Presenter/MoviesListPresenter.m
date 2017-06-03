//
//  MoviesListPresenter.m
//  MovieWebService
//
//  Created by Bhabani on 11/04/2017.
//  Copyright © 2017 TestCompany All rights reserved.
//

#import "MoviesListPresenter.h"
#import "Masonry.h"
#import "MovieWebService-Swift.h"
#import "CellTableViewCell.h"
#import "MoviesListInteractorInput.h"
#import "MoviesListRouterInput.h"

@interface MoviesListPresenter() <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *listTableView;
@property (strong, nonatomic) NSArray *films;

@end

@implementation MoviesListPresenter

#pragma mark - MoviesListPresenterInput

- (void)setupView:(UIView *)view {
    self.listTableView = [UITableView new];
    [view addSubview:self.listTableView];
    self.listTableView.rowHeight = UITableViewAutomaticDimension;
    self.listTableView.estimatedRowHeight = 90;
    [self.listTableView registerNib:[UINib nibWithNibName:@"CellTableViewCell" bundle:nil] forCellReuseIdentifier:@"CellTableViewCell"];
    [self.listTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(view);
        make.right.mas_equalTo(view);
        make.top.mas_equalTo(view);
        make.bottom.mas_equalTo(view);
    }];
    
    self.listTableView.delegate = self;
    self.listTableView.dataSource = self;
}

- (void)prepareData{
    
    __weak typeof(self) weakSelf = self;
    [self.interactor fetchFilmsWithCallback:^(NSArray<Film *> * films) {
        weakSelf.films = films;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.listTableView reloadData];
        });
    }];
}


#pragma mark - TableDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.films.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CellTableViewCell";
    CellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    Film *film = [self.films objectAtIndex:indexPath.row];
    MovieViewModel *viewModel = [[MovieViewModel alloc] initWithFilm:film];
    cell.name.text = viewModel.movieName;
    cell.date.text = viewModel.releaseDate;
    cell.filmRating.text = viewModel.ratingCode;
    cell.rating.text = viewModel.rating;
    
    return cell;
}

#pragma mark - TableDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Film *film = [self.films objectAtIndex:indexPath.row];
    [self.router showDetailWithFilm:film];
}

@end
