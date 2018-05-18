//
//  UIExtensionHelper.swift
//  SagaTest
//
//  Created by Daniel Klinkert Houfer on 5/18/18.
//  Copyright © 2018 Daniel Klinkert Houfer. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    var height : CGFloat {
        get{return self.frame.size.height}
        set{frame = CGRect(x:self.frame.origin.x, y:self.frame.origin.y, width:self.frame.size.width, height:newValue)}
    }
    
    var width : CGFloat {
        get{return self.frame.size.width}
        set{frame = CGRect(x:self.frame.origin.x, y:self.frame.origin.y, width:newValue, height:self.frame.size.height)}
    }
    
    var x : CGFloat {
        get{return self.frame.origin.x}
        set{frame = CGRect(x:newValue, y:self.frame.origin.y, width:self.frame.size.width, height:self.frame.size.height)}
    }
    
    var y : CGFloat {
        get{return self.frame.origin.y}
        set{frame = CGRect(x:self.frame.origin.x, y:newValue, width:self.frame.size.width, height:self.frame.size.height)}
    }
    
    var yCenter : CGFloat {
        get{return self.y + self.height/2.0}
        set{self.y = yCenter - self.height/2.0}
    }
    
    var xCenter : CGFloat {
        get{return self.x + self.width/2.0}
        set{self.x = newValue - self.width/2.0}
    }
    
    @IBInspectable var cornerRadius : CGFloat {
        set {
            layer.masksToBounds = true
            layer.cornerRadius =  newValue
        }
        get { return layer.cornerRadius}
    }
    
    @IBInspectable var borderWidth : CGFloat {
        set {layer.borderWidth = newValue}
        get { return layer.borderWidth}
    }
    
    @IBInspectable var borderColor : UIColor {
        set { layer.borderColor =  newValue.cgColor }
        get { return UIColor(cgColor: layer.borderColor!)}
    }
    
    func convertToImage() -> UIImage {
        UIGraphicsBeginImageContext(self.bounds.size);
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        let viewImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return viewImage!
    }
}


