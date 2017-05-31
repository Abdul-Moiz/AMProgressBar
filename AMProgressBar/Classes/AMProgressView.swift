//
//  AMProgressView.swift
//  AMProgressView
//
//  Created by Abdul Moiz on 2017-04-13.
//  Copyright © 2017 AppBakery. All rights reserved.
//

import UIKit

public enum AMProgressBarStripesOrientation: Int {
    case vertical = 0
    case diagonalRight = 1
    case diagonalLeft = 2
}

public enum AMProgressBarStripesMotion: Int {
    case none = 0
    case right = 1
    case left = -1
}

public enum AMProgressBarMode: Int {
    case determined = 0
    case undetermined = 1
}

public enum AMProgressBarTextPosition: Int {
    case topLeft = 0
    case topRight = 1
    case bottomLeft = 2
    case bottomRight = 3
    case middleLeft = 4
    case middleRight = 5
    case middleRightUnderBar = 6
    case middle = 7
    case onBar = 8
}

@IBDesignable
open class AMProgressBar: UIView {
    // MARK: - Global Configs
    public struct config {
        // Track Configs
        static public var cornerRadius: CGFloat = 10
        
        static public var borderColor: UIColor = .white
        static public var borderWidth: CGFloat = 2
        
        // Bar Configs
        static public var barCornerRadius: CGFloat = 10
        static public var barColor: UIColor = .blue
        static public var barMode: AMProgressBarMode = .determined
        
        // Stripes Configs
        static public var hideStripes: Bool = false
        static public var stripesColor: UIColor = .red
        static public var stripesMotion: AMProgressBarStripesMotion = .right
        static public var stripesOrientation: AMProgressBarStripesOrientation = .diagonalRight
        static public var stripesWidth: CGFloat = 30
        static public var stripesDelta: CGFloat = 80
        
        // Percentage Text Config
        static public var textColor: UIColor = .black
        static public var textFont: UIFont = UIFont.systemFont(ofSize: 18)
        static public var textPosition: AMProgressBarTextPosition = .onBar
    }
    
    // MARK: - Inspectable Properties
    @IBInspectable open var cornerRadius: CGFloat = config.cornerRadius {
        didSet {
            configureView()
        }
    }
    
    @IBInspectable open var borderColor: UIColor = config.borderColor {
        didSet {
            configureView()
        }
    }
    
    @IBInspectable open var borderWidth: CGFloat = config.borderWidth {
        didSet {
            configureView()
        }
    }
    
    @IBInspectable open var barCornerRadius: CGFloat = config.barCornerRadius {
        didSet {
            configureView()
        }
    }
    
    @IBInspectable open var barColor: UIColor = config.barColor {
        didSet {
            configureView()
        }
    }
    
    @IBInspectable open var barMode: Int = 0 {
        didSet {
            barMode_ = AMProgressBarMode(rawValue: barMode) ?? .determined
            configureView()
        }
    }
    
    @IBInspectable open var hideStripes: Bool = config.hideStripes {
        didSet {
            configureView()
        }
    }
    
    @IBInspectable open var stripesColor: UIColor = config.stripesColor {
        didSet {
            configureView()
        }
    }
    
    @IBInspectable open var stripesWidth: CGFloat = config.stripesWidth {
        didSet {
            configureView()
        }
    }
    
    @IBInspectable open var stripesDelta: CGFloat = config.stripesDelta {
        didSet {
            configureView()
        }
    }
    
    @IBInspectable open var stripesMotion: Int = config.barMode.rawValue  {
        didSet {
            stripesMotion_ = AMProgressBarStripesMotion(rawValue: stripesMotion) ?? .right
            configureView()
        }
    }
    
    @IBInspectable open var stripesOrientation: Int = config.stripesOrientation.rawValue {
        didSet {
            stripesOrientation_ = AMProgressBarStripesOrientation(rawValue: stripesOrientation) ?? .diagonalRight
            configureView()
        }
    }
    
    @IBInspectable open var textColor: UIColor = config.textColor {
        didSet {
            configureView()
        }
    }
    
    @IBInspectable open var textFont: UIFont = config.textFont {
        didSet {
            configureView()
        }
    }
    
    @IBInspectable open var textPosition: Int = config.textPosition.rawValue {
        didSet {
            textPosition_ = AMProgressBarTextPosition(rawValue: textPosition) ?? .onBar
            configureView()
        }
    }
    
    @IBInspectable open var progressValue: CGFloat = 0 {
        didSet {
            if (progressValue >= 1) {
                progressValue = 1
            } else if (progressValue <= 0) {
                progressValue = 0
            }
        }
    }
    
    // MARK: - Private Properties
    private var barMode_: AMProgressBarMode = config.barMode
    private var stripesMotion_: AMProgressBarStripesMotion = config.stripesMotion
    private var stripesOrientation_: AMProgressBarStripesOrientation = config.stripesOrientation
    private var textPosition_: AMProgressBarTextPosition = config.textPosition
    
