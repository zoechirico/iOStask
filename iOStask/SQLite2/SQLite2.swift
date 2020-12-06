//
//  SQLite2.swift
//  iOStask
//
//  Created by Mike Chirico on 12/5/20.
//

import Foundation

import UIKit
import SQLite3

public struct S2Result {
    var t1key: Int64
    var data: String
    var num: Double
    var timeEnter: String
}


public class SQLite2 {
    var db: OpaquePointer?
    var file: String?
    
    public init(file: String = "test.sqlite") {
        self.file = file
    }
    
    public func open(_ file: String = "test.sqlite")  {
        
        if file != "test2.sqlite" {
            self.file = file
        }
        
        let documents = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let fileURL = documents.appendingPathComponent(self.file ?? file)
        
        if sqlite3_open(fileURL.path, &self.db) != SQLITE_OK {
            print("error opening database")
        }
        
    }
    
    public func close(_ db: OpaquePointer? = nil) {
        var db = db
        if db == nil {
            db = self.db
            if db == nil { return }
        }
        if sqlite3_close(db) != SQLITE_OK {
            print("error closing database")
        }
        db = nil
    }
    
    public func execute(sql: String) {
        if sqlite3_exec(self.db,
                        sql, nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("Error executing statement: \(errmsg)")
        }
    }
    
    
    public func create() {
        let sql = """

        CREATE TABLE IF NOT EXISTS t0 (t1key INTEGER
                  PRIMARY KEY,data text,num double,timeEnter DATE);

        CREATE TRIGGER IF NOT EXISTS insert_t0_timeEnter AFTER  INSERT ON t0
          BEGIN
            UPDATE t0 SET timeEnter = DATETIME('NOW')  WHERE rowid = new.rowid;
          END;

        """
        self.execute(sql: sql)
    }
    
    
    
    
    public func result() -> [S2Result]  {
        
        var statement: OpaquePointer?
        
        var results: [S2Result] = []
        
        
        if sqlite3_prepare_v2(db, "select t1key, data,num, timeEnter from t0;", -1, &statement, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("error preparing select: \(errmsg)")
        }
        
        
        while sqlite3_step(statement) == SQLITE_ROW {
            
            
            let queryResultCol0 = sqlite3_column_int64(statement, 0)
            let t1key = Int64(queryResultCol0)
            
            
            guard let queryResultCol1 = sqlite3_column_text(statement, 1) else {
                print("Query result is nil")
                return results
            }
            let data = String(cString: queryResultCol1)
            
            let num = sqlite3_column_double(statement, 2)
            
            guard let queryResultCol3 = sqlite3_column_text(statement, 3) else {
                print("Query result is nil")
                return results
            }
            let timeEnter = String(cString: queryResultCol3)
            
            results.append(S2Result(t1key: t1key, data: data, num: num, timeEnter: timeEnter))
            
        }
        if sqlite3_finalize(statement) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("error finalizing prepared statement: \(errmsg)")
        }
        statement = nil
        return results
    }
    
    
    
    
}
