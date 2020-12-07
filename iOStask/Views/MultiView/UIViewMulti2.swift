//
//  UIViewMulti2.swift
//  iOStask
//
//  Created by Mike Chirico on 12/7/20.
//

import SwiftUI

struct UIViewMulti2: View {
    @Binding var showModal:Bool
    var body: some View {
        Text("multi2")
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

struct UIViewMulti2_Previews: PreviewProvider {
    static var previews: some View {
        UIViewMulti2(showModal: .constant(true))
    }
}