    private var barLayer: CAShapeLayer? = nil
    private var stripeLayers: [CAShapeLayer]? = nil
    private var textLabel: UILabel? = nil
    
    private var animationDuration: CGFloat = 0.25
    
    private var customizing: Bool = false
    private var isStripesAnimating: Bool = false
    
    // MARK: - Override properties
    open override var isHidden: Bool {
        didSet {
            if isHidden == false && isStripesAnimating == false {
                self.perform(#selector(addStripeAnimation), with: nil, afterDelay: 0.2)
            } else if isHidden == true {
                isStripesAnimating = false
            }
        }
    }
    
    // MARK: - UIView Methods
    open override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        configureView()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureView()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Listener Methods
    @objc private func resumeActions(notification: Notification) {
        addStripeAnimation()
    }
    
    // MARK: - Bulk Customzations
    @discardableResult
    open func customize(_ block: (_ progressBar: AMProgressBar) -> ()) -> AMProgressBar {
        customizing = true
        block(self)
        customizing = false
        configureView()
        return self
    }
    
    // MARK: - Configuration Methods
    private func configureView() {
        if customizing == true { return }
        self.clipsToBounds = false
        self.layer.cornerRadius = cornerRadius
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
        
        configureListeners()
        configureBarLayer()
        configureStripesLayer()
        configureText()
        addStripeAnimation()
    }
    
    private func configureBarLayer() {
        //Remove old bar
        if barLayer != nil {
            barLayer?.removeFromSuperlayer()
        }
        
        // Calculate new frames
        let width = barMode_ == .undetermined ? frame.width : frame.width * progressValue
        let frameRect = CGRect(x:0, y: 0, width: width, height: frame.height)
        let rect = CGRect(x:0, y: 0, width: frame.width, height: frame.height)
        let path = UIBezierPath(roundedRect: rect, cornerRadius: barCornerRadius)
        
        // Add new bar
        barLayer = CAShapeLayer()
        barLayer?.anchorPoint = .zero
        barLayer?.path = path.cgPath
        barLayer?.fillColor = barColor.cgColor
        barLayer?.masksToBounds = true
        barLayer?.frame = frameRect
        barLayer?.cornerRadius = barCornerRadius
        barLayer?.zPosition = 1
        
        self.layer.addSublayer(barLayer!)
    }
    
    private func configureStripesLayer() {
        // Remove old stripes
        stripeLayers?.forEach({ (layer: CAShapeLayer) in
            layer.removeFromSuperlayer()
        })
        stripeLayers?.removeAll()
        
        // if is hide stripes is true then return
        if hideStripes == true { return }
        
        // Add stripes
        let stripesCount = Int(frame.width/stripesWidth)
        stripeLayers = []
        
        for i in -1...stripesCount + 1 {
            let stripe = CAShapeLayer()
            let rect = CGRect(x:(stripesWidth * CGFloat(i))*2, y: 0, width: stripesWidth, height: frame.height)
            let path = getStripeShape(rect: rect)
            
            stripe.path = path.cgPath
            stripe.fillColor = stripesColor.cgColor
            
            self.barLayer?.addSublayer(stripe)
            stripeLayers?.append(stripe)
        }
    }
    
    private func configureText() {
        if textLabel != nil {
            textLabel?.removeFromSuperview()
        }
        
        textLabel = UILabel()
        textLabel?.numberOfLines = 1
        textLabel?.font = textFont
        textLabel?.textColor = textColor
        textLabel?.text = barMode_ == .undetermined ? "" : String(format: "%i%%", Int(progressValue * 100))
        textLabel?.layer.zPosition = 2
        textLabel?.sizeToFit()
        updateTextPosition()
        
        self.addSubview(textLabel!)
        
    }
    
    private func configureListeners() {
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(resumeActions(notification:)), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
    }
    
    // MARK: - Helping Methods
    // This method will generate stripes path
    private func getStripeShape(rect: CGRect) -> UIBezierPath {
        var path: UIBezierPath!
        switch stripesOrientation_ {
        case .diagonalLeft:
            let diagonalValue: CGFloat = -40
            path = UIBezierPath()
            path.move(to: CGPoint(x: rect.origin.x + diagonalValue, y: rect.origin.y))
            path.addLine(to: CGPoint(x: rect.origin.x + rect.width + diagonalValue, y: rect.origin.y))
            path.addLine(to: CGPoint(x: rect.origin.x + rect.width, y: rect.origin.y + rect.height))
            path.addLine(to: CGPoint(x: rect.origin.x, y: rect.origin.y + rect.height))
            
        case .diagonalRight:
            let diagonalValue: CGFloat = 40
            path = UIBezierPath()
            path.move(to: CGPoint(x: rect.origin.x + diagonalValue, y: rect.origin.y))
            path.addLine(to: CGPoint(x: rect.origin.x + rect.width + diagonalValue, y: rect.origin.y))
            path.addLine(to: CGPoint(x: rect.origin.x + rect.width, y: rect.origin.y + rect.height))
            path.addLine(to: CGPoint(x: rect.origin.x, y: rect.origin.y + rect.height))
            
        case .vertical:
            path = UIBezierPath(roundedRect: rect, cornerRadius: 0)
        }
        
        return path
    }
    
    // MARK: - Animation Methods
    @objc private func addStripeAnimation() {
        guard let stripeLayers = stripeLayers, hideStripes == false && stripesMotion_ != .none else {
            // If there are any stripes but animation is none
            self.isStripesAnimating = false
            self.stripeLayers?.forEach { (stripeLayer: CAShapeLayer) in stripeLayer.removeAllAnimations() }
            return
        }
        let direction = stripesMotion_.rawValue
        stripeLayers.forEach { (stripeLayer: CAShapeLayer) in
            stripeLayer.removeAllAnimations()
            let anim = CABasicAnimation(keyPath: "transform.translation.x")
            anim.duration = CFTimeInterval(stripesDelta/60)
            anim.repeatCount = Float.greatestFiniteMagnitude
            anim.fromValue = 0
            anim.toValue = stripesWidth * 2 * CGFloat(direction)
            stripeLayer.add(anim, forKey: "transform.translation.x")
        }
        isStripesAnimating = true
    }
    
    // MARK: - Update Methods
    private func updateProgress(animated: Bool) {
        guard let barLayer = barLayer, barMode_ != .undetermined else { return }
        barLayer.removeAllAnimations()
        
        let oldBounds = barLayer.frame
        let newBounds = CGRect(x: 0, y: 0, width: frame.width * progressValue, height: frame.height)
        barLayer.bounds = newBounds
        
        if animated == true {
            let anim = CABasicAnimation(keyPath: "bounds")
            anim.duration = CFTimeInterval(animationDuration)
            anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
            anim.fromValue = NSValue(cgRect: oldBounds)
            anim.toValue = NSValue(cgRect: newBounds)
            anim.isRemovedOnCompletion = true
            barLayer.add(anim, forKey: "bounds")
        }
    }
    
    private func updateTextPosition(animated: Bool = false) {
        guard let textLabel = textLabel else { return }
        clipsToBounds = false
        textLabel.layer.zPosition = 2
        textLabel.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        switch textPosition_ {
        case .topLeft:
            textLabel.center = CGPoint(x: textLabel.frame.width/2, y: -textLabel.frame.height/2)
            
        case .topRight:
            textLabel.center = CGPoint(x: frame.width - textLabel.frame.width/2, y: -textLabel.frame.height/2)
            
        case .bottomLeft:
            textLabel.center = CGPoint(x: textLabel.frame.width/2, y: frame.height + textLabel.frame.height/2)
            
        case .bottomRight:
            textLabel.center = CGPoint(x: frame.width - textLabel.frame.width/2, y: frame.height + textLabel.frame.height/2)
            
        case .middleLeft:
            textLabel.center = CGPoint(x: textLabel.frame.width/2 + 10, y: frame.height/2)
            
        case .middleRight:
            textLabel.center = CGPoint(x: frame.width - textLabel.frame.width/2 - 10, y: frame.height/2)
            
        case .middleRightUnderBar:
            textLabel.layer.zPosition = 0
            textLabel.center = CGPoint(x: frame.width - textLabel.frame.width/2 - 10, y: frame.height/2)
            
        case .middle:
            textLabel.center = CGPoint(x: frame.width/2, y: frame.height/2)
            
        case .onBar:
            clipsToBounds = true
            textLabel.layer.anchorPoint = CGPoint(x: 1, y: 0.5)
            let oldCenter = textLabel.layer.position
            let newCenter = CGPoint(x: (frame.width * progressValue) - 10, y: frame.height/2)
            textLabel.layer.position = newCenter
            
            if animated == true {
                textLabel.layer.removeAllAnimations()
                
                let anim = CABasicAnimation(keyPath: "position")
                anim.duration = CFTimeInterval(animationDuration)
                anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
                anim.fromValue = NSValue(cgPoint: oldCenter)
                anim.toValue = NSValue(cgPoint: newCenter)
                anim.isRemovedOnCompletion = true
                textLabel.layer.add(anim, forKey: "position")
            }
        }
    }
    
    // MARK: - Public Methods
    public func setProgress(progress: CGFloat, animated: Bool) {
        progressValue = progress
        textLabel?.text = barMode_ == .undetermined ? "" : String(format: "%i%%", Int(progressValue * 100))
        textLabel?.sizeToFit()
        updateTextPosition(animated: animated)
        updateProgress(animated: animated)
    }
}
