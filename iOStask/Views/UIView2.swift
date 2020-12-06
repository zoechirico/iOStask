//
//  UIView2.swift
//  iOStask
//
//  Created by Mike Chirico on 12/4/20.
//


import SwiftUI

// two





// END



struct RedMenu: MenuStyle {
    func makeBody(configuration: Configuration) -> some View {
        Menu(configuration)
            .foregroundColor(.red)
    }
}

struct UIView2: View {
    @State private var isSharePresented: Bool = false
    @Environment(\.presentationMode) var presentation
    
    var body: some View {
        
        
        
        
        NavigationView {
            
            
            
            Menu {
                Button("SQLite", action: {
                    
                    let sb = SqliteBroker()
                    sb.myStart()
                    print("file url: \(sb.getDatabaseFileURL()) ")
                    
                    
                    let textToShare = "SQLite Database"
                    let url = sb.getDatabaseFileURL()
                    let objectsToShare = [textToShare, url] as [Any]
                    
                    share(items: objectsToShare)
                })
                
                
                Button("Adjust Order", action: {print("a")})
                Menu("Advanced") {
                    Button("Rename", action: {print("r")})
                    Button("Delay", action: {print("s")})
                }
            } label: {
                VStack {
                    Label("Options", systemImage: "paperplane")
                    Text("stuff")
                    
                }
            }.padding()
            .navigationTitle("View2")
            .background(Color.red)
            .foregroundColor(Color.black)
            .cornerRadius(15)
            .shadow(radius: 15)
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    Button("Back") {
                        self.presentation.wrappedValue.dismiss()
                    }
                    
                    
                }
            }
            
            
        }
        
    }
}

struct UIView2_Previews: PreviewProvider {
    static var previews: some View {
        UIView2()
    }
}
