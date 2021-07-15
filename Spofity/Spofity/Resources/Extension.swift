//
//  Extension.swift
//  Spofity
//
//  Created by Pallavi on 14/07/21.
//

import Foundation
import UIKit
extension UIView{
    var width:CGFloat{
        return self.frame.width
    }
    var height:CGFloat{
        return self.frame.height
    }
    var left:CGFloat{
        return self.frame.origin.x
    }
    var right:CGFloat{
        return left + width
    }
    var top:CGFloat{
        return self.frame.origin.y
    }
    var bottom:CGFloat{
        return top + height
    }
   
    
}
