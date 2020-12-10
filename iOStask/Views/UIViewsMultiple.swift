//
//  UIViewsMultiple.swift
//  iOStask
//
//  Created by Mike Chirico on 12/7/20.
//

import SwiftUI


var sample = "a string"

struct UIViewsMultiple: View {
    @State var showingMulti1 = false
    @State var showingMulti2 = false
    @State var showingMulti3 = false
    @State var showingMulti4 = false
    
    @State var showingNav1 = false
    
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
        
        
        
        Button(action: {
            self.showingMulti1=true
        }) {
            Text("Multi1")
                .padding([.all],10)
                .background(Color.blue)
                .foregroundColor(Color.yellow)
                .cornerRadius(15)
                .shadow(radius: 15)
        }.fullScreenCover(isPresented: $showingMulti1) {
            UIViewMulti1(showModal: $showingMulti1)
        }
        
        
        Button(action: {
            self.showingMulti2=true
        }) {
            Text("Multi2")
                .padding([.all],10)
                .background(Color.blue)
                .foregroundColor(Color.yellow)
                .cornerRadius(15)
                .shadow(radius: 15)
        }.fullScreenCover(isPresented: $showingMulti2) {
            UIViewMulti2(showModal: $showingMulti2)
        }
        
        Button(action: {
            self.showingMulti3=true
        }) {
            Text("Multi3")
                .padding([.all],10)
                .background(Color.yellow)
                .foregroundColor(Color.black)
                .cornerRadius(15)
                .shadow(radius: 15)
        }.fullScreenCover(isPresented: $showingMulti3) {
            UIViewMulti3(showModal: $showingMulti3)
        }
        
        Button(action: {
            self.showingMulti4=true
        }) {
            Text("Multi 4")
                .padding([.all],10)
                .background(Color.yellow)
                .foregroundColor(Color.black)
                .cornerRadius(15)
                .shadow(radius: 15)
        }.fullScreenCover(isPresented: $showingMulti3) {
            UIViewMulti4(showModal: $showingMulti4)
        }
        
        
        Button(action: {
            self.showingNav1=true
        }) {
            Text("Navigation View")
                .padding([.all],10)
                .background(Color.black)
                .foregroundColor(Color.white)
                .cornerRadius(15)
                .shadow(radius: 15)
        }.fullScreenCover(isPresented: $showingNav1) {
            UIViewNav1(showModal: $showingNav1)
        }
        
        
        
    }
}

struct UIViewsMultiple_Previews: PreviewProvider {
    static var previews: some View {
        UIViewsMultiple(showModal: .constant(true))
    }
}
