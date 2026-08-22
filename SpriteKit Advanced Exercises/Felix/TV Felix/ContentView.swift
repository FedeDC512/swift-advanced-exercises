//
//  ContentView.swift
//  TV Felix
//
//  Created by Federico Agnello on 26/03/2026.
//

import SwiftUI
import SpriteKit

struct ContentView: View {
    var scene: SKScene {
        let scene = SKScene(fileNamed: "TV_Felix")
        scene!.size = CGSize(width: 1920, height: 1080)
        scene?.scaleMode = .aspectFit
        return scene!
    }
    
    
    var body: some View {
        SpriteView(scene: scene)
            .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    ContentView()
}
