//
//  model.swift
//  iOStask
//
//  Created by Mike Chirico on 12/6/20.
//
//import Foundation

import UIKit
public class DB {
    var r:[S2Result]?
    
    public func run() {
        let db = SQLite2(file: "iOStask.sqlite")
        
        db.open()
        db.execute(sql: "drop table t0;")
        db.create()
        
        guard let  image = db.img2(color1: UIColor.green,color2: UIColor.blue, size: CGSize(width: 20,height: 20)) else {
            print("Can't create image.")

            return
        }
        
        db.insert(data: "data a", image: image, num: 17.8)
        
        r = db.result()
        

        for (_ , item) in r!.enumerated() {
            print("\(item.t1key),\t \(item.data), \(item.num), \(item.timeEnter)")
        }
        
        db.close()
    }
}
