//
//  CrownView.swift
//  watchOS Fundamentals
//
//  Created by Federico Agnello on 25/03/2026.
//

import SwiftUI

struct CrownView: View {
    @State private var number = 0.0

    var body: some View {
        VStack {
            Image(systemName: "minus.forwardslash.plus")
                .imageScale(.large)
                .foregroundStyle(.tint)
                .padding()
            Text("\(number, specifier: "%.1f")")
                .focusable()
                .digitalCrownRotation(
                    $number,
                    from: 0.0,
                    through: 12.0,
                    by: 0.1,
                    sensitivity: .high,
                    isContinuous: false,
                    isHapticFeedbackEnabled: true
                )
        }
        .padding()
    }
}

#Preview {
    CrownView()
}
