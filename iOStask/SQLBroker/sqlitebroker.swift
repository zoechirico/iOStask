//
//  SqliteBroker.swift
//  tv
//
//  Created by Michael Chirico on 9/29/18.
//  Copyright © 2018 Michael Chirico. All rights reserved.
//

/*
 
 References:
 https://www.raywenderlich.com/385-sqlite-with-swift-tutorial-getting-started
 
 */

import Foundation

import UIKit
import SQLite3

import HealthKit

public class SQLiteTest {
    var tableNames: [String]=[]
    
    func checkFile(file: String) -> Bool {
        var db: OpaquePointer?
        let documents = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let fileURL = documents.appendingPathComponent(file)
        
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error opening database")
            return false
        }
        
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, "SELECT name FROM sqlite_master WHERE type='table'", -1, &statement, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("error preparing select: \(errmsg)")
        }
        
        let cols = sqlite3_column_count(statement)
        
        while sqlite3_step(statement) == SQLITE_ROW {
            tableNames.removeAll()
            for i in 0..<cols {
                let queryResultColi = sqlite3_column_text(statement, i)
                if queryResultColi != nil {
                    let result = String(cString: queryResultColi!)
                    tableNames.append(result)
                }
            }
            print(tableNames)
        }
        if sqlite3_finalize(statement) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("error finalizing prepared statement: \(errmsg)")
        }
        
        statement = nil
        
        return true
    }
    
}

public class SqliteBroker {
    
    internal let SQLITE_STATIC = unsafeBitCast(0, to: sqlite3_destructor_type.self)
    internal let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
    
    // open database
    var db: OpaquePointer?
    var dbP2: OpaquePointer?
    var pBackup: OpaquePointer?
    
    public init() {}
    
    public func open(_ file: String = "test.sqlite") -> OpaquePointer {
        let documents = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let fileURL = documents.appendingPathComponent(file)
        
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error opening database")
        }
        return db!
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
    
    /*
     2016-10-19 06:39:53,58.0
     2016-10-19 06:56:57,52.0
     2016-10-19 07:03:30,51.0
     2016-10-19 07:06:17,52.0
     */
    
    public func exFileSQL(file: String, sql: String) {
        var db: OpaquePointer?
        
        let documents = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let fileURL = documents.appendingPathComponent(file)
        
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error opening database")
        }
        
        if sqlite3_exec(db,
                        sql, nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("Error executing statement: \(errmsg)")
        }
        
