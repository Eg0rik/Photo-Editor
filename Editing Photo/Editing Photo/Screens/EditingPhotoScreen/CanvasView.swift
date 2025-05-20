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
    @Binding var currentToolPanel: ToolPanelType
    @Binding var canvasView: PKCanvasView
    
    private let toolPicker = PKToolPicker()
    
    private var isDrawingPanelVisible: Bool {
        currentToolPanel == .drawing
    }

    func makeUIView(context: Context) -> PKCanvasView {
        canvasView.drawingPolicy = .anyInput
        canvasView.delegate = context.coordinator
        canvasView.backgroundColor = .clear
        
        updateToolPickerVisibility()
        
        return canvasView
    }

    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        if drawing != uiView.drawing {
            uiView.drawing = drawing
        }
        
        updateToolPickerVisibility()
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

private extension CanvasView {
    func updateToolPickerVisibility() {
        toolPicker.setVisible(isDrawingPanelVisible, forFirstResponder: canvasView)
        toolPicker.addObserver(canvasView)
        canvasView.isUserInteractionEnabled = isDrawingPanelVisible

        if isDrawingPanelVisible {
            canvasView.becomeFirstResponder()
        } else {
            canvasView.resignFirstResponder()
        }
    }
}

#Preview {
    RootView()
}

