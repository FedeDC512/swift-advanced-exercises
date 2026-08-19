//
//  DetailView.swift
//  MVVM Refactoring
//
//  Created by Federico Agnello on 17/03/2026.
//

import SwiftUI

struct DetailView: View {
    @Binding var photo: Photo
    @ObservedObject var viewModel: PhotoLibraryViewModel
    @State private var multiplyRed = 1.0
    @State private var multiplyGreen = 1.0
    @State private var multiplyBlue = 1.0
    @State private var saturation = 1.0
    @State private var contrast = 1.0
    
    var body: some View {
        ScrollView {
            VStack {
                TextField("Title", text: $photo.title)
                    .font(.system(size: 30))
                    .multilineTextAlignment(.center)
                    .padding()
                Image(photo.file)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .colorMultiply(Color(red: multiplyRed, green: multiplyGreen, blue: multiplyBlue))
                    .saturation(saturation)
                    .contrast(contrast)
                HStack {
                    Button(action: {
                        multiplyRed = 1
                        multiplyGreen = 0
                        multiplyBlue = 0
                    }){
                        Image("flower")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 80, height: 80)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .colorMultiply(.red)
                    }.padding()
                    Button(action: {
                        multiplyRed = 0
                        multiplyGreen = 1
                        multiplyBlue = 0
                    }){
                        Image("flower")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 80, height: 80)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .colorMultiply(.green)
                    }.padding()
                    Button(action: {
                        multiplyRed = 0
                        multiplyGreen = 0
                        multiplyBlue = 1
                    }){
                        Image("flower")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 80, height: 80)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .colorMultiply(.blue)
                    }.padding()
                }
                VStack {
                    Text("Saturation")
                    Slider(value: $saturation, in: -5...7)
                        .padding([.bottom,.leading,.trailing])
                        .accentColor(.gray)
                    Text("Contrast")
                    Slider(value: $contrast, in: -5...7)
                        .padding([.bottom,.leading,.trailing])
                        .accentColor(.gray)
                }
                HStack {
                    Button(action: {
                        multiplyRed = 1
                        multiplyGreen = 1
                        multiplyBlue = 1
                        saturation = 1
                        contrast = 1
                    }){
                        Image(systemName: "gobackward")
                            .foregroundColor(.black)
                            .font(.system(size:35))
                    }.padding()
                        .background(Color(.systemGray3))
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .padding()
                }
                Spacer()
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    viewModel.save(
                        photo: photo,
                        multiplyRed: multiplyRed,
                        multiplyGreen: multiplyGreen,
                        multiplyBlue: multiplyBlue,
                        saturation: saturation,
                        contrast: contrast
                    )
                }, label: {
                    Text("Save")
                })
            }
        }
        .onAppear {
            self.multiplyRed = photo.multiplyRed
            self.multiplyGreen = photo.multiplyGreen
            self.multiplyBlue = photo.multiplyBlue
            self.saturation = photo.saturation
            self.contrast = photo.contrast
        }
    }

}


#Preview {
    DetailView(photo: .constant(Photo(title: "City Name", file: "city")), viewModel: PhotoLibraryViewModel())
}
