//
//  UIViewMulti4.swift
//  iOStask
//
//  Created by Mike Chirico on 12/8/20.
//

import SwiftUI

struct UIViewMulti4: View {
    @Binding var showModal:Bool
    @Binding var s0:String
    var body: some View {
        Text("string: \(s0)")
        Button(action: {
            self.showModal=false
        }) {
            Text("Dismiss")
                .padding([.all],10)
                .background(Color.red)
                .foregroundColor(Color.yellow)
                .cornerRadius(15)
                .shadow(radius: 15)
        }
    }
}

struct UIViewMulti4_Previews: PreviewProvider {
    static var previews: some View {
        UIViewMulti4(showModal: .constant(true),s0: .constant(String("")))
    }
}
