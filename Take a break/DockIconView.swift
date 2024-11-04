import AppKit

class DockIconView: NSView {
    var progress: Double = 0.0 {
        didSet {
            needsDisplay = true
        }
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        // Use a fixed size for the icon
        let iconSize: CGFloat = min(bounds.width, bounds.height) * 0.8
        let originX = (bounds.width - iconSize) / 2
        let originY = (bounds.height - iconSize) / 2
        let scaledBounds = NSRect(x: originX, y: originY, width: iconSize, height: iconSize)
        
        // Create rounded rect path for icon background
        let cornerRadius: CGFloat = iconSize * 0.2
        let backgroundPath = NSBezierPath(roundedRect: scaledBounds, xRadius: cornerRadius, yRadius: cornerRadius)
        
        // Fill background with white
        NSColor.white.set()
        backgroundPath.fill()
        
        // Add padding for the progress circle
        let padding: CGFloat = iconSize * 0.2
        let drawingBounds = scaledBounds.insetBy(dx: padding, dy: padding)
        
        // Draw background circle in black with transparency
        let circleBackgroundPath = NSBezierPath(ovalIn: drawingBounds)
        NSColor.black.withAlphaComponent(0.3).setStroke()
        circleBackgroundPath.lineWidth = 6
        circleBackgroundPath.lineCapStyle = .round
        circleBackgroundPath.stroke()
        
        // Draw progress arc in solid black only if progress > 0
        if progress > 0 {
            let progressPath = NSBezierPath()
            let center = CGPoint(x: scaledBounds.midX, y: scaledBounds.midY)
            let radius = (iconSize / 2) - padding
            let startAngle: CGFloat = 90
            let endAngle = startAngle - (360 * progress)
            
            progressPath.appendArc(withCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
            NSColor.black.setStroke()
            progressPath.lineWidth = 6
            progressPath.lineCapStyle = .round
            progressPath.stroke()
        }
    }
} 