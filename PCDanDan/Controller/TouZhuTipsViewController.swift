//
//  TouZhuTipsViewController.swift
//  PCDanDan
//
//  Created by Boring on 2018/1/7.
//  Copyright © 2018年 vma-lin. All rights reserved.
//

import UIKit

@objc protocol TouZhuTipsViewControllerDelegate: class {
  func touZhuTipsViewDismiss ()
}
class TouZhuTipsViewController: UIViewController, UIGestureRecognizerDelegate {

  @IBOutlet weak var contentView: UIView!

  @IBOutlet weak var viewTitle: UILabel!

  @IBOutlet weak var num1: UILabel!

  @IBOutlet weak var num2: UILabel!

  @IBOutlet weak var num3: UILabel!

  @IBOutlet weak var num4: UILabel!

  @IBOutlet weak var subtitle: UILabel!

  weak var delegate: TouZhuTipsViewControllerDelegate?

  var timer: Timer?

  override func viewDidLoad() {
    super.viewDidLoad()

    self.view.backgroundColor = UIColor.white.withAlphaComponent(0.3)
    self.view.isUserInteractionEnabled = true
    let singleTap = UITapGestureRecognizer(target: self, action: #selector(singleTapHandler))
    self.view.addGestureRecognizer(singleTap)
    singleTap.delegate = self
//
//    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];


//    self.view.gestureRecognizers
    // Do any additional setup after loading the view.
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  func singleTapHandler () {
    self.timer?.invalidate()
    self.timer = nil
    self.delegate?.touZhuTipsViewDismiss()
    dismiss(animated: true, completion: nil)
  }

  public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
    guard let view = touch.view else {
      return false
    }
    if view.isDescendant(of: contentView) {
      return false
    }
    return true
  }
  /*
   // MARK: - Navigation

   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destinationViewController.
   // Pass the selected object to the new view controller.
   }
   */
  func setInfo (title: String, num1: String, num2: String, num3: String, num4: String) {
    self.viewTitle.text = title + "期开奖结果"
    self.subtitle.text = "已获取开奖结果，请查看"
    self.num1.text = num1
    self.num2.text = num2
    self.num3.text = num3
    self.num4.text = num4
    self.timer?.invalidate()
    self.timer = nil
    Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { _ in
      self.singleTapHandler()
    }
  }

  func setViewTitle (second: String) {
    if ((self.viewTitle) != nil) {
      self.viewTitle.text = "下期投注倒计时：\(second)s"
    }
  }

  func setRandomNum () {
    if timer != nil {
      return
    }
    timer = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true, block: { _ in
      self.num1.text = "\(arc4random() % 10)"
      self.num2.text = "\(arc4random() % 10)"
      self.num3.text = "\(arc4random() % 10)"
      self.num4.text = "\(arc4random() % 10)"
    })
  }

}
