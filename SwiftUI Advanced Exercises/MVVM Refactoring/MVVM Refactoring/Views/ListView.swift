//
//  ListView.swift
//  MVVM Refactoring
//
//  Created by Federico Agnello on 17/03/2026.
//

import SwiftUI

struct ListView: View {
    @ObservedObject var viewModel: PhotoLibraryViewModel
    
    var body: some View {
        NavigationStack {
            List {
                ForEach($viewModel.photos, id: \.id) { $photo in
                    NavigationLink(destination: DetailView(photo: $photo, viewModel: viewModel)) {
                        HStack {
                            Image(photo.file)
                                .resizable()
                                .cornerRadius(10)
                                .frame(width: 90, height: 90)
                            Text(photo.title)
                        }
                    }
                }
                .onDelete(perform: viewModel.delete)
            }
            .navigationTitle("Photos")
            .navigationBarTitleDisplayMode(.large)
            .scrollContentBackground(.hidden)
        }
    }
}

#Preview {
    ListView(viewModel: PhotoLibraryViewModel())
}

