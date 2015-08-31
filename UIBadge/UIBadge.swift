import UIKit

// MARK: - Configurable properties

/// `UIBadge` is an extension class to `UIView` that provides a auto-layout compatible and interface builder aware badge
/// widget. It provides a view-based container for displaying integer values in an iOS emulated badge. This widget is
/// meant to emulate the look and feel of the default iOS badge widget that can be seen on a application icons in the
/// iOS spring board. It provides a few configurable properties to customize an instances appearance and behavior.
///
/// Specifically it can be configured to hide or show the badge if the value of the badge is zero
/// (see: `zeroOrNil` property). It can be configured to animate on value change (see: `animate` property). It can also
/// be configured to modify the spacing between the numeral in the badge and the edge of the badge itself (see:
/// `padding` property).
///
/// To use the `UIBadge` in interface builder drag a `UIView` into the builder then set its **Custom Class** value
/// to `UIBadge`.
///
/// ## Demo:
/// ![demo-emulator]()
///
/// - Requires: Swift 2 and iOS 8.0+
/// - SeeAlso: [Implementing a Custom View to Work with Auto Layout](https://developer.apple.com/library/ios/documentation/UserExperience/Conceptual/AutolayoutPG/ImplementingView/ImplementingView.html)
/// - SeeAlso: [Custom Live Views and Auto Layout](http://www.totem.training/swift-ios-tips-tricks-tutorials-blog/xcode-61-custom-live-views-and-auto-layout)
/// - SeeAlso: [UIView](https://developer.apple.com/library/ios/documentation/UIKit/Reference/UIView_Class/#//apple_ref/occ/clm/UIView/)
@IBDesignable
class UIBadge: UIView {

  /// The label that is used to display the value in the interface
  private let label: UIBadgeLabel = UIBadgeLabel(frame: CGRectZero)

  /// Animation configuration used when the badge's value changes. This can be described as a visual pulse of the badge.
  /// It is accomplished by scaling the badge to be 140% of it's starting size and then returning to the starting scale.
  private let pulseAnimation: CABasicAnimation = {
    let animation = CABasicAnimation(keyPath: "transform.scale")
    animation.duration = 0.2
    animation.toValue = 1.4
    animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
    animation.autoreverses = true
    animation.repeatCount = 0
    animation.removedOnCompletion = true
    return animation
  }()

  /// A constraint to make sure that the badge is at least as wide as the label (plus the configured `padding`). This
  /// constraint is a property of the badge because the constant (i.e., the `padding`) needs to be modified based on the
  /// value of the badge and `zeroAsNil`.
  ///
  /// That is, if the badge is meant to have a zero width then the `padding` must also be set to zero. By exposing this
  /// constraint the constant can be changed and then notify the badge that its constraints must be recalculated.
  private lazy var moreWidth: NSLayoutConstraint = {
    let constraint = NSLayoutConstraint(
      item: self,
      attribute: .Width,
      relatedBy: .GreaterThanOrEqual,
      toItem: self.label,
      attribute: .Width,
      multiplier: 1,
      constant: CGFloat(self.padding)
    )
    constraint.identifier = "moreWidth"
    return constraint
  }()

  // This one makes sure the badge, at its smallest, is a square and can only grow wider.
  /// A constraint to make sure that the badge is at its smallest a square and can only grow wider. Or put another way
  /// the width of the badge can never be smaller than its height. This constraint is a property of the badge because
  /// the constant (i.e., the `padding`) needs to be modified based on the value of the badge and `zeroAsNil`.
  ///
  /// That is, if the badge is meant to have a zero width then the `padding` must also be set to zero. By exposing this
  /// constraint the constant can be changed and then notify the badge that its constraints must be recalculated.
  private lazy var makeSquare: NSLayoutConstraint = {
    let constraint = NSLayoutConstraint(
      item: self,
      attribute: .Height,
      relatedBy: .Equal,
      toItem: self.label,
      attribute: .Height,
      multiplier: 1,
      constant: CGFloat(self.padding)
    )
    constraint.identifier = "makeSquare"
    return constraint
  }()

  /// The integer value to be displayed in the badge. This value, in conjunction with `zeroAsNil`, can cause special
  /// behavior. If `zeroAsNil` is set to `true` and the `badgeValue` is set to `0`. Then the badge will become zero
  /// width and height. Or more simply put will not be visible.
  ///
  /// The default value is `0`.
  ///
  /// - SeeAlso: `zeroAsNil`
  /// - Note: Changing this property should cause the badges appearance to be redrawn.
  @IBInspectable
  var badgeValue: Int = 0 {
    didSet {
      if !zeroAsNil || (zeroAsNil && badgeValue != 0) {
        label.text = String(badgeValue)
      } else {
        label.text = nil
      }

      badgeConstraintUpdate()

      // Perform animation if configured and value change
      if animate && badgeValue != oldValue {
        self.layer.addAnimation(pulseAnimation, forKey: "pulseAnimation")
      }
    }
  }

