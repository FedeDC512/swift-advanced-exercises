//
//  EmptyStateView.swift
//  MVVM Architecture
//
//  Created by Federico Agnello on 17/03/2026.
//

import SwiftUI

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "tray")
                .font(.system(size: 40))
            Text("Nessun task")
                .font(.headline)
            Text("Aggiungine uno o cambia filtro.")
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    EmptyStateView()
}
