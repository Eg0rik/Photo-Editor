//
//  PKDrawing + Ext.swift
//  Editing Photo
//
//  Created by mac on 19.05.25.
//

import UIKit
import PencilKit
import SwiftUI

extension PKDrawing {
    func saveToPhotoLibrary() {
        let uiImage = self.image(from: self.bounds, scale: 1)
        UIImageWriteToSavedPhotosAlbum(uiImage, nil, nil, nil)
    }
    
    func saveToPhotoLibrary(_ uiImage: UIImage) {
        UIImageWriteToSavedPhotosAlbum(uiImage, nil, nil, nil)
    }
    
    func image() -> Image {
        let uiImage = self.image(from: self.bounds, scale: 1)
        return Image(uiImage: uiImage)
    }
}
