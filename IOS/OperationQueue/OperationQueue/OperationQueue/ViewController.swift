//
//  ViewController.swift
//  OperationQueue
//
//  Created by 장일규 on 2022/02/14.
//

import UIKit

class ViewController: UIViewController {
    
    let queue = OperationQueue()

    let startOperationBtn: UIButton = {
      let startOperationBtn = UIButton()
        startOperationBtn.setTitle("Start", for: .normal)
        startOperationBtn.backgroundColor = .red
        startOperationBtn.addTarget(self, action: #selector(startOperation), for: .touchUpInside)
        return startOperationBtn
    }()
    
    let cancelOprationBtn: UIButton = {
        let cancelOprationBtn = UIButton()
        cancelOprationBtn.setTitle("Cancel", for: .normal)
        cancelOprationBtn.backgroundColor = .gray
        cancelOprationBtn.addTarget(self, action: #selector(cancelOpration), for: .touchUpInside)
          return cancelOprationBtn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setup()
    }
    
    @objc func startOperation() {
        queue.addOperation {
            autoreleasepool {
                for _ in 1..<100 {
                    print("사", separator: " ", terminator: " ")
                    Thread.sleep(forTimeInterval: 0.3)
                }
            }
        }
        
        let op = BlockOperation {
            autoreleasepool {
                for _ in 1..<100 {
                    print("랑", separator: " ", terminator: " ")
                    Thread.sleep(forTimeInterval: 0.6)
                }
            }
        }
        queue.addOperation(op)
        
        op.addExecutionBlock {
            autoreleasepool {
                for _ in 1..<100 {
                    print("해", separator: " ", terminator: " ")
                    Thread.sleep(forTimeInterval: 0.5)
                }
            }
        }
        
    }
    
    @objc func cancelOpration() {
        print("A")
    }
    func setup() {
        addViews()
        setConstraints()
    }
    
    func addViews() {
        view.addSubview(startOperationBtn)
        view.addSubview(cancelOprationBtn)
    }
    
    func setConstraints() {
        startOperationBtnConstraints()
        cancelOprationBtnConstraints()
    }
    func startOperationBtnConstraints() {
        startOperationBtn.translatesAutoresizingMaskIntoConstraints = false
        startOperationBtn.widthAnchor.constraint(equalToConstant: 100).isActive = true
        startOperationBtn.heightAnchor.constraint(equalToConstant: 100).isActive = true
        startOperationBtn.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100).isActive = true
        startOperationBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    func cancelOprationBtnConstraints() {
        cancelOprationBtn.translatesAutoresizingMaskIntoConstraints = false
        cancelOprationBtn.widthAnchor.constraint(equalToConstant: 100).isActive = true
        cancelOprationBtn.heightAnchor.constraint(equalToConstant: 100).isActive = true
        cancelOprationBtn.topAnchor.constraint(equalTo: startOperationBtn.bottomAnchor, constant:100 ).isActive = true
        cancelOprationBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
}

