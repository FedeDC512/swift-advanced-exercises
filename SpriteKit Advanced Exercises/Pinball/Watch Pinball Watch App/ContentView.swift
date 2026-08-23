//
//  ContentView.swift
//  Watch Pinball Watch App
//
//  Created by Federico Agnello on 26/03/2026.
//

import SwiftUI
import SpriteKit

struct ContentView: View {
    var scene: SKScene {
        let scene = SKScene(fileNamed: "GameScene")
        scene!.size = CGSize(width: 416, height: 496) // Apple Watch Series 11 46mm
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
