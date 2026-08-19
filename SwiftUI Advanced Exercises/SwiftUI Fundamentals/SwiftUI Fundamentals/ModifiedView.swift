//
//  ModifiedView.swift
//  SwiftUI Fundamentals
//
//  Created by Federico Agnello on 09/03/2026.
//

import SwiftUI

struct ModifiedView: View {
    @Binding var photos: [Photo]
    
    var body: some View {
        NavigationStack{
            List{
                ForEach($photos, id: \.id){ $photo in
                    if !photo.original{
                        NavigationLink(destination: DetailView(photo:$photo, photos: $photos )){
                            HStack{
                                Image(photo.file)
                                    .resizable()
                                    .cornerRadius(10)
                                    .frame(width: 90, height: 90)
                                    .colorMultiply(Color(red: photo.multiplyRed, green: photo.multiplyGreen, blue: photo.multiplyBlue))
                                    .saturation(photo.saturation!)
                                    .contrast(photo.contrast!)
                                Text(photo.title)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Modified")
            .navigationBarTitleDisplayMode(.large)
            .scrollContentBackground(.hidden)
        }
    }
}

#Preview {
    ModifiedView(photos: .constant([Photo(title: "City Name", file: "city")]))
}
