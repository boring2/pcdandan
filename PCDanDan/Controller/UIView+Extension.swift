//
//  UIView+Extension.swift
//  PCDanDan
//
//  Created by Boring on 2018/1/7.
//  Copyright © 2018年 vma-lin. All rights reserved.
//

import Foundation
import UIKit

extension UIView {

  @IBInspectable var cornerRadius: CGFloat {
    get {
      return layer.cornerRadius
    }
    set {
      layer.cornerRadius = newValue
      layer.masksToBounds = newValue > 0
    }
  }

  @IBInspectable var borderWidth: CGFloat {
    get {
      return layer.borderWidth
    }
    set {
      layer.borderWidth = newValue
    }
  }

  @IBInspectable var borderColor: UIColor? {
    get {
      let color = UIColor(cgColor: layer.borderColor!)
      return color
    }
    set {
      layer.borderColor = newValue?.cgColor
    }
  }
}
