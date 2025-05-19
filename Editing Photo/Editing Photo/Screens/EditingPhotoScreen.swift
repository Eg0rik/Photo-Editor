//
//  EditingPhotoScreen.swift
//  Editing Photo
//
//  Created by mac on 19.05.25.
//

import SwiftUI

struct EditingPhotoScreen: View {
    @EnvironmentObject var appCoordinator: AppCoordinator
    @ObservedObject private var viewModel: EditingPhotoViewModel
    
    init(viewModel: EditingPhotoViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            viewModel.image
                .resizable()
                .scaledToFit()
                .frame(width: 300, height: 300)
        }
    }
}

#Preview {
    
}
