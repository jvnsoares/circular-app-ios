//
//  UIImageExtensions.swift
//  circular
//
//  Created by Vitor Nunes on 02/01/18.
//  Copyright © 2018 Jose Soares. All rights reserved.
//

import UIKit

extension UIImage {
    func scaleToSize(aSize :CGSize) -> UIImage {
        if (self.size.equalTo(aSize)) {
            return self
        }

        UIGraphicsBeginImageContextWithOptions(aSize, false, 0.0)
        self.draw(in: CGRect(x: 0.0,y:  0.0, width:  aSize.width, height: aSize.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
