import Foundation
import UIKit

class Line
{
    var start : CGPoint
    var end : CGPoint
    
    init(start _start: CGPoint, end _end: CGPoint)
    {
        start = _start
        end = _end
    }
}

//Canvas for Drawing
class CanvasView : UIView
{
    var lines : [Line]  = []
    var lastPoint : CGPoint!
    
    override func touchesBegan(_ touches: Set<UITouch>?, with event: UIEvent?) {
        lastPoint = touches?.first?.location(in: self)
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let newPoint = touches.first?.location(in: self) else {
            return
        }
        lines.append(Line(start: lastPoint, end: newPoint))
        lastPoint = newPoint
        self.setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else
        {
            return
        }
        context.beginPath()
        
        for (line) in lines
        {
            context.move(to: line.start)
            context.addLine(to: line.end)
        }
        let penColor = UIColor(red: 251/255, green: 140/255, blue: 0/255, alpha: 1)
        context.setStrokeColor(penColor.cgColor)
        context.setLineWidth(8)
        context.setLineCap(CGLineCap.round)
        context.strokePath()
        
    }
}
