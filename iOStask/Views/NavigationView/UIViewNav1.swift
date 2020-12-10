//
//  UIViewNav1.swift
//  iOStask
//
//  Created by Mike Chirico on 12/10/20.
//

import SwiftUI

struct ListItem: Hashable  {
    let id = UUID()
    var num: Int64
    var title: String
    
}

extension ListItem: Identifiable { }

let Ldata = [
    ListItem(num: 1,title: "First"),
    ListItem(num: 2,title: "2nd")
]


struct UIViewNav1: View {
    @Binding var showModal:Bool

    @State var ml = Ldata
    var body: some View {
        
        NavigationView{
            List(ml) { item in
                NavigationLink(
                
                    destination: UIViewDetail1(),
                    label: {
                        Text(item.title)
                    }
                )
                
            }
        }
        
        
        
        Text("string: ")
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

struct UIViewNav1_Previews: PreviewProvider {
    static var previews: some View {
        UIViewNav1(showModal: .constant(true))
    }
}
