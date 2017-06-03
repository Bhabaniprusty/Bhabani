//
//  MoviesListPresenterTests.m
//  MovieWebService
//
//  Created by Bhabani on 11/04/2017.
//  Copyright © 2017 TestCompany All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>

#import "MoviesListPresenter.h"
#import "MoviesListInteractorInput.h"
#import "MoviesListRouterInput.h"
#import "Film.h"

//Exposed private methods
@interface MoviesListPresenter() <UITableViewDelegate>

@property (strong, nonatomic) NSArray *films;

@end

@interface MoviesListPresenterTests : XCTestCase

@property (nonatomic, strong) MoviesListPresenter *presenter;

@property (nonatomic, strong) id mockInteractor;
@property (nonatomic, strong) id mockRouter;
@property (nonatomic, strong) id mockView;

@end

@implementation MoviesListPresenterTests

#pragma mark - Настройка окружения для тестирования

- (void)setUp {
    [super setUp];

    self.presenter = [[MoviesListPresenter alloc] init];

    self.mockInteractor = OCMProtocolMock(@protocol(MoviesListInteractorInput));
    self.mockRouter = OCMProtocolMock(@protocol(MoviesListRouterInput));

    self.presenter.interactor = self.mockInteractor;
    self.presenter.router = self.mockRouter;
}

- (void)tearDown {
    self.presenter = nil;
    self.mockRouter = nil;
    self.mockInteractor = nil;

    [super tearDown];
}

#pragma mark - Тестирование методов MoviesListModuleInput

#pragma mark - Тестирование методов MoviesListViewOutput

- (void)testThatPresenterHandlesViewReadyEvent {
    // given


    // when
    [self.presenter prepareData];
    
    // then
    OCMVerify([self.mockInteractor fetchFilmsWithCallback:OCMOCK_ANY]);

    
    //Verify logic if its taking the first film object incase first row selected, Similar random row should be verified
    
    //given
    id mockFilm = OCMClassMock(Film.class);
    id mockTableView = OCMClassMock(UITableView.class);
    
    id mockIndexPath = OCMClassMock(NSIndexPath.class);
    [[[mockIndexPath stub] andReturnValue:OCMOCK_VALUE(0)] row];

    
    id mockPresenter = [OCMockObject partialMockForObject:self.presenter];
    [[[mockPresenter stub] andReturn:@[mockFilm]] films];
    
    // when
    [self.presenter tableView:mockTableView didSelectRowAtIndexPath:mockIndexPath];
    
    // then
    OCMVerify([self.mockRouter showDetailWithFilm:mockFilm]);
}

#pragma mark - Тестирование методов MoviesListInteractorOutput

@end
