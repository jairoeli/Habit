//
//  BaseViewController.swift
//  Zero
//
//  Created by Jairo Eli de Leon on 5/8/17.
//  Copyright © 2017 Jairo Eli de León. All rights reserved.
//

import UIKit
import RxSwift

class BaseViewController: UIViewController {

  // MARK: - Properties
  lazy private(set) var className: String = {
    return type(of: self).description().components(separatedBy: ".").last ?? ""
  }()

  var automaticallyAdjustsLeftBarButtonItem = true

  // MARK: - Initializing
  init() {
    super.init(nibName: nil, bundle: nil)
  }

  required convenience init?(coder aDecoder: NSCoder) {
    self.init()
  }

  deinit {
    log.verbose("DEINIT: \(self.className)")
  }

  // MARK: - Rx
  var disposeBag = DisposeBag()

  // MARK: - View Lifecycle
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if self.automaticallyAdjustsLeftBarButtonItem {
      self.adjustLeftBarButtonItem()
    }
  }

  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    dch_checkDeallocation()
  }

  // MARK: - Layout Constraints
  private(set) var didSetupConstraints = false

  override func viewDidLoad() {
    self.view.setNeedsUpdateConstraints()
  }

  override func updateViewConstraints() {
    if !self.didSetupConstraints {
      self.setupConstraints()
      self.didSetupConstraints = true
    }
    super.updateViewConstraints()
  }

  func setupConstraints() {
    // Override point
  }

  // MARK: - Adjusting Navigation Item
  func adjustLeftBarButtonItem() {
    if self.navigationController?.viewControllers.count ?? 0 > 1 { // pushed
      self.navigationItem.rightBarButtonItem = nil
    } else if self.presentingViewController != nil { // presented
      self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "cancel"),
                                                               style: .plain,
                                                               target: self,
                                                               action: #selector(cancelButtonDidTap))
    }
  }

  @objc func cancelButtonDidTap() {
    self.dismiss(animated: true, completion: nil)
  }

}
