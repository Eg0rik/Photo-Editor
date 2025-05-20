//
//  PKCanvasView + Ex.swift
//  Editing Photo
//
//  Created by mac on 19.05.25.
//

import PencilKit

extension PKCanvasView {
    func renderCombinedImage(background: UIImage?) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: bounds.size)
        return renderer.image { context in
            background?.draw(in: bounds)
            drawing.image(from: bounds, scale: UIScreen.main.scale).draw(in: bounds)
        }
    }
}
