//
//  Routre.swift
//  Editing Photo
//
//  Created by mac on 17.05.25.
//

import SwiftUI
import FirebaseAuth

class AppCoordinator: ObservableObject {
    var alertMessage: AlertMessage? = nil
    
    @Published var rootScreen: Screen = .auth
    @Published var path: NavigationPath = NavigationPath()
    @Published var sheet: Screen?
    @Published var fullScreenCover: Screen?
    @Published var showAlert = false
    
    init() {
        if let _ = Auth.auth().currentUser {
            rootScreen = .uploadYourPhoto
        } else {
            rootScreen = .auth
        }
    }
    
    func getRootView() -> some View {
        build(rootScreen)
    }
    
    func push(_ screen: Screen) {
        path.append(screen)
    }
    
    func presentSheet(_ sheet: Screen) {
        self.sheet = sheet
    }
    
    func setRoot(_ screen: Screen) {
        rootScreen = screen
        path.removeLast(path.count)
    }
    
    func presentFullScreenCover(_ fullScreenCover: Screen) {
        self.fullScreenCover = fullScreenCover
    }
    
    func pop() {
        path.removeLast()
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
    
    func dismissSheet() {
        self.sheet = nil
    }
    
    func dismissFullScreenOver() {
        self.fullScreenCover = nil
    }
    
    func showAlert(title: String, message: String) {
        alertMessage = AlertMessage(title: title, message: message)
        showAlert = true
    }
    
    @ViewBuilder
    func build(_ route: Screen) -> some View {
        switch route {
            case .auth: AuthScreen()
            case .forgetPassword: ForgetPasswordScreen()
            case .uploadYourPhoto: UploadYourPhotoScreen()
            case .editingPhoto(let image): EditingPhotoScreen(uiImage: image)
        }
    }
}
