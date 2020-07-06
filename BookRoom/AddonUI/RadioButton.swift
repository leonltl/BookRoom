//
//  RadioButton.swift
//  BookRoom

import UIKit

@IBDesignable
class RadioButton: UIButton {

    internal var outerCircleLayer = CAShapeLayer()
    internal var innerCircleLayer = CAShapeLayer()
        
    @IBInspectable public var outerCircleColor: UIColor = UIColor.green {
        didSet {
            outerCircleLayer.strokeColor = outerCircleColor.cgColor
        }
    }
    
    @IBInspectable public var innerCircleCircleColor: UIColor = UIColor.green {
        didSet {
            setFill()
        }
    }
    
    @IBInspectable public var outerCircleWidth: CGFloat = 3.0 {
        didSet {
            setCircleLayouts()
        }
    }
    
    @IBInspectable public var innerCircleGap: CGFloat = 3.0 {
        didSet {
            setCircleLayouts()
        }
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        initialization()
    }
    
    // MARK: - Initialization
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialization()
    }
    
    internal var circleRadius: CGFloat {
        let width = bounds.width
        let height = bounds.height
        
        let length = width > height ? height : width
        return (length - outerCircleWidth) / 2
    }
    
    private var circleFrame: CGRect {
        let width = bounds.width
        let height = bounds.height
        
        let radius = circleRadius
        let x: CGFloat
        let y: CGFloat
        
        if width > height {
            y = outerCircleWidth / 2
            x = (width / 2) - radius
        } else {
            x = outerCircleWidth / 2
            y = (height / 2) - radius
        }
        
        let diameter = 2 * radius
        return CGRect(x: x, y: y, width: diameter, height: diameter)
    }

    private var circlePath: UIBezierPath {
        return UIBezierPath(roundedRect: circleFrame, cornerRadius: circleRadius)
    }
    
    private var fillCirclePath: UIBezierPath {
        let trueGap = innerCircleGap + (outerCircleWidth / 2)
        return UIBezierPath(roundedRect: circleFrame.insetBy(dx: trueGap, dy: trueGap), cornerRadius: circleRadius)
    }
    
    private func initialization() {
        outerCircleLayer.frame = bounds
        outerCircleLayer.lineWidth = outerCircleWidth
        outerCircleLayer.fillColor = UIColor.clear.cgColor
        outerCircleLayer.strokeColor = outerCircleColor.cgColor
        layer.addSublayer(outerCircleLayer)
        
        innerCircleLayer.frame = bounds
        innerCircleLayer.lineWidth = outerCircleWidth
        innerCircleLayer.fillColor = UIColor.clear.cgColor
        innerCircleLayer.strokeColor = UIColor.clear.cgColor
        layer.addSublayer(innerCircleLayer)
        
        setFill()
    }
    
    private func setCircleLayouts() {
        outerCircleLayer.frame = bounds
        outerCircleLayer.lineWidth = outerCircleWidth
        outerCircleLayer.path = circlePath.cgPath
        
        innerCircleLayer.frame = bounds
        innerCircleLayer.lineWidth = outerCircleWidth
        innerCircleLayer.path = fillCirclePath.cgPath
    }
    
    
    private func setFill() {
        if self.isSelected {
            innerCircleLayer.fillColor = outerCircleColor.cgColor
        } else {
            innerCircleLayer.fillColor = UIColor.clear.cgColor
        }
    }
    
    // MARK: - Overriden methods
    override public func prepareForInterfaceBuilder() {
        initialization()
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        setCircleLayouts()
    }
    
    override public var isSelected: Bool {
        didSet {
            setFill()
        }
    }

}