        self.close(db)
    }
    
    public func heartAdd(heartRateSamples: [HKQuantitySample]) {
        var db: OpaquePointer?
        
        let documents = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let fileURL = documents.appendingPathComponent("hr.sqlite")
        
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error opening database")
        }
        
        if sqlite3_exec(db,
                        "create table if not exists hr (d datetime, hr integer);", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("error creating table: \(errmsg)")
        }
        
        sqlite3_exec(db, "BEGIN TRANSACTION;", nil, nil, nil)
        
        let dfmt = DateFormatter()
        dfmt.dateFormat = "yyyy-MM-dd HH:mm:ss"
        for r in heartRateSamples {
            let result = r as HKQuantitySample
            let quantity = result.quantity
            let count = quantity.doubleValue(for: HKUnit(from: "count/min"))
            let sd = result.startDate
            
            let s = "insert into hr (d,hr) values('\(dfmt.string(from: sd ))',\(count));"
            
            if sqlite3_exec(db, s, nil, nil, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db))
                print("sqlite3_exec: \(errmsg)")
            }
        }
        
        sqlite3_exec(db, "END TRANSACTION;", nil, nil, nil)
        self.close(db)
        
    }
    
    // MARK: TESTING
    public func testAttach() {
        
        var db: OpaquePointer?
        var db2: OpaquePointer?
        
        if sqlite3_open(":memory:", &db) != SQLITE_OK {
            print("error opening database")
        }
        
        if sqlite3_exec(db,
                        "create table if not exists test (id integer primary key autoincrement, name text);", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("error creating table: \(errmsg)")
        }
        
        if sqlite3_exec(db,
                        "create table if not exists blobtest (des varchar(80),b blob);", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("error creating table: \(errmsg)")
        }
        
        if sqlite3_exec(db, "insert into test (name) values ('EXCELLENT!');", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("sqlite3_exec: \(errmsg)")
        }
        
        if sqlite3_exec(db, "insert into test (id,name) values (30,'Add!');", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("sqlite3_exec: \(errmsg)")
        }
        
        let documents = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let fileURL = documents.appendingPathComponent("test.sqlite")
        
        if sqlite3_open(fileURL.path, &db2) != SQLITE_OK {
            print("error opening database")
        }
        
        if sqlite3_exec(db, "attach database '\(fileURL)' as f;", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("error attaching: \(errmsg)")
        }
        
        var msql = "insert into f.test select a.id, a.name from test a left join f.test b on a.id=b.id  where b.id is NULL order by +a.rowid;"
        
        _ = self.sql(msql, db: db)
        
        msql = "update f.test set name = (select name from test b where b.id=f.test.id and b.name != f.test.name) where id = (select id from test b where b.id=f.test.id and b.name != f.test.name);"
        
        _ = self.sql(msql, db: db)
        
        msql = "insert into f.junk2 (a) values (30);"
        _ = self.sql(msql, db: db)
        
        msql = "insert into f.junk2 (a) values (33);"
        _ = self.sql(msql, db: db)
        
        //    if sqlite3_exec(db2, ".database", nil, nil, nil) != SQLITE_OK {
        //      let errmsg = String.fromCString(sqlite3_errmsg(db))
        //      print(".database: \(errmsg)")
        //    }
        
        let k = self.sql("PRAGMA database_list;", db: db)
        for i in k {
            print(i)
        }
        
        self.close(db)
        
    }
    
    // MARK: working with blobs
    
    public func insertBlob(_ d: String, n: Data) {
        // sqlite3_bind_blob(yourSavingSQLStatement, 2, [dataForImage bytes], [dataForImage length], SQLITE_TRANSIENT);
        
        _ = open("test.sqlite")
        
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, "insert into blobtest (des,b) values (?,?)", -1, &statement, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("error preparing insert: \(errmsg)")
        }
        
        if sqlite3_bind_text(statement, 1, d, -1, SQLITE_TRANSIENT) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("failure binding foo: \(errmsg)")
        }
        
        if sqlite3_bind_blob(statement, 2, (n as NSData).bytes, Int32(n.count), SQLITE_TRANSIENT) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("failure binding foo: \(errmsg)")
        }
        
        if sqlite3_step(statement) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("failure inserting foo: \(errmsg)")
        }
        
        if sqlite3_finalize(statement) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("error finalizing prepared statement: \(errmsg)")
        }
        
        close()
        print("end of insert blob")
        
    }
    
    public func memory() {
        if sqlite3_open(":memory:", &db) != SQLITE_OK {
            print("error opening database")
        }
        
        if sqlite3_exec(db, "create table if not exists test (id integer primary key autoincrement, name text)", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("error creating table: \(errmsg)")
        }
        
        if sqlite3_exec(db,
                        "create table if not exists blobtest (des varchar(80),b blob);", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("error creating table: \(errmsg)")
        }
        
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, "insert into test (name) values (?)", -1, &statement, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("error preparing insert: \(errmsg)")
        }
        
        if sqlite3_bind_text(statement, 1, "This was Memory", -1, SQLITE_TRANSIENT) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("failure binding foo: \(errmsg)")
        }
        
        if sqlite3_step(statement) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("failure inserting foo: \(errmsg)")
        } else {
            print("inserted")
        }
        
        if sqlite3_finalize(statement) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("error finalizing prepared statement: \(errmsg)")
        }
        
        statement = nil
        
        if sqlite3_prepare_v2(db, "select id, name from test", -1, &statement, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("error preparing select: \(errmsg)")
        }
        
        while sqlite3_step(statement) == SQLITE_ROW {
            let id = sqlite3_column_int64(statement, 0)
            print("id = \(id); ", terminator: "")
            
            let name = sqlite3_column_text(statement, 1)
            if name != nil {
                
                let nameString = String(cString: name!)
                
                // let nameString = String(cString: UnsafePointer<Int8>(name!))
                print("name = \(nameString)")
            } else {
                print("name not found")
            }
        }
        
        if sqlite3_finalize(statement) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("error finalizing prepared statement: \(errmsg)")
        }
        
        statement = nil
        
    }
    
    public func insertRec(_ sql: String) {
        
        if sqlite3_exec(db, sql, nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("error in insert: \(errmsg)")
        }
        listAll()
    }
    
    public func grabDatabase() -> Data? {
        let documents = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let fileURL = documents.appendingPathComponent("test.sqlite")
        
        // Maybe do with a guard
        do {
            let data = try Data(contentsOf: fileURL, options: .mappedIfSafe)
            return data
            
        } catch _ {
            print("Could not get data")
        }
        return nil
    }
    
    public func listAll() {
        print("listAll()")
        print("\n\n\n\n\n\n\n")
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, "select id, name from test", -1, &statement, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("error preparing select: \(errmsg)")
        }
        
        let cols = sqlite3_column_count(statement)
        
        while sqlite3_step(statement) == SQLITE_ROW {
            var row: [String]=[]
            for i in 0..<cols {
                let name = sqlite3_column_text(statement, i)
                
                if name != nil {
                    
                    let rawPointer = UnsafeRawPointer(name!)
                    let pointer = rawPointer.assumingMemoryBound(to: UInt8.self)
                    let nameString = String(pointer.pointee)
                    
                    //let nameString = String(cString: UnsafePointer<Int8>(name!))
                    row.append(nameString)
                }
            }
            print(row)
        }
        if sqlite3_finalize(statement) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("error finalizing prepared statement: \(errmsg)")
        }
        
        statement = nil
        
    }
    
    public func sqlBlob() -> [String: UIImage] {
        
        _ = self.open()
        
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, "select des,b from blobtest;", -1, &statement, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("error preparing select: \(errmsg)")
        }
        
        var result: [String: UIImage]=[:]
        var rowsD: String?
        var rowsB: Data?
        while sqlite3_step(statement) == SQLITE_ROW {
            
            let des = sqlite3_column_text(statement, 0)
            let len =  sqlite3_column_bytes(statement, 1)
            let blob = sqlite3_column_blob(statement, 1)
            
            if des != nil {
                
                let rawPointer = UnsafeRawPointer(des!)
                let pointer = rawPointer.assumingMemoryBound(to: UInt8.self)
                let descString = String(pointer.pointee)
                if blob != nil {
                    rowsD = descString
                    
                    let rawPointer = UnsafeRawPointer(blob!)
                    let pointer = rawPointer.assumingMemoryBound(to: UInt8.self)
                    //rowsB = Bytes(pointer.pointee)
                    rowsB = Data(bytes: pointer, count: Int(len))
                    
                    //rowsB = Data(bytes: UnsafePointer<UInt8>(blob), count: Int(len))
                    result[rowsD!] = UIImage(data: rowsB!)
                    
                }
                
            }
            
        }
        
        if sqlite3_finalize(statement) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("error finalizing prepared statement: \(errmsg)")
        }
        statement = nil
        self.close()
        
        return result
    }
    
    public func sql(_ sql: String, db: OpaquePointer? = nil) -> [[String]] {
        var db = db
        
        if db == nil { db = self.db }
        
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, sql, -1, &statement, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("error preparing select: \(errmsg)")
        }
        
        let cols = sqlite3_column_count(statement)
        
        var rows: [[String]]=[[]]
        
        while sqlite3_step(statement) == SQLITE_ROW {
            var row: [String]=[]
            for i in 0..<cols {
                let name = sqlite3_column_text(statement, i)
                
                if name != nil {
                    let rawPointer = UnsafeRawPointer(name!)
                    let pointer = rawPointer.assumingMemoryBound(to: UInt8.self)
                    let nameString = String(pointer.pointee)
                    
                    //let nameString = String(cString: UnsafePointer<Int8>(name!))
                    row.append(nameString)
                }
            }
            rows.append(row)
        }
        if sqlite3_finalize(statement) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("error finalizing prepared statement: \(errmsg)")
        }
        
        statement = nil
        return rows
        
    }
    
    public func writeDisk() {
        let documents = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let fileURL = documents.appendingPathComponent("test.sqlite")
        
        if sqlite3_open(fileURL.path, &dbP2) != SQLITE_OK {
            print("error opening database")
        }
        
        pBackup =  sqlite3_backup_init(dbP2, "main", db, "main")
        
        sqlite3_backup_step(pBackup, -1)
        sqlite3_backup_finish(pBackup)
        
    }
    
    /*
     Example Usage:
     
     see: sqliteTests.swift
     
     */
    public func sqlExe(file: String, stmt: String) {
        
        let documents = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let fileURL = documents.appendingPathComponent(file)
        
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error opening database")
        }
        
        if sqlite3_exec(db, stmt, nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("error on sqlite3_exec: \(errmsg)")
            print("stmt: \(stmt)")
        }
        
        if sqlite3_close(db) != SQLITE_OK {
            print("error closing database")
        }
        db = nil
    }
    
    struct Result {
        var id: Int
        var msg: String
        var row: Int
        var timeStamp: String
    }
    
    func sqlQuery(file: String, stmt: String) -> [Result] {
        var statement: OpaquePointer?
        
        let documents = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let fileURL = documents.appendingPathComponent(file)
        
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error opening database")
        }
        
        statement = nil
        
        if sqlite3_prepare_v2(db, stmt, -1, &statement, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("error preparing select: \(errmsg)")
        }
        
        var r = [Result]()
        
        while sqlite3_step(statement) == SQLITE_ROW {
            
            let id = sqlite3_column_int64(statement, 0)
            let msg = sqlite3_column_text(statement, 1)
            
            let row = sqlite3_column_int64(statement, 2)
            print("id = \(row); ", terminator: "")
            
            
            let timeStamp = sqlite3_column_text(statement, 3)
            
            if msg != nil && timeStamp != nil {
                
                let msgString = String(cString: msg!)
                let timeStampS = String(cString: timeStamp!)
                
                r.append(Result(id: Int(id), msg: msgString, row: Int(row), timeStamp: timeStampS))
                
                print("msg = \(msgString)")
                print("timeStamp = \(timeStampS)")
            } else {
                print("name not found")
            }
        }
        
        if sqlite3_finalize(statement) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("error finalizing prepared statement: \(errmsg)")
        }
        
        statement = nil
        
        if sqlite3_close(db) != SQLITE_OK {
            print("error closing database")
        }
        db = nil
        
        return r
    }
    
    public func myStart() {
        print("\n\n\nmyStart()\n\n\n\n")
        
        let documents = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let fileURL = documents.appendingPathComponent("test.sqlite")
        
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error opening database")
        }
        
        if sqlite3_exec(db, "create table if not exists test (id integer primary key autoincrement, name text)", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("error creating table: \(errmsg)")
        }
        
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, "insert into test (name) values (?)", -1, &statement, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("error preparing insert: \(errmsg)")
        }
        
        if sqlite3_bind_text(statement, 1, "This was disk", -1, SQLITE_TRANSIENT) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("failure binding foo: \(errmsg)")
        }
        
        if sqlite3_step(statement) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("failure inserting: \(errmsg)")
        }
        
        if sqlite3_finalize(statement) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("error finalizing prepared statement: \(errmsg)")
        }
        
        statement = nil
        
        if sqlite3_prepare_v2(db, "select id, name from test", -1, &statement, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("error preparing select: \(errmsg)")
        }
        
        while sqlite3_step(statement) == SQLITE_ROW {
            let id = sqlite3_column_int64(statement, 0)
            print("id = \(id); ", terminator: "")
            
            let name = sqlite3_column_text(statement, 1)
            if name != nil {
                let nameString = String(cString: name!)
                
                //let nameString = String(cString: UnsafePointer<Int8>(name!))
                print("name = \(nameString)")
            } else {
                print("name not found")
            }
        }
        
        if sqlite3_finalize(statement) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("error finalizing prepared statement: \(errmsg)")
        }
        
        statement = nil
        
        if sqlite3_close(db) != SQLITE_OK {
            print("error closing database")
        }
        
        db = nil
    }
    
    public func getDatabaseFileURL(database: String) -> URL {
        let documents = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let fileURL = documents.appendingPathComponent(database)
        
        return fileURL
    }
    
    public func getDatabaseFileURL() -> URL {
        let documents = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let fileURL = documents.appendingPathComponent("test.sqlite")
        
        return fileURL
        
        
    }
    
}
