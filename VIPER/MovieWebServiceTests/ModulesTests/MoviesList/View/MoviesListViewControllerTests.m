//
//  MoviesListViewControllerTests.m
//  MovieWebService
//
//  Created by Bhabani on 11/04/2017.
//  Copyright © 2017 TestCompany All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>

#import "MoviesListViewController.h"
#import "MoviesListPresenterInput.h"

@interface MoviesListViewControllerTests : XCTestCase

@property (nonatomic, strong) MoviesListViewController *controller;

@property (nonatomic, strong) id mockPresenter;

@end

@implementation MoviesListViewControllerTests

#pragma mark - Настройка окружения для тестирования

- (void)setUp {
    [super setUp];

    self.controller = [[MoviesListViewController alloc] init];

    self.mockPresenter = OCMProtocolMock(@protocol(MoviesListPresenterInput));

    self.controller.presenter = self.mockPresenter;
}

- (void)tearDown {
    self.controller = nil;

    self.mockPresenter = nil;

    [super tearDown];
}

#pragma mark - Тестирование жизненного цикла

- (void)testThatControllerNotifiesPresenterOnDidLoad {
	// given

	// when
	[self.controller loadView];

	// then
	OCMVerify([self.mockPresenter setupView:self.controller.view]);
    
    
    // when
    [self.controller viewWillAppear:TRUE];
    
    // then
    OCMVerify([self.mockPresenter prepareData]);

}

#pragma mark - Тестирование методов интерфейса

#pragma mark - Тестирование методов MoviesListViewInput

@end
