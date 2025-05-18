//
//  RootView.swift
//  Editing Photo
//
//  Created by mac on 17.05.25.
//

import SwiftUI

struct CoordinatorView: View {
    @StateObject var coordinator = AppCoordinator()

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            coordinator.build(.auth)
            .navigationDestination(for: Screen.self) { screen in
                coordinator.build(screen)
            }
            .sheet(item: $coordinator.sheet) { sheet in
                coordinator.build(sheet)
            }
            .fullScreenCover(item: $coordinator.fullScreenCover) { fullScreenCover in
                coordinator.build(fullScreenCover)
            }
            .alert(coordinator.alertMessage?.title ?? "Error", isPresented: $coordinator.showAlert) {
                Button("Ok", role: .cancel) {
                    coordinator.alertMessage = nil
                }
            } message: {
                Text(coordinator.alertMessage?.message ?? "Something went wrong")
            }
            .environmentObject(coordinator)
        }
    }
}

#Preview {
    CoordinatorView()
}
