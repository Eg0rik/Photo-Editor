//
//  UploadYourPhotoScreenViewModel.swift
//  Editing Photo
//
//  Created by mac on 19.05.25.
//

import SwiftUI
import PhotosUI

final class UploadYourPhotoScreenViewModel: ObservableObject {
    @Published var uiImage: UIImage? = nil
    @Published private(set) var errorMessage: String? = nil
    
    @Published var imageSelection: PhotosPickerItem? = nil {
        didSet {
            if let imageSelection {
                loadImage(from: imageSelection)
            }
        }
    }
}

private extension UploadYourPhotoScreenViewModel {
    func loadImage(from imageSelection: PhotosPickerItem) {
        imageSelection.loadTransferable(type: Data.self) { result in
            DispatchQueue.main.async { [weak self] in
                guard let self, imageSelection == self.imageSelection else { return }
                
                switch result {
                    case .success(let data?):
                        uiImage = UIImage(data: data)
                        
                        if self.uiImage == nil {
                            self.errorMessage = "Не удалось создать изображение из данных"
                            return
                        }
                    case .success(.none):
                        self.uiImage = nil
                    case .failure(let error):
                        self.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
