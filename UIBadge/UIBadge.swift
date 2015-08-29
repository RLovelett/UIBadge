//
//  UIBadge.swift
//  RefManOne
//
//  Created by Ryan Lovelett on 6/24/15.
//  Copyright © 2015 SAIC. All rights reserved.
//

import UIKit


/// https://developer.apple.com/library/ios/documentation/UserExperience/Conceptual/AutolayoutPG/ImplementingView/ImplementingView.html
/// http://www.totem.training/swift-ios-tips-tricks-tutorials-blog/xcode-61-custom-live-views-and-auto-layout
@IBDesignable class UIBadge: UIView {

  /// The label that is used to display the value in the interface
  private let label: UIBadgeLabel = UIBadgeLabel(frame: CGRectZero)

  /// Animation that is used to notify if the badge has been updated
  private let pulseAnimation: CABasicAnimation = CABasicAnimation(keyPath: "transform.scale")

  // MARK: - Initialization methods

  override func awakeFromNib() {
    configureView()
  }

  /// Used to make sure the display is correct for the display in Interface Builder
  override func prepareForInterfaceBuilder() {
    configureView()
  }

  private final func configureView() {
    // Recommended
    translatesAutoresizingMaskIntoConstraints = false
    backgroundColor = UIColor.redColor()

    // Configure the UIBadgeLabel to start
    // Add the UIBadgeLabel to the UIBadge
    self.addSubview(label)

    // Deal with Auto Layout
    let centerX = NSLayoutConstraint(
      item: label,
      attribute: NSLayoutAttribute.CenterX,
      relatedBy: NSLayoutRelation.Equal,
      toItem: self,
      attribute: NSLayoutAttribute.CenterX,
      multiplier: 1,
      constant: 0
    )
    let centerY = NSLayoutConstraint(
      item: label,
      attribute: NSLayoutAttribute.CenterY,
      relatedBy: NSLayoutRelation.Equal,
      toItem: self,
      attribute: NSLayoutAttribute.CenterY,
      multiplier: 1,
      constant: 0
    )
    let squareOrRectangle = NSLayoutConstraint(
      item: self,
      attribute: NSLayoutAttribute.Width,
      relatedBy: NSLayoutRelation.GreaterThanOrEqual,
      toItem: self,
      attribute: NSLayoutAttribute.Height,
      multiplier: 1,
      constant: 0
    )

    self.addConstraints([
      centerX,
      centerY,
      squareOrRectangle
    ])

    // Configure the animation
    pulseAnimation.duration = 0.2
    pulseAnimation.toValue = 1.4
    pulseAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
    pulseAnimation.autoreverses = true
    pulseAnimation.repeatCount = 0
    pulseAnimation.removedOnCompletion = true

    // Ensure that when the frame has been changed the corner radii are also updated
//    layer.cornerRadius = self.bounds.height / 2
//    layer.masksToBounds = layer.cornerRadius > 0
  }

  // MARK: - Methods to tweak drawing parameters

  override func intrinsicContentSize() -> CGSize {
    if label.text == nil {
      return super.intrinsicContentSize()
    } else {
      return CGSize(width: label.bounds.size.width + CGFloat(self.padding), height: label.bounds.size.height + CGFloat(self.padding))
    }
  }

  override func layoutSubviews() {
    super.layoutSubviews()

    // Now that the text size has been changed calculate a new intrinisic size
    self.invalidateIntrinsicContentSize()

    // Ensure that when the frame has been changed the corner radii are also updated
    layer.cornerRadius = self.bounds.height / 2
    layer.masksToBounds = layer.cornerRadius > 0
  }

  // MARK: - Configurable properties

  @IBInspectable var value: Int? = nil {
    didSet {
      if let value = self.value where !zeroAsNil || (zeroAsNil && value != 0) {
        label.text = String(value)
      } else {
        label.text = nil
      }

      // Perform animation if configured and value change
      if animate && value != oldValue {
        self.layer.addAnimation(pulseAnimation, forKey: "pulseAnimation")
      }
    }
  }

  /// Property determines if the value should animate when changing. If this property is `true` when the value changes
  /// the badge will animate. A `false` value stops all animation.
  @IBInspectable var animate: Bool = true

  /// Treats the value of `0` as a `nil`. This effectively causes the badge to not be shown. That is, if this property
  /// is `true` the value of the label is a `nil` `String`. This results in the content size being a 0 and thus the view
  /// cannot be seen. A `false` value shows the value `0` in the badge.
  @IBInspectable var zeroAsNil: Bool = true

  @IBInspectable var padding: Int = 5 {
    didSet {
      self.invalidateIntrinsicContentSize()
    }
  }

  @IBInspectable var textColor: UIColor = UIColor.whiteColor() {
    didSet {
      label.textColor = self.textColor
      self.setNeedsLayout()
    }
  }

  @IBInspectable var badgeColor: UIColor = UIColor.redColor() {
    didSet {
      self.backgroundColor = self.badgeColor
      self.setNeedsLayout()
    }
  }
}
