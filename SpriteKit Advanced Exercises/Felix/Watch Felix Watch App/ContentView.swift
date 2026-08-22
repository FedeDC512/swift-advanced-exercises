//
//  ContentView.swift
//  Watch Felix Watch App
//
//  Created by Federico Agnello on 26/03/2026.
//

import SwiftUI
import SpriteKit

import SwiftUI
import SpriteKit

struct ContentView: View {
    @State private var scene: Watch_Felix = {
        let scene = Watch_Felix(fileNamed: "Watch_Felix")!
        scene.size = CGSize(width: 416, height: 496) // Apple Watch Series 11 46mm
        scene.scaleMode = .aspectFit
        return scene
    }()
    @State private var sceneVersion = UUID()

    var body: some View {
        SpriteView(scene: scene)
            .id(sceneVersion)
            .edgesIgnoringSafeArea(.all)
            .onTapGesture {
                if scene.gameEnded {
                    let newScene = Watch_Felix(fileNamed: "Watch_Felix")!
                    newScene.size = CGSize(width: 416, height: 496)
                    newScene.scaleMode = .aspectFit
                    scene = newScene
                    sceneVersion = UUID()
                } else {
                    scene.shouldJump = true
                }
            }
    }
}

#Preview {
    ContentView()
}
