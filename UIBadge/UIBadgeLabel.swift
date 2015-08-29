import UIKit

/// This is really just a UILabel with some special defaults preconfigured.
@IBDesignable
class UIBadgeLabel: UILabel {

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    settings()
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    settings()
  }

  private final func settings() {
    numberOfLines = 0
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
  }

}
