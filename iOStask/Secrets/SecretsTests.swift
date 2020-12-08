//
//  SecretsTests.swift
//  iOStaskTests
//
//  Created by Mike Chirico on 12/7/20.
//

import XCTest

class SecretsTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSecrets() throws {
        let db = Secrets()
        db.open("secret2.sqlite")
        db.execute(sql: "drop table if exists t0;")
        db.create()
        
        guard let  image = db.img(color: UIColor.green,size: CGSize(width: 20,height: 20)) else {
            print("Can't create image.")
            XCTAssertTrue(1==2)
            return
        }
        
        db.insert(data: "{secret: \"38Po2o2kka^bbmas\"}", image: image, num: 17.8)
        
        let r = db.result()
        
        XCTAssertTrue(r.count == 1)
        XCTAssertTrue(r[0].data == "{secret: \"38Po2o2kka^bbmas\"}")
        XCTAssertTrue(r[0].num == 17.8)
        
        print("\n\n  ----------  OUTPUT ------------ \n")
        for (_ , item) in r.enumerated() {
            print("\(item.t1key),\t \(item.data), \(item.num), \(item.timeEnter)")
        }
        print("\n\n  ----------    END  ------------ \n")
        
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
