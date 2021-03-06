//
//  Secrets.swift
//  iOStask
//
//  Created by Mike Chirico on 12/7/20.
//

//
//  SQLite2.swift
//  iOStask
//
//  Created by Mike Chirico on 12/5/20.
//

import Foundation

import UIKit
import SQLite3

public struct SecretResult {
    var t1key: Int64
    var data: String
    var num: Double
    var image: NSData
    var timeEnter: String
}


public class Secrets {
    
    internal let SQLITE_STATIC = unsafeBitCast(0, to: sqlite3_destructor_type.self)
    internal let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
    
    
    var db: OpaquePointer?
    var file: String?
    
    public init(file: String = "secret.sqlite") {
        self.file = file
    }
    
    public func open(_ file: String = "secret.sqlite")  {
        
        if file != "secret.sqlite" {
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
            print("\nError executing statement: \(errmsg)")
        }
    }
    
    
    public func create() {
        let sql = """

        CREATE TABLE IF NOT EXISTS t0 (t1key INTEGER
                  PRIMARY KEY,data text,image blob,num double,timeEnter DATE);

        CREATE TRIGGER IF NOT EXISTS insert_t0_timeEnter AFTER  INSERT ON t0
          BEGIN
            UPDATE t0 SET timeEnter = DATETIME('NOW')  WHERE rowid = new.rowid;
          END;

        """
        self.execute(sql: sql)
    }
    
    
    public func img(color: UIColor, size: CGSize) -> Data? {
        
        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: size.width, height: size.height))
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        
        return image.pngData()
        
        
    }
    
    public func img2(color1: UIColor, color2: UIColor, size: CGSize) -> Data? {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: size.width, height: size.height))
        let img = renderer.image { ctx in
            ctx.cgContext.setFillColor(color1.cgColor)
            ctx.cgContext.setStrokeColor(color2.cgColor)
            ctx.cgContext.setLineWidth(10)
            
            let rectangle = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            ctx.cgContext.addEllipse(in: rectangle)
            ctx.cgContext.drawPath(using: .fillStroke)
        }
        return img.pngData()
    }
    
    
    
    
    public func insert(data: String, image: Data, num: Double){
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, "insert into t0 (data,image,num) values (?,?,?)", -1, &statement, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("error preparing insert: \(errmsg)")
        }
        
        if sqlite3_bind_text(statement, 1, data, -1, SQLITE_TRANSIENT) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("failure binding foo: \(errmsg)")
        }
        
        if sqlite3_bind_blob(statement, 2, (image as NSData).bytes, Int32(image.count), SQLITE_TRANSIENT) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("failure binding foo: \(errmsg)")
        }
        
        if sqlite3_bind_double(statement, 3, num) != SQLITE_OK {
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
        
    }
    
    
    
    public func result() -> [SecretResult]  {
        
        var statement: OpaquePointer?
        
        var results: [SecretResult] = []
        
        
        if sqlite3_prepare_v2(db, "select t1key,data,image,num,timeEnter from t0;", -1, &statement, nil) != SQLITE_OK {
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
            
            let len = sqlite3_column_bytes(statement, 2)
            let point = sqlite3_column_blob(statement, 2)
            if point == nil {
                return results
            }
            let image = NSData(bytes: point, length: Int(len))
            
            
            let num = sqlite3_column_double(statement, 3)
            
            guard let queryResultCol4 = sqlite3_column_text(statement, 4) else {
                print("Query result is nil")
                return results
            }
            let timeEnter = String(cString: queryResultCol4)
            
            results.append(SecretResult(t1key: t1key, data: data, num: num,image: image, timeEnter: timeEnter))
            
        }
        if sqlite3_finalize(statement) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("error finalizing prepared statement: \(errmsg)")
        }
        statement = nil
        return results
    }
    
    
    
    
}

