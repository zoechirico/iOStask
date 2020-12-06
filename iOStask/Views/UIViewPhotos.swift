//
//  UIViewPhotos.swift
//  iOStask
//
//  Created by Mike Chirico on 12/6/20.
//

import SwiftUI

struct UIViewPhotos: View {
    
    @State var image:Image?
    @State var imageUI:UIImageView?
    @State var resultUIImage:UIImage?
    
    @State var recs:[UIImage]=[]
    
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    
    func loadImage() {
        
        
        let db = DB()
        if let png = inputImage?.pngData() {
            
            db.completeImage(png: png)
            self.resultUIImage  = UIImage(data: db.r![0].image as Data)!
        }
        
    }
    
    
    var body: some View {
        
        ScrollView(.horizontal){
            LazyHStack{
                
                ForEach(self.recs, id: \.self) {
                    Image(uiImage: $0)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300,height:300)
                        .shadow(radius: 15)
                }
                
                
            }
        }
        
        Text("Select Photo")
        
        
        
        VStack {
            
            Button(action: {
                let db = DB()
                db.Delete(file: "iOStask.sqlite")
                self.recs.removeAll()
            }) {
                Text("Delete All")
                    .padding([.leading,.trailing],20)
                    .padding([.top,.bottom],10)
                    .background(Color.red)
                    .foregroundColor(Color.yellow)
                    .cornerRadius(15)
                    .shadow(radius: 15)
                    .multilineTextAlignment(.center)
                
            }
            
            
            Button(action: {
                let db = DB()
                let r = db.GetResults(file: "iOStask.sqlite")
                self.recs.removeAll()
                for rec in r! {
                    recs.append( UIImage(data: rec.image as Data)!)
                }
                
            }) {
                Text("Show Images from Database")
                    .padding([.leading,.trailing],20)
                    .padding([.top,.bottom],10)
                    .background(Color.yellow)
                    .foregroundColor(Color.black)
                    .cornerRadius(15)
                    .shadow(radius: 15)
                    .multilineTextAlignment(.center)
                
            }
            
            Button(action: {
                self.showingImagePicker=true
                
            }) {
                Text("Select Image")
                    .padding([.leading,.trailing],20)
                    .padding([.top,.bottom],10)
                    .background(Color.yellow)
                    .foregroundColor(Color.black)
                    .cornerRadius(15)
                    .shadow(radius: 15)
                    .multilineTextAlignment(.center)
                
            }.sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                ImagePicker(image: self.$inputImage)
            }
            
        }
    }
}

struct UIViewPhotos_Previews: PreviewProvider {
    static var previews: some View {
        UIViewPhotos()
    }
}