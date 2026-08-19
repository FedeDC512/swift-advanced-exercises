//
//  ModifiedView.swift
//  MVVM Refactoring
//
//  Created by Federico Agnello on 17/03/2026.
//

import SwiftUI

struct ModifiedView: View {
    @ObservedObject var viewModel: PhotoLibraryViewModel
    
    var body: some View {
        NavigationStack {
            List {
                ForEach($viewModel.photos, id: \.id) { $photo in
                    if !photo.original {
                        NavigationLink(destination: DetailView(photo: $photo, viewModel: viewModel)) {
                            HStack {
                                Image(photo.file)
                                    .resizable()
                                    .cornerRadius(10)
                                    .frame(width: 90, height: 90)
                                    .colorMultiply(Color(red: photo.multiplyRed, green: photo.multiplyGreen, blue: photo.multiplyBlue))
                                    .saturation(photo.saturation)
                                    .contrast(photo.contrast)
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
    ModifiedView(viewModel: PhotoLibraryViewModel())
}
