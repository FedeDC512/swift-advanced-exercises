//
//  ContentView.swift
//  Missile
//
//  Created by Federico Agnello on 01/04/26.
//

import SwiftUI
import RealityKit

struct ContentView : View {
    @State private var missileEntity: Entity?
    @State private var fireEntity: Entity?
    @State private var hasLaunched = false

    var body: some View {
        RealityView { content in

            // Load 3D models
            if let missile = try? await Entity(named: "Missile"),
                let fire = try? await Entity(named: "Fire_Animation") {
                    
                    // Scale the models
                    missile.scale = [0.003, 0.003, 0.003]
                    fire.scale = [0.5, 0.5, 0.5]
                    
                    fire.position = [0, -130, 0]
                    fire.orientation = simd_quatf(angle: .pi, axis: [1, 0, 0])
                    
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
            if let missile = missileEntity, let fire = fireEntity {
                if !hasLaunched {
                    hasLaunched = true
                    missile.addChild(fire)
                    
                    if let fireAnimation = fire.availableAnimations.first {
                        fire.playAnimation(fireAnimation.repeat())
                    }
                }
            
                var newTransform = missile.transform
                newTransform.translation += [0, 2, 0]
                    
                missile.move(
                    to: newTransform,
                    relativeTo: missile.parent,
                    duration: 2.0
                )
            }
        }
    }

}

#Preview {
    ContentView()
}
