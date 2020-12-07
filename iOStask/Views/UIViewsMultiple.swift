//
//  UIViewsMultiple.swift
//  iOStask
//
//  Created by Mike Chirico on 12/7/20.
//

import SwiftUI

struct UIViewsMultiple: View {
    
    @Binding var showModal:Bool
    var body: some View {
        
        Button(action: {
            self.showModal=false
        }) {
            Text("Dismiss")
                .padding([.all],10)
                .background(Color.blue)
                .foregroundColor(Color.yellow)
                .cornerRadius(15)
                .shadow(radius: 15)
        }
    }
}

struct UIViewsMultiple_Previews: PreviewProvider {
    static var previews: some View {
        UIViewsMultiple(showModal: .constant(true))
    }
}
