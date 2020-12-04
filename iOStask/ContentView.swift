//
//  ContentView.swift
//  iOStask
//
//  Created by Mike Chirico on 11/30/20.
//

import SwiftUI

struct ContentView: View {
    @State var txt0: String = "iOStask"
    @State var txt1: String = "Button"
    
    var body: some View {
        
        
        Button(action: {
            self.txt0 = "iOStask"
            self.txt1 = "BUTTON"
        }) {
            Text(self.txt0)
                .padding(.all,30)
                .padding([.top,.bottom],20)
                .background(Color.green)
                .foregroundColor(Color.black)
                .cornerRadius(5)
                .shadow(radius: 25)
                .font(Font.custom("Avenir-Black", size: 17))
        }
        
        
        
        Button(action: {
            self.txt0 = "* iOStask *"
            self.txt1 = "button"
        }) {
            Text(self.txt1)
                .padding([.leading,.trailing],20)
                .padding([.top,.bottom],10)
                .background(Color.red)
                .foregroundColor(Color.black)
                .cornerRadius(15)
                .shadow(radius: 15)
                .multilineTextAlignment(.center)
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
