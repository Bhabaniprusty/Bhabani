//
//  MoviesListViewController.m
//  MovieWebService
//
//  Created by Bhabani on 11/04/2017.
//  Copyright © 2017 TestCompany All rights reserved.
//

#import "MoviesListViewController.h"
#import "MoviesListPresenterInput.h"

@implementation MoviesListViewController

#pragma mark - Life cycle


-(void)loadView{
    [super loadView];
    [self.presenter setupView:self.view];
    [self setupInitialState];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.presenter prepareData];
}

#pragma mark - MoviesListViewInput

- (void)setupInitialState {
    self.navigationItem.title = @"RootViewController";
    self.view.backgroundColor = [UIColor whiteColor];
}

@end
