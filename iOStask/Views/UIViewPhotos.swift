//
//  UIViewPhotos.swift
//  iOStask
//
//  Created by Mike Chirico on 12/6/20.
//

import SwiftUI

struct Record: Hashable {
    var id: Int64
    var title: String
    var image: UIImage
}



struct UIViewPhotos: View {
    
    @State var image:Image?
    @State var imageUI:UIImageView?
    @State var resultUIImage:UIImage?
    
    @State var recs:[Record]=[]
    
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
                
                ForEach(self.recs, id: \.self) { r in
                    
                    
                    VStack {
                        
                        Image(uiImage: r.image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200,height:200)
                            .background(Color.green)
                            .cornerRadius(15)
                            .shadow(radius: 15)
                        Text(r.title)
                            .padding([.leading,.trailing],20)
                            .padding([.top,.bottom],10)
                            .background(Color.black)
                            .foregroundColor(Color.yellow)
                            .cornerRadius(15)
                            .shadow(radius: 15)
                            .multilineTextAlignment(.center)
                        
                    }.frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                    .background(Color.gray.opacity(0.20))
                    .cornerRadius(5)
                    .padding(.bottom)
                    
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
                    let t = Record(id: rec.t1key, title: rec.data, image: UIImage(data: rec.image as Data)!)
                    recs.append( t)
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
