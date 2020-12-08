//
//  UIViewMulti3.swift
//  iOStask
//
//  Created by Mike Chirico on 12/8/20.
//

import SwiftUI

struct UIViewMulti3: View {
    @Binding var showModal:Bool
    var body: some View {
        Text("multi3")
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

struct UIViewMulti3_Previews: PreviewProvider {
    static var previews: some View {
        UIViewMulti3(showModal: .constant(true))
    }
}
