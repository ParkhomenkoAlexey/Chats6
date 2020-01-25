//
//  UIScrollView + Extension.swift
//  Chats
//
//  Created by Алексей Пархоменко on 24.01.2020.
//  Copyright © 2020 Алексей Пархоменко. All rights reserved.
//

import UIKit

extension UIScrollView {
  
  var isAtBottom: Bool {
    return contentOffset.y >= verticalOffsetForBottom
  }
  
  var verticalOffsetForBottom: CGFloat {
    let scrollViewHeight = bounds.height
    let scrollContentSizeHeight = contentSize.height
    let bottomInset = contentInset.bottom
    let scrollViewBottomOffset = scrollContentSizeHeight + bottomInset - scrollViewHeight
    return scrollViewBottomOffset
  }
  
}

