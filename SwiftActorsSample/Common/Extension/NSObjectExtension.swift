//
//  NSObjectExtension.swift
//  SwiftActorsSample
//
//  Created by 荒木敦 on 2017/03/04.
//  Copyright © 2017年 WishMatch, Inc. All rights reserved.
//

import Foundation

extension NSObject {
    class var className: String {
        return String(describing: self)
    }
    
    var className: String {
        return type(of: self).className
    }
}
