//
//  PhotoLibraryViewModel.swift
//  MVVM Refactoring
//
//  Created by Federico Agnello on 17/03/2026.
//

import Foundation
import Combine
import SwiftUI

@MainActor
final class PhotoLibraryViewModel: ObservableObject {
    @Published var photos: [Photo] = []

    private let storageKey = "photos"

    init() {
        load()
    }

    func load() {
        guard let data = UserDefaults.standard.data(forKey: storageKey) else {
            photos = Self.samplePhotos
            return
        }

        do {
            photos = try JSONDecoder().decode([Photo].self, from: data)
        } catch {
            print("Unable to decode (\(error))")
            photos = Self.samplePhotos
        }
    }

    func delete(at offsets: IndexSet) {
        photos.remove(atOffsets: offsets)
        save()
    }

    func save(photo: Photo, multiplyRed: Double, multiplyGreen: Double, multiplyBlue: Double, saturation: Double, contrast: Double) {
        if photo.original {
            let title = "\(photo.title)-\(Int.random(in: 1_000_000...9_999_999))"
            photos.append(
                Photo(
                    title: title,
                    file: photo.file,
                    multiplyRed: multiplyRed,
                    multiplyGreen: multiplyGreen,
                    multiplyBlue: multiplyBlue,
                    saturation: saturation,
                    contrast: contrast,
                    original: false
                )
            )
        } else if let index = photos.firstIndex(where: { $0.id == photo.id }) {
            photos[index].multiplyRed = multiplyRed
            photos[index].multiplyGreen = multiplyGreen
            photos[index].multiplyBlue = multiplyBlue
            photos[index].saturation = saturation
            photos[index].contrast = contrast
        }

        save()
    }

    private func save() {
        do {
            let data = try JSONEncoder().encode(photos)
            UserDefaults.standard.set(data, forKey: storageKey)
        } catch {
            print("Unable to save: (\(error))")
        }
    }

    private static let samplePhotos = [
        Photo(title: "Bari", file: "bari"),
        Photo(title: "Firenze", file: "firenze"),
        Photo(title: "Genova", file: "genova"),
        Photo(title: "Napoli", file: "napoli"),
        Photo(title: "Palermo", file: "palermo"),
        Photo(title: "Roma", file: "roma")
    ]
}