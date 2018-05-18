//
//  UIImageHelper.swift
//  SagaTest
//
//  Created by Daniel Klinkert Houfer on 5/18/18.
//  Copyright © 2018 Daniel Klinkert Houfer. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    
    class func imageFromColor(color: UIColor) -> UIImage {
        return imageFromColor(color: color, size: CGSize(width:10, height:10))
    }
    
    class func imageFromColor(color: UIColor, size: CGSize) -> UIImage {
        let imageView = UIView(frame: CGRect(x:0, y:0,width:size.width, height:size.height))
        imageView.backgroundColor = color
        return imageView.convertToImage()
    }
    
    
    func imageScaledToSize(sizeA:CGSize) -> UIImage {
        
        let size = sizeA
        
        let maxLong = max(self.size.width, self.size.height)
        let relation = size.width/maxLong
        let newSize:CGSize = CGSize(width: self.size.width*relation, height: self.size.height*relation)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
        
    }
    
    
    func imageWithTintColor(color: UIColor) -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        let context: CGContext = UIGraphicsGetCurrentContext()!
        context.translateBy(x: 0, y: self.size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        context.setBlendMode(CGBlendMode.normal)
        let rect: CGRect = CGRect(x:0, y:0, width:self.size.width, height:self.size.height)
        context.clip(to: rect, mask: self.cgImage!)
        color.setFill()
        context.fill(rect);
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!;
        UIGraphicsEndImageContext();
        return newImage;
        
    }
    
    
    class func image(named name:String, tintColor: UIColor) -> UIImage {
        let image: UIImage = UIImage(named: name)!
        return image.imageWithTintColor(color: tintColor)
    }
    
    
    func crop(rect: CGRect) -> UIImage {
        let imageRef = self.cgImage!.cropping(to: rect)
        let image = UIImage(cgImage: imageRef!, scale: self.scale, orientation: self.imageOrientation)
        return image
    }
    
    
    func imageWithCornerRadius(radius:CGFloat) -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        
        UIBezierPath(roundedRect: CGRect(origin: CGPoint.zero, size: size), cornerRadius: radius).addClip()
        
        self.draw(in: CGRect(origin: CGPoint.zero, size: size))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}
