//
//  extension.swift
//  kannada
//
//  Created by PraveenH on 16/04/20.
//  Copyright © 2020 books. All rights reserved.
//

import UIKit


class MANavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
        let color = UIColor.init(named: "bgcolor")
        self.navigationBar.barTintColor = color
        self.navigationBar.tintColor =  .systemGreen
        self.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.systemBlue.cgColor]
        self.navigationBar.isTranslucent = false

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}



class CircleView: UIView {

    var foregroundColor = UIColor.white
    var lineWidth: CGFloat = 4.0

    var isAnimating = false {
        didSet {
            if isAnimating {
                self.isHidden = false
                self.rotate360Degrees(duration: 1.0)
            } else {
                self.isHidden = true
                self.layer.removeAllAnimations()
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    func setup() {
        self.isHidden = true
        self.backgroundColor = .clear
    }

    override func draw(_ rect: CGRect) {
        let width = bounds.width
        let height = bounds.height
        let radius = (min(width, height) - lineWidth) / 2.0

        var currentPoint = CGPoint(x: width / 2.0 + radius, y: height / 2.0)
        var priorAngle = CGFloat(360)

        for angle in stride(from: CGFloat(360), through: 0, by: -2) {
            let path = UIBezierPath()
            path.lineWidth = lineWidth

            path.move(to: currentPoint)
            currentPoint = CGPoint(x: width / 2.0 + cos(angle * .pi / 180.0) * radius, y: height / 2.0 + sin(angle * .pi / 180.0) * radius)
            path.addArc(withCenter: CGPoint(x: width / 2.0, y: height / 2.0), radius: radius, startAngle: priorAngle * .pi / 180.0 , endAngle: angle * .pi / 180.0, clockwise: false)
            priorAngle = angle

            foregroundColor.withAlphaComponent(angle/360.0).setStroke()
            path.stroke()
        }
    }

}


extension UIView {
    func rotate360Degrees(duration: CFTimeInterval = 3) {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat.pi * 2
        rotateAnimation.isRemovedOnCompletion = false
        rotateAnimation.duration = duration
        rotateAnimation.repeatCount = Float.infinity
        self.layer.add(rotateAnimation, forKey: nil)
    }
}


class CustomUISlider : UISlider {

    override func trackRect(forBounds bounds: CGRect) -> CGRect {

        //keeps original origin and width, changes height, you get the idea
        let customBounds = CGRect(origin: bounds.origin, size: CGSize(width: bounds.size.width, height: 5.0))
        super.trackRect(forBounds: customBounds)
        return customBounds
    }

    //while we are here, why not change the image here as well? (bonus material)
    override func awakeFromNib() {
        self.setThumbImage(UIImage(named: "sliderthumb"), for: .normal)
        super.awakeFromNib()
    }
}




// MARK: - Designable Extension

@IBDesignable
extension UIView {
    
    @IBInspectable
    public var shadowOffset: CGSize {
        get {
            return CGSize(width: 1.5, height: 1.5)
        }
        set {
            self.layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
        }
    }
    
    @IBInspectable
    /// Corner radius of view; also inspectable from Storyboard.
    public var shadowColor: UIColor {
        get {
            return UIColor.darkGray
        }
        set {
            self.layer.shadowColor = UIColor.darkGray.cgColor
        }
    }
    
    @IBInspectable
    /// Corner radius of view; also inspectable from Storyboard.
    public var shadowRadius: CGFloat {
        get {
            return self.layer.shadowRadius
        }
        set {
            self.layer.shadowRadius = 1.0
        }
    }
    
    @IBInspectable
    /// Corner radius of view; also inspectable from Storyboard.
    public var shadowOpacity: CGFloat {
        get {
            return CGFloat(self.layer.shadowOpacity)
        }
        set {
            self.layer.shadowOpacity = 0.7
        }
    }
    
    @IBInspectable
       /// Corner radius of view; also inspectable from Storyboard.
       public var masksToBounds: Bool {
           get {
            return self.layer.masksToBounds
           }
           set {
               self.layer.masksToBounds = false
           }
       }
    
    @IBInspectable
          /// Corner radius of view; also inspectable from Storyboard.
          public var cornerRadius: CGFloat {
              get {
               return self.layer.cornerRadius
              }
              set {
                  self.layer.cornerRadius = 5
              }
          }
}


extension String {

    //To check text field or String is blank or not
    var isBlank: Bool {
        get {
            let trimmed = trimmingCharacters(in: CharacterSet.whitespaces)
            return trimmed.isEmpty
        }
    }

    //Validate Email
    var isEmail: Bool {
        do {
            let regex = try NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}", options: .caseInsensitive)
            return regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count)) != nil
        } catch {
            return false
        }
    }
    
    var isPhoneNumber: Bool {
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
            let matches = detector.matches(in: self, options: [], range: NSRange(location: 0, length: self.count))
            if let res = matches.first {
                return res.resultType == .phoneNumber && res.range.location == 0 && res.range.length == self.count
            } else {
                return false
            }
        } catch {
            return false
        }
    }
}



