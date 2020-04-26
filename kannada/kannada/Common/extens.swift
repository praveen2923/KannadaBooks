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
        let color = UIColor.init(named: "bgcolor")
        UINavigationBar.appearance().barTintColor = color
        UINavigationBar.appearance().tintColor =  .white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.systemBlue.cgColor]
        UINavigationBar.appearance().isTranslucent = false

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}


class extens : UIView {

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



