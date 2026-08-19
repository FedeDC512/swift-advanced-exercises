//
//  ModalView.swift
//  SwiftUI Navigation
//
//  Created by Federico Agnello on 17/03/2026.
//

import SwiftUI

struct ModalView: View {

    @State private var showSheet = false
    @State private var showFullScreen = false

    var body: some View {
        VStack(spacing: 30) {

            Button("Open Sheet") {
                showSheet = true
            }

            Button("Open Full Screen") {
                showFullScreen = true
            }
        }
        .sheet(isPresented: $showSheet) {
            SheetView()
        }
        .fullScreenCover(isPresented: $showFullScreen) {
            FullScreenView()
        }
    }
}

struct SheetView: View {
    var body: some View {
        VStack {
            Text("This is a Sheet")
                .font(.title)
        }
    }
}

struct FullScreenView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var step: Int = 1
    private let totalSteps = 3

    var body: some View {
        // Uso NavigationStack per il titolo e per la toolbar
        NavigationStack {
            VStack(spacing: 24) {
                Text("Wizard step \(step) of \(totalSteps)")
                    .font(.headline)

                Group {
                    switch step {
                    case 1:
                        StepView(
                            title: "Benvenuto",
                            subtitle: "Introduzione al wizard",
                            imageSystemName: "sparkles",
                            description: "Benvenuto nella nostra app! In pochi passaggi ti guideremo alla configurazione iniziale. Scopri le funzionalità principali e personalizza l'esperienza secondo le tue esigenze."
                        )
                    case 2:
                        StepView(
                            title: "Dettagli",
                            subtitle: "Configura alcune opzioni",
                            imageSystemName: "slider.horizontal.3",
                            description: "Scegli le preferenze che meglio si adattano al tuo modo d'uso. Potrai sempre modificarle in seguito dalle impostazioni."
                        )
                    case 3:
                        StepView(
                            title: "Conferma",
                            subtitle: "Rivedi e conferma le scelte",
                            imageSystemName: "checkmark.seal",
                            description: "Controlla il riepilogo e conferma per completare l'onboarding. Sei pronto a iniziare!"
                        )
                    default:
                        EmptyView()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)

                HStack {
                    Button("Indietro") {
                        withAnimation { step = max(1, step - 1) }
                    }
                    .disabled(step == 1)

                    Spacer()

                    if step < totalSteps {
                        Button("Avanti") {
                            withAnimation { step = min(totalSteps, step + 1) }
                        }
                    } else {
                        Button("Fine") {
                            dismiss()
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
                .padding(.top, 8)
            }
            .padding()
            .navigationTitle("Full Screen Wizard")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Chiudi") { dismiss() }
                }
            }
        }
    }
}
private struct StepView: View {
    let title: String
    let subtitle: String
    let imageSystemName: String
    let description: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .center, spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(.blue.opacity(0.12))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .stroke(.blue.opacity(0.25), lineWidth: 1)
                        )
                    Image(systemName: imageSystemName)
                        .resizable()
                        .scaledToFit()
                        .symbolRenderingMode(.hierarchical)
                        .foregroundStyle(.blue)
                        .padding(16)
                }
                .frame(width: 84, height: 84)

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.title2.weight(.semibold))
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }

            Text(description)
                .font(.body)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)

            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.gray.opacity(0.12))
                .overlay(
                    VStack(spacing: 8) {
                        Image(systemName: imageSystemName)
                            .symbolRenderingMode(.monochrome)
                            .foregroundStyle(.secondary)
                            .font(.system(size: 28, weight: .regular))
                        Text("Anteprima del contenuto dello step")
                            .foregroundStyle(.secondary)
                            .font(.subheadline)
                    }
                )
                .frame(height: 180)
                .padding(.top, 8)
        }
    }
}

#Preview {
    ModalView()
}