  /// Property determines if the badge should animate when changing the `badgeValue` property. If this property is
  /// `true` when the value changes the badge will animate. A `false` value stops all animation.
  ///
  /// The default value is `true`.
  @IBInspectable
  var animate: Bool = true

  /// This property determines how to treat the `badgeValue` of `0`. This value, in conjunction with `badgeValue`, can
  /// cause special behavior. If `zeroAsNil` is set to `true` and the `badgeValue` is set to `0`. Then the badge will
  /// become zero width and height. Or more simply put will not be visible.
  ///
  /// The default value is `false`.
  ///
  /// - SeeAlso: `badgeValue`
  /// - Note: Changing this property should cause the badges appearance to be redrawn.
  @IBInspectable
  var zeroAsNil: Bool = false {
    didSet {
      if !zeroAsNil || (zeroAsNil && badgeValue != 0) {
        label.text = String(badgeValue)
      } else {
        label.text = nil
      }

      badgeConstraintUpdate()
    }
  }

  /// The padding determines the extra size to be added to the badge after drawing the value in the badge. This padding
  /// is applied to both the width and height equally.
  ///
  /// The default value is `5`.
  ///
  /// - Note: Changing this property should cause the badges appearance to be redrawn.
  @IBInspectable
  var padding: Int = 5 {
    didSet {
      badgeConstraintUpdate()
    }
  }

  /// Text color changes the display color of the integer number.
  ///
  /// The default value is *white*.
  /// - Note: Changing this property should cause the badges appearance to be redrawn.
  @IBInspectable
  var textColor: UIColor = UIColor.whiteColor() {
    didSet {
      self.label.textColor = textColor
    }
  }

  /// Background color of the badge.
  ///
  /// The default value is *red*.
  /// - Note: Changing this property should cause the badges appearance to be redrawn.
  @IBInspectable
  var badgeColor: UIColor = UIColor.redColor() {
    didSet {
      self.backgroundColor = badgeColor
    }
  }

  /// This is a shortcut function that should make sure the badge is properly redrawn.
  internal func badgeConstraintUpdate() {
    if label.text == nil {
      moreWidth.constant = 0
      makeSquare.constant = 0
    } else {
      moreWidth.constant = CGFloat(padding)
      makeSquare.constant = CGFloat(padding)
    }

    label.sizeToFit()
    invalidateIntrinsicContentSize()
    setNeedsUpdateConstraints()
  }
}

// MARK: - Interface lifecycle management

extension UIBadge {

  override func awakeFromNib() {
    super.awakeFromNib()
    configureView()
  }

  /// Used to make sure the display is correct for the display in Interface Builder
  override func prepareForInterfaceBuilder() {
    super.prepareForInterfaceBuilder()
    configureView()

    // Hack to work around in (Interface Builder) Version 7.0 beta 6 (7A192o):
    // Illegal Configuration: Interface Builder does not support UIView sizes larger than 10,000 by 10,000
    if label.text == nil {
      label.text = "!"
      moreWidth.constant = CGFloat(padding)
      makeSquare.constant = CGFloat(padding)

      invalidateIntrinsicContentSize()
      setNeedsUpdateConstraints()
    }
  }

  private final func configureView() {
    // Recommended
    translatesAutoresizingMaskIntoConstraints = false

    // Configure the UIBadgeLabel to start
    // Add the UIBadgeLabel to the UIBadge
    self.addSubview(label)

    // Deal with Auto Layout

    let minWidth = NSLayoutConstraint(
      item: self,
      attribute: .Width,
      relatedBy: .GreaterThanOrEqual,
      toItem: self,
      attribute: .Height,
      multiplier: 1,
      constant: 0
    )
    let centerX = NSLayoutConstraint(
      item: label,
      attribute: .CenterX,
      relatedBy: .Equal,
      toItem: self,
      attribute: .CenterX,
      multiplier: 1,
      constant: 0
    )
    let centerY = NSLayoutConstraint(
      item: label,
      attribute: .CenterY,
      relatedBy: .Equal,
      toItem: self,
      attribute: .CenterY,
      multiplier: 1,
      constant: 0
    )
    self.addConstraints([minWidth, moreWidth, makeSquare, centerX, centerY])
  }

  override func intrinsicContentSize() -> CGSize {
    return label.bounds.size
  }

  override func layoutSubviews() {
    self.label.sizeToFit()
    super.layoutSubviews()

    self.invalidateIntrinsicContentSize()

    // Ensure that when the frame has been changed the corner radii are also updated
    layer.cornerRadius = self.bounds.height / 2
    layer.masksToBounds = layer.cornerRadius > 0
  }

}
