//
//  EditingPhotoScreenViewModel.swift
//  Editing Photo
//
//  Created by mac on 19.05.25.
//

import SwiftUI

final class EditingPhotoViewModel: ObservableObject {
    @Published var image: Image
    
    init(image: Image) {
        self.image = image
    }
}
