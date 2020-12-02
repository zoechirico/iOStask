//
//  URL_test.swift
//  iOStaskTests
//
//  Created by Mike Chirico on 12/2/20.
//

import XCTest

class URL_test: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    func testURL() throws {
            
            // Need to wait for an event. We'll create an expectation
            let exp = expectation(description: "Loading webpage")
            var data = ""
            
            let queue = OperationQueue()
            queue.addOperation {
                let sess = Session(url: "https://tasks.cwxstat.io/")
                sess.Get(){ result in
                    
                    DispatchQueue.main.async {
                        data = result
                        exp.fulfill()
                    }
                    
                } onFailure: {
                    print("Couldn't download the content.")
                }
                
                
            }

            wait(for: [exp], timeout: 3)
            XCTAssertTrue(data.contains("tacoMouse"),data)
            
            
        }

    
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
