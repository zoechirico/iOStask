//
//  SQLite2Tests.swift
//  iOStaskTests
//
//  Created by Mike Chirico on 12/5/20.
//

import XCTest

class SQLite2Tests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSQLite2() throws {
        let db = SQLite2()
        db.open()
        db.create()
        
        let sql = """
            insert into t0 (data,num) values ("A longer text",3.34);
            
            """
        db.execute(sql: sql)
        
        let r = db.result()
        
        XCTAssertTrue(r.count >= 1)
        for (_ , item) in r.enumerated() {
            print("\(item.t1key),\t \(item.data), \(item.num), \(item.timeEnter)")
        }

        
        db.close()
        
        
        
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
