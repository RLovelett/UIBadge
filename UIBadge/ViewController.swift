//
//  ViewController.swift
//  UIBadge
//
//  Created by Ryan Lovelett on 8/28/15.
//  Copyright © 2015 SAIC. All rights reserved.
//

import UIKit

extension Int {
  static func random(range: Range<Int> ) -> Int {
    var offset = 0

    // allow negative ranges
    if range.startIndex < 0 {
      offset = abs(range.startIndex)
    }

    let mini = UInt32(range.startIndex + offset)
    let maxi = UInt32(range.endIndex   + offset)

    return Int(mini + arc4random_uniform(maxi - mini)) - offset
  }
}

class ViewController: UIViewController {

  @IBOutlet weak var zeroAsNil: UIBadge!
  @IBOutlet weak var dispZero: UIBadge!
  @IBOutlet weak var tens: UIBadge!
  @IBOutlet weak var hundreds: UIBadge!

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.

    NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: Selector("incrementBadge"), userInfo: nil, repeats: true)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  func incrementBadge() {
    zeroAsNil.badgeValue = (zeroAsNil.badgeValue + 1) % 2
    dispZero.badgeValue =  (dispZero.badgeValue + Int.random(1...10)) % 10
    tens.badgeValue = (tens.badgeValue + Int.random(1...100)) % 100
    hundreds.badgeValue = (hundreds.badgeValue + Int.random(1...1000)) % 1000
  }


}

