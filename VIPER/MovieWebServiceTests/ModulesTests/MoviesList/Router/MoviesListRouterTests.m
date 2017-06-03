//
//  MoviesListRouterTests.m
//  MovieWebService
//
//  Created by Bhabani on 11/04/2017.
//  Copyright © 2017 TestCompany All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>

#import "MoviesListRouter.h"
#import "Film.h"

@interface MoviesListRouterTests : XCTestCase

@property (nonatomic, strong) MoviesListRouter *router;

@end

@implementation MoviesListRouterTests

#pragma mark - Настройка окружения для тестирования

- (void)setUp {
    [super setUp];


    self.router = [[MoviesListRouter alloc] init];
}

-(void)testRoute{
    
    //given
    id mockVC = [OCMockObject mockForClass:UIViewController.class];
    id mocknNavVC = [UINavigationController new];
    [[[mockVC stub] andReturn:mocknNavVC] navigationController];
    id mockFilm = [OCMockObject mockForClass:Film.class];
    self.router.view = mockVC;
    
    // when
    [self.router showDetailWithFilm:mockFilm];
    
    // then
    OCMVerify([self.router.view.navigationController pushViewController:OCMOCK_ANY animated:OCMOCK_ANY]);
}

- (void)tearDown {
    self.router = nil;

    [super tearDown];
}

@end
