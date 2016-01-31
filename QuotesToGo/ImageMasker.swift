//
//  ImageMasker.swift
//  QuotesToGo
//
//  Created by matsuosh on 1/31/16.
//  Copyright © 2016 Daniel Autenrieth. All rights reserved.
//

import UIKit

class ImageMasker: NSObject {

    class func maskImage(imageView: UIImageView!, size: CGSize!) {
        let mask = CALayer()
        var maskImage = UIImage(named: "mask")
        if size.width > 54 {
            maskImage = UIImage(named: "bigMask")
        }
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        maskImage?.drawInRect(CGRect(origin: CGPointZero, size: size))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        mask.contents = newImage.CGImage
        mask.frame = CGRect(origin: CGPointZero, size: size)
        imageView.contentMode = .ScaleAspectFill
        imageView.layer.mask = mask
    }
}
