//
//  SQLite2.swift
//  iOStask
//
//  Created by Mike Chirico on 12/5/20.
//

import Foundation

import UIKit
import SQLite3

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
    
    public func result()  {
        
        var statement: OpaquePointer?
        
        
        if sqlite3_prepare_v2(db, "select data,timeEnter,t1key from t0;", -1, &statement, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("error preparing select: \(errmsg)")
        }
        
        
        while sqlite3_step(statement) == SQLITE_ROW {
            
            
            guard let queryResultCol0 = sqlite3_column_text(statement, 0) else {
                print("Query result is nil")
                return
            }
            let data = String(cString: queryResultCol0)
            
            
            guard let queryResultCol1 = sqlite3_column_text(statement, 1) else {
                print("Query result is nil")
                return
            }
            let timeEnter = String(cString: queryResultCol1)
            
            
            let queryResultCol3 = sqlite3_column_int64(statement, 2)
            let t1key = Int64(queryResultCol3)

            
            print("result: \(data), \(timeEnter), \(t1key)\n")
            
            
        }
        if sqlite3_finalize(statement) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("error finalizing prepared statement: \(errmsg)")
        }
        statement = nil
    }
    
    
    
    
}
