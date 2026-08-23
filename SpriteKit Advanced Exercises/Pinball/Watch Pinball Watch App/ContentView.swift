//
//  ContentView.swift
//  Watch Pinball Watch App
//
//  Created by Federico Agnello on 26/03/2026.
//

import SwiftUI
import SpriteKit

struct ContentView: View {
    @StateObject private var scene: GameScene = {
        let scene = SKScene(fileNamed: "GameScene") as! GameScene
        scene.scaleMode = .aspectFit
        return scene
    }()

    var body: some View {
        SpriteView(scene: scene)
            .edgesIgnoringSafeArea(.all)
            .onTapGesture {
                scene.shouldFlip = true
            }
    }
}

#Preview {
    ContentView()
}
