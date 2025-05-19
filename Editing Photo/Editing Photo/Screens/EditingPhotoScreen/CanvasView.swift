struct CanvasView: UIViewRepresentable {
        
    func makeUIView(context: Context) -> PKCanvasView {
        let canvasView = PKCanvasView()
        // Allow finger drawing
        canvasView.drawingPolicy = .anyInput
        
        return canvasView
    }
    
    func updateUIView(_ canvasView: PKCanvasView, context: Context) {
    }
       
}