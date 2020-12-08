//
//  UIViewMulti1.swift
//  iOStask
//
//  Created by Mike Chirico on 12/7/20.
//

import SwiftUI

struct UIViewMulti1: View {
    @Binding var showModal:Bool
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        
        Button(action: {
            self.showModal=false
        }) {
            Text("Dismiss")
                .padding([.all],10)
                .background(Color.green)
                .foregroundColor(Color.yellow)
                .cornerRadius(15)
                .shadow(radius: 15)
        }
    }
}

struct UIViewMulti1_Previews: PreviewProvider {
    static var previews: some View {
        UIViewMulti1(showModal: .constant(true))
    }
}
