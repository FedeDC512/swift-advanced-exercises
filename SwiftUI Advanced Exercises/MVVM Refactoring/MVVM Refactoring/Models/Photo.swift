//
//  Photo.swift
//  MVVM Refactoring
//
//  Created by Federico Agnello on 17/03/2026.
//

import Foundation

struct Photo: Identifiable, Codable, Equatable {
    let id: UUID
    var title: String
    var file: String
    var multiplyRed: Double
    var multiplyGreen: Double
    var multiplyBlue: Double
    var saturation: Double
    var contrast: Double
    var original: Bool

    init(
        id: UUID = UUID(),
        title: String,
        file: String,
        multiplyRed: Double = 1.0,
        multiplyGreen: Double = 1.0,
        multiplyBlue: Double = 1.0,
        saturation: Double = 1.0,
        contrast: Double = 1.0,
        original: Bool = true
    ) {
        self.id = id
        self.title = title
        self.file = file
        self.multiplyRed = multiplyRed
        self.multiplyGreen = multiplyGreen
        self.multiplyBlue = multiplyBlue
        self.saturation = saturation
        self.contrast = contrast
        self.original = original
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decodeIfPresent(UUID.self, forKey: .id) ?? UUID()
        title = try container.decode(String.self, forKey: .title)
        file = try container.decode(String.self, forKey: .file)
        multiplyRed = try container.decodeIfPresent(Double.self, forKey: .multiplyRed) ?? 1.0
        multiplyGreen = try container.decodeIfPresent(Double.self, forKey: .multiplyGreen) ?? 1.0
        multiplyBlue = try container.decodeIfPresent(Double.self, forKey: .multiplyBlue) ?? 1.0
        saturation = try container.decodeIfPresent(Double.self, forKey: .saturation) ?? 1.0
        contrast = try container.decodeIfPresent(Double.self, forKey: .contrast) ?? 1.0
        original = try container.decodeIfPresent(Bool.self, forKey: .original) ?? true
    }
}