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
        var sql = """
        CREATE TABLE IF NOT EXISTS t0 (t1key INTEGER
                  PRIMARY KEY,data TEXT,num double,timeEnter DATE);

        CREATE TRIGGER IF NOT EXISTS insert_t0_timeEnter AFTER  INSERT ON t0
          BEGIN
            UPDATE t0 SET timeEnter = DATETIME('NOW')  WHERE rowid = new.rowid;
          END;

        """
        db.execute(sql: sql)
        
        sql = """
            insert into t0 (data,num) values ('sample data',3);
            
            """
        db.execute(sql: sql)
        
        
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
