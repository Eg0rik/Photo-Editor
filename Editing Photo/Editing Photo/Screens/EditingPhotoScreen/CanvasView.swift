//
//  Test.swift
//  Editing Photo
//
//  Created by mac on 20.05.25.
//

import SwiftUI
import PencilKit

struct CanvasView: UIViewRepresentable {
    @Binding var drawing: PKDrawing
    @Binding var toolPickerVisible: Bool
    @Binding var canvasView: PKCanvasView
    
    private let toolPicker = PKToolPicker()

    func makeUIView(context: Context) -> PKCanvasView {
        canvasView.drawingPolicy = .anyInput
        canvasView.delegate = context.coordinator
        canvasView.backgroundColor = .clear
        
        toolPicker.setVisible(toolPickerVisible, forFirstResponder: canvasView)
        toolPicker.addObserver(canvasView)
        
        if toolPickerVisible {
            canvasView.becomeFirstResponder()
        }
        
        return canvasView
    }

    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        if drawing != uiView.drawing {
            uiView.drawing = drawing
        }
        
        toolPicker.setVisible(toolPickerVisible, forFirstResponder: canvasView)
        toolPicker.addObserver(canvasView)

        if toolPickerVisible {
            canvasView.becomeFirstResponder()
        } else {
            canvasView.resignFirstResponder()
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(drawing: $drawing)
    }

    class Coordinator: NSObject, PKCanvasViewDelegate {
        var drawing: Binding<PKDrawing>

        init(drawing: Binding<PKDrawing>) {
            self.drawing = drawing
        }

        func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
            DispatchQueue.main.async {
                self.drawing.wrappedValue = canvasView.drawing
            }
        }
    }
}

#Preview {
    RootView()
}

