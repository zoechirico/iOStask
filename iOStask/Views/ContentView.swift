//
//  ContentView.swift
//  iOStask
//
//  Created by Mike Chirico on 11/30/20.
//

import SwiftUI

struct ContentView: View {
    
    @State var showingView1 = false
    @State var showingView2 = false
    @State var showingSQLite = false
    @State var showingImages = false
    @State var showingPhotoSelect = false
    
    @State var txt0: String = "iOStask"
    @State var txt1: String = "Button"
    
    var body: some View {
        
        
        Button(action: {
            
            let sb = SqliteBroker()
            sb.myStart()
            print("file url: \(sb.getDatabaseFileURL()) ")
            
            
            let textToShare = "SQLite Database"
            let url = sb.getDatabaseFileURL()
            let objectsToShare = [textToShare, url] as [Any]
            
            iOStask.actionSheet(items: objectsToShare)
        }){
            Text("SQLite Send")
                .padding(.all,30)
                .padding([.top,.bottom],20)
                .background(Color.blue)
                .foregroundColor(Color.white)
                .cornerRadius(5)
                .shadow(radius: 25)
                .font(Font.custom("Avenir-Black", size: 27))
            
            
        }
        
        
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
            self.txt0 = " showingView1 \(self.showingView1)"
            self.txt1 = "button"
        }) {
            Text(self.txt0)
                .padding([.leading,.trailing],20)
                .padding([.top,.bottom],10)
                .background(Color.red)
                .foregroundColor(Color.black)
                .cornerRadius(15)
                .shadow(radius: 15)
                .multilineTextAlignment(.center)
            
        }
        
        HStack {
            
            
            Button(action: {
                self.showingImages=true
                
            }) {
                Text("Images View")
                    .padding([.leading,.trailing],20)
                    .padding([.top,.bottom],10)
                    .background(Color.yellow)
                    .foregroundColor(Color.black)
                    .cornerRadius(15)
                    .shadow(radius: 15)
                    .multilineTextAlignment(.center)
                
            }.sheet(isPresented: $showingImages) {
                UIViewImages()
            }
            
            
            
            
            Button(action: {
                self.showingPhotoSelect=true
                
            }) {
                Text("Photo Select View")
                    .padding([.leading,.trailing],20)
                    .padding([.top,.bottom],10)
                    .background(Color.yellow)
                    .foregroundColor(Color.black)
                    .cornerRadius(15)
                    .shadow(radius: 15)
                    .multilineTextAlignment(.center)
                
            }.sheet(isPresented: $showingPhotoSelect) {
                UIViewPhotos()
            }
            
            
            
            
            
            Button(action: {
                self.showingView1=true
                
            }) {
                Text("View 1")
                    .padding([.leading,.trailing],20)
                    .padding([.top,.bottom],10)
                    .background(Color.red)
                    .foregroundColor(Color.black)
                    .cornerRadius(15)
                    .shadow(radius: 15)
                    .multilineTextAlignment(.center)
                
            }.sheet(isPresented: $showingView1) {
                UIView1()
            }
            
            Button(action: {
                self.showingView2=true
                
            }) {
                Text("View 2")
                    .padding([.leading,.trailing],20)
                    .padding([.top,.bottom],10)
                    .background(Color.red)
                    .foregroundColor(Color.black)
                    .cornerRadius(15)
                    .shadow(radius: 15)
                    .multilineTextAlignment(.center)
                
            }.sheet(isPresented: $showingView2) {
                UIView2()
            }
            
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
