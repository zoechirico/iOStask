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
        
        
        
        if let image = resultUIImage {
            Image(uiImage: image)
                .frame(width: 200, height: 300)
                .aspectRatio(contentMode: ContentMode.fit)
        }
        
        
        Text("Select Photo")
        
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

struct UIViewPhotos_Previews: PreviewProvider {
    static var previews: some View {
        UIViewPhotos()
    }
}
