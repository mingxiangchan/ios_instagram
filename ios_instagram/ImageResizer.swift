//
//  ImageResizer.swift
//  ios_instagram
//
//  Created by Ming Xiang Chan on 25/04/2016.
//  Copyright © 2016 NEXTACADEMY. All rights reserved.
//

import Foundation
import UIKit

class ImageResizer {
    func resize(image: UIImage, targetWidth: CGFloat) -> UIImage {
        let size = image.size
        let resizeRatio = size.width / targetWidth
        let targetHeight = size.height * resizeRatio
        
        let widthRatio  = targetWidth  / image.size.width
        let heightRatio = targetHeight / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSizeMake(size.width * heightRatio, size.height * heightRatio)
        } else {
            newSize = CGSizeMake(size.width * widthRatio,  size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRectMake(0, 0, newSize.width, newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.drawInRect(rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    func encodeToString(image: UIImage, maxFileSizeinKB: CGFloat) -> String {
        var imageData: NSData = UIImageJPEGRepresentation(image, 0.99)!;
        let maxFileSize: CGFloat = maxFileSizeinKB * 1024;
        let imageFileSize: CGFloat = CGFloat(imageData.length)
        
        //If the image is bigger than the max file size, try to bring it down to the max file size
        if (imageFileSize > maxFileSize) {
            imageData = UIImageJPEGRepresentation(image, maxFileSize/imageFileSize)!;
        }
        let imageString = imageData.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
        return imageString
    }
}