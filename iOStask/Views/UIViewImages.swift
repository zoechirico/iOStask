//
//  UIViewImages.swift
//  iOStask
//
//  Created by Mike Chirico on 12/6/20.
//

import SwiftUI

struct UIViewImages: View {
    @State var image:UIImage?
    
    
    var body: some View {
        
        if let image = image {
            Image(uiImage: image)
                .frame(width: 200, height: 300)
                .aspectRatio(contentMode: ContentMode.fit)
        }
        Text("images")
        Button(action: {
            let m = DB()
            m.run()
            self.image  = UIImage(data: m.r![0].image as Data)!
            
        }) {
            Text("Button")
                .padding([.leading,.trailing],20)
                .padding([.top,.bottom],10)
                .background(Color.yellow)
                .foregroundColor(Color.black)
                .cornerRadius(15)
                .shadow(radius: 15)
                .multilineTextAlignment(.center)
            
        }
        
        
    }
}

struct UIViewImages_Previews: PreviewProvider {
    static var previews: some View {
        UIViewImages()
    }
}
