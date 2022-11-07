//
//  ViewController.swift
//  SyncAsync
//
//  Created by jangilkyu on 2022/11/02.
//

import UIKit

class ViewController: UIViewController {
  
  let IMAGE_URL = "https://picsum.photos/1280/720/?random"
  var counter: Int = 0
  
  let countLabel: UILabel = {
    let lb = UILabel()
    return lb
  }()
  
  let imageView: UIImageView = {
    let iv = UIImageView()
    iv.backgroundColor = .lightGray
    return iv
  }()
  
  let onSyncButton: UIButton = {
    let btn = UIButton()
    btn.setTitle("동기", for: .normal)
    btn.setTitleColor(UIColor.blue, for: .normal)
    return btn
  }()
  
  let onAsyncButton: UIButton = {
    let btn = UIButton()
    btn.setTitle("비동기", for: .normal)
    btn.setTitleColor(UIColor.red, for: .normal)
    return btn
  }()
    
  override func viewDidLoad() {
    super.viewDidLoad()
    Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
      self.counter += 1
      self.countLabel.text = "\(self.counter)"
    }
    setup()
  }
  
  private func setup() {
    addViews()
    setConstraints()
    configureOnSyncButton()
    configureOnAsyncButton()
  }
  
  private func configureOnSyncButton() {
    onSyncButton.addTarget(
      self,
      action: #selector(handleOnSyncButton),
      for: .touchUpInside)
  }
  
  @objc private func handleOnSyncButton() {
    guard let url = URL(string: self.IMAGE_URL) else { return  }
    guard let data = try? Data(contentsOf: url) else { return  }
    
    let image = UIImage(data: data)
    self.imageView.image = image
  }
  
  private func configureOnAsyncButton() {
    onAsyncButton.addTarget(
      self,
      action: #selector(handleOnAsyncButton),
      for: .touchUpInside)
  }
  
  @objc private func handleOnAsyncButton() {
    DispatchQueue.global().async {
      guard let url = URL(string: self.IMAGE_URL) else { return }
      guard let data = try? Data(contentsOf: url) else { return }
      
      let image = UIImage(data: data)
      DispatchQueue.main.async {
        self.imageView.image = image
      }
    }
  }
  
  private func addViews() {
    view.addSubview(imageView)
    view.addSubview(onSyncButton)
    view.addSubview(onAsyncButton)
    view.addSubview(countLabel)
  }
  
  private func setConstraints() {
    imageViewConstraints()
    onSyncButtonConstraints()
    onAsyncButtonButtonConstraints()
    countLabelConstraints()
  }
  
  private func imageViewConstraints() {
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
    imageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
    imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
    imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
  }
  
  private func onSyncButtonConstraints() {
    onSyncButton.translatesAutoresizingMaskIntoConstraints = false
    onSyncButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10).isActive = true
    onSyncButton.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
  }
  
  private func onAsyncButtonButtonConstraints() {
    onAsyncButton.translatesAutoresizingMaskIntoConstraints = false
    onAsyncButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10).isActive = true
    onAsyncButton.leadingAnchor.constraint(equalTo: onSyncButton.trailingAnchor, constant: 10).isActive = true
  }
  
  private func countLabelConstraints() {
    countLabel.translatesAutoresizingMaskIntoConstraints = false
    countLabel.centerYAnchor.constraint(equalTo: onAsyncButton.centerYAnchor).isActive = true
    countLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10).isActive = true
    countLabel.trailingAnchor.constraint(equalTo: imageView.trailingAnchor).isActive = true
  }
}

