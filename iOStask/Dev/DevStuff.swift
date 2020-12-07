//
//  DevStuff.swift
//  iOStask
//
//  Created by Mike Chirico on 12/7/20.
//

import Foundation

protocol NameSetup {
    var Name: String{get}
}


struct Thingy: NameSetup {
    var Name: String
    
    
}

func M(n: NameSetup) {
    print("test: \(n.Name)")
}

class StepCounter {
    var totalSteps: Int = 0 {
        willSet(newTotalSteps) {
            print("About to set totalSteps to \(newTotalSteps)")
        }
        didSet {
            if totalSteps > oldValue  {
                print("Added \(totalSteps - oldValue) steps")
            }
        }
    }
}
