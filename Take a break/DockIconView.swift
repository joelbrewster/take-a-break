import AppKit

class DockIconView: NSView {
    var progress: Double = 1.0 {
        didSet {
            needsDisplay = true
        }
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        // Scale down the drawing area
        let scale: CGFloat = 0.75 // Adjust this value to make icon smaller/larger
        let scaledSize = min(bounds.width, bounds.height) * scale
        let originX = (bounds.width - scaledSize) / 2
        let originY = (bounds.height - scaledSize) / 2
        let scaledBounds = NSRect(x: originX, y: originY, width: scaledSize, height: scaledSize)
        
        // Create rounded rect path for icon background
        let cornerRadius: CGFloat = scaledSize * 0.2
        let backgroundPath = NSBezierPath(roundedRect: scaledBounds, xRadius: cornerRadius, yRadius: cornerRadius)
        
        // Fill background with white
        NSColor.white.set()
        backgroundPath.fill()
        
        // Add padding for the progress circle
        let padding: CGFloat = scaledSize * 0.2
        let drawingBounds = scaledBounds.insetBy(dx: padding, dy: padding)
        
        // Draw background circle in black with transparency
        let circleBackgroundPath = NSBezierPath(ovalIn: drawingBounds)
        NSColor.black.withAlphaComponent(0.3).setStroke()
        circleBackgroundPath.lineWidth = 2
        circleBackgroundPath.stroke()
        
        // Draw progress arc in solid black
        let progressPath = NSBezierPath()
        let center = CGPoint(x: scaledBounds.midX, y: scaledBounds.midY)
        let radius = (scaledSize / 2) - padding
        let startAngle: CGFloat = -90
        let endAngle = startAngle + (360 * progress)
        
        progressPath.appendArc(withCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        NSColor.black.setStroke()
        progressPath.lineWidth = 2
        progressPath.stroke()
    }
} 