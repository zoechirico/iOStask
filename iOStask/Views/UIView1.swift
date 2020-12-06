//
//  UIView1.swift
//  iOStask
//
//  Created by Mike Chirico on 12/4/20.
//

import SwiftUI

struct CustomStyle0: ViewModifier {
    func body(content: Content) -> some View {
        return content
            .padding([.top,.bottom,.leading],10)
            .padding([.trailing],14)
            .background(Color.blue)
            .foregroundColor(Color.yellow)
            .cornerRadius(15)
            .shadow(radius: 15)
            .font(Font.custom("Avenir-Black", size: 17))
        
    }
}

var dateFormatter: DateFormatter {
    let formatter = DateFormatter()
    formatter.dateStyle = .long
    return formatter
}

struct UIView1: View {
    @State var stepper = 0
    @State var sliderValue: Double = 30
    @State private var date = Date()
    
    var body: some View {
        
        
        
        
        VStack {
            
            DatePicker(selection: $date, label: { /*@START_MENU_TOKEN@*/Text("Date")/*@END_MENU_TOKEN@*/ })
            
            
            Slider(value: self.$sliderValue, in: 1...100)
            
            Stepper(value: $stepper, in: 0...100) {
                Text("Count \(self.stepper)").modifier(CustomStyle0())
                
            }
        }
        VStack {
            Text("View 1: \(self.sliderValue)  ")
            
            Text(" \(self.date, formatter: dateFormatter) ")
        }
        
    }
}

struct UIView1_Previews: PreviewProvider {
    static var previews: some View {
        UIView1()
    }
}
