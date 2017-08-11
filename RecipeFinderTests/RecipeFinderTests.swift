//
//  RecipeFinderTests.swift
//  RecipeFinderTests
//
//  Created by BMGH SRL on 11/08/2017.
//  Copyright © 2017 BMAGH SRL. All rights reserved.
//

import XCTest
@testable import RecipeFinder

class RecipeFinderTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testAsynchCallBack() {
        
        let manager = RemoteDataManager()
        
        let expect = expectation(description: "RemoteManagerCalled and will return API data")
        
        manager.loadDataFromURL(url: manager.encodeQueryParameters(with: "omelete")!) { (data, error) in
            
            guard error == nil else {
                XCTFail()
                return
            }
            
            manager.parsingData(recipies: [Recipe](), data: data!, completion: { (recipies, error) in
                
                guard error == nil else {
                    XCTFail()
                    return
                }
                
                let recipe = recipies?.first
                // on a real scenario this test may not be enough
                
                if let title: String? = recipe?.title,
                    let ingredients: String = recipe?.ingredients,
                    let url: String = recipe?.url,
                    let thumbnailUrl: String = recipe?.thumbnailUrl {
                    XCTAssertNotNil(title)
                    XCTAssertNotNil(ingredients)
                    XCTAssertNotNil(url)
                    XCTAssertNotNil(thumbnailUrl)
                } else {
                    XCTFail("missing value in objetct")
                }
                
                
                
                
                XCTAssert(true)
                expect.fulfill()
                
                
            })
            
            
            
        }
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
        
    }

    
}
