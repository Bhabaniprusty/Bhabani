//
//  MoviesListInteractorTests.m
//  MovieWebService
//
//  Created by Bhabani on 11/04/2017.
//  Copyright © 2017 TestCompany All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>

#import "MoviesListInteractor.h"
#import "MovieWebServiceTests-Swift.h"
#import "Film.h"

typedef void (^MWCallBack)(NSArray<Film *> *);

@interface MoviesListInteractor()
- (void)fetchFilmsForProvider:(MWDataProvider *)provider WithCallback:(void (^ _Nonnull)(NSArray<Film *> * _Nullable))callback;
@end

@interface MoviesListInteractorTests : XCTestCase

@property (nonatomic, strong) MoviesListInteractor *interactor;

@end

@implementation MoviesListInteractorTests

#pragma mark - Настройка окружения для тестирования

- (void)setUp {
    [super setUp];

    self.interactor = [[MoviesListInteractor alloc] init];
}

-(void)testFetchData{

    NSString *filmName = @"Argo1";
    id mockFilm = [OCMockObject mockForClass:Film.class];
    [[[mockFilm stub] andReturn:filmName] name];
    NSArray<Film *> *fakeResultArray = @[mockFilm];
    
    id dataProviderMock = [OCMockObject mockForClass:MWDataProvider.class];

    [[[dataProviderMock expect] andDo:^(NSInvocation *invocation) {
        MWCallBack endBlock = nil;
        [invocation getArgument:(&endBlock) atIndex:2];
        endBlock(fakeResultArray);
        
    }] getFilmsWithCallback: OCMOCK_ANY];
    
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Completion called"];

    [self.interactor fetchFilmsForProvider:dataProviderMock WithCallback:^(NSArray<Film *> * arr) {
         XCTAssertEqual(filmName, arr.firstObject.name);
         [expectation fulfill];
     }];
    
    [self waitForExpectationsWithTimeout:1 handler:nil];
}

- (void)tearDown {
    self.interactor = nil;

    [super tearDown];
}

#pragma mark - Тестирование методов MoviesListInteractorInput

@end
