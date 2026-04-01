//
//  ContentView.swift
//  Missile
//
//  Created by Federico Agnello on 01/04/26.
//

import SwiftUI
import RealityKit
import AVFoundation

struct ContentView : View {
    @State private var missileEntity: Entity?
    @State private var fireEntity: Entity?
    @State private var hornPlayer: AVAudioPlayer?
    @State private var isMoving = false

    private func playHorn() {
        guard let url = Bundle.main.url(forResource: "clacson", withExtension: "mp3") else { return }

        do {
            let player = try AVAudioPlayer(contentsOf: url)
            player.numberOfLoops = 0
            player.play()
            hornPlayer = player
        } catch {
            // Keep logic simple: ignore playback errors.
        }
    }

    var body: some View {
        RealityView { content in

            // Load 3D models
            if let missile = try? await Entity(named: "Cartoon_Low_Poly_Car"),
                let fire = try? await Entity(named: "Fire_Animation") {
                    
                    // Scale the models
                    missile.scale = [0.003, 0.003, 0.003]
                    fire.scale = [0.5, 0.5, 0.5]
                    
                    fire.position = [0, 10, 200]
                    fire.orientation = simd_quatf(angle: .pi/2, axis: [1, 0, 0])
                    
                    // Create anchor on horizontal plane
                    let anchor = AnchorEntity(.plane(.horizontal, classification: .any, minimumBounds: SIMD2<Float>(0.2, 0.2)))
                    
                    // Attach model to anchor
                    anchor.addChild(missile)
                    
                    // Add to scene
                    content.add(anchor)
                    
                    content.camera = .spatialTracking
                    
                    // Entity state for gesture
                    missileEntity = missile
                    fireEntity = fire
                    
                    // Add collision to track tap
                    missile.generateCollisionShapes(recursive: true)
            }

        }
        .edgesIgnoringSafeArea(.all)
        .onTapGesture{ // Gesture SwiftUI on RealityView
            playHorn()

            if let missile = missileEntity, let fire = fireEntity {
                if isMoving { return }
                isMoving = true

                if fire.parent == nil {
                    missile.addChild(fire)
                }

                if let fireAnimation = fire.availableAnimations.first {
                    fire.playAnimation(fireAnimation.repeat())
                }
            
                var newTransform = missile.transform
                newTransform.translation += [0, 0, -2]
                    
                missile.move(
                    to: newTransform,
                    relativeTo: missile.parent,
                    duration: 2.0
                )

                Task {
                    try? await Task.sleep(nanoseconds: 1_500_000_000)
                    fire.stopAllAnimations()
                    fire.removeFromParent()
                    isMoving = false
                }
            }
        }
    }

}

#Preview {
    ContentView()
}
