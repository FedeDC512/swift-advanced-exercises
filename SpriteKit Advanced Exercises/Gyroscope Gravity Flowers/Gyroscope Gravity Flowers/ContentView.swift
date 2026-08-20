//
//  ContentView.swift
//  Gyroscope Gravity Flowers
//
//  Created by Federico Agnello on 13/03/2026.
//

import SwiftUI
import SpriteKit

struct ContentView: View {
    var scene: SKScene {
        let scene = SKScene(fileNamed: "FlowerScene")
        scene!.size = CGSize(width: 750, height: 1334)
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
