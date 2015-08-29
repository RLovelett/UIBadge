//
//  UIBadgeLabel.swift
//  RefManOne
//
//  Created by Ryan Lovelett on 6/29/15.
//  Copyright © 2015 SAIC. All rights reserved.
//

import UIKit

@IBDesignable class UIBadgeLabel: UILabel {

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    settings()
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    settings()
  }

  private final func settings() {
    opaque = false
    userInteractionEnabled = false
    contentMode = .Left
    setContentHuggingPriority(251, forAxis: UILayoutConstraintAxis.Horizontal)
    setContentHuggingPriority(251, forAxis: UILayoutConstraintAxis.Vertical)
    lineBreakMode = NSLineBreakMode.ByTruncatingTail
    baselineAdjustment = UIBaselineAdjustment.AlignBaselines
    adjustsFontSizeToFitWidth = false
    translatesAutoresizingMaskIntoConstraints = false
    font = UIFont.systemFontOfSize(UIFont.smallSystemFontSize())
    textColor = UIColor.whiteColor()
  }

}
