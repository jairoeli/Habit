//
//  EmptyView.swift
//  Zero
//
//  Created by Jairo Eli de Leon on 5/31/17.
//  Copyright © 2017 Jairo Eli de León. All rights reserved.
//

import UIKit

final class EmptyView: UIView {

  private struct Constant {
    static let imageViewSize = CGSize(width: 80.0, height: 80.0)
    static let spacing: CGFloat = 12.0
  }

  private(set) lazy var imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    return imageView
  }()

  private(set) lazy var textLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .center
    label.numberOfLines = 0
    label.text = "Empty"
    label.textColor = .red
    label.font = UIFont.systemFont(ofSize: 20.0)
    return label
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)

    setup()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setup() {

    let stackView = UIStackView(arrangedSubviews: [imageView, textLabel])
    stackView.axis = .vertical
    stackView.spacing = 12.0
    stackView.distribution = .fill
    stackView.alignment = .center
    addSubview(stackView)
    stackView.translatesAutoresizingMaskIntoConstraints = false

    imageView.widthAnchor.constraint(equalToConstant: Constant.imageViewSize.width).isActive = true
    imageView.heightAnchor.constraint(equalToConstant: Constant.imageViewSize.height).isActive = true

    stackView.widthAnchor.constraint(lessThanOrEqualTo: self.widthAnchor, multiplier: 0.8).isActive = true
    stackView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    stackView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
  }

  func addTo(_ superview: UIView) {
    superview.addSubview(self)
    self.translatesAutoresizingMaskIntoConstraints = false

    let views = ["emptyView": self]
    let h = NSLayoutConstraint.constraints(withVisualFormat: "H:|[emptyView]|", options: [], metrics: nil, views: views)
    let v = NSLayoutConstraint.constraints(withVisualFormat: "V:|[emptyView]|", options: [], metrics: nil, views: views)
    NSLayoutConstraint.activate(h)
    NSLayoutConstraint.activate(v)
  }
}
