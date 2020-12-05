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
    
    public init(file: String = "test2.sqlite") {
        self.file = file
    }
    
    public func open(_ file: String = "test2.sqlite")  {
        
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
    
    
    
    
}
