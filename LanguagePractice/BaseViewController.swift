//
// The LanguagePractice project.
// Created by optionaldev on 06/06/2022.
// Copyright © 2022 optionaldev. All rights reserved.
// 

import UIKit

class BaseViewController: UIViewController {
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    
    log("\(Self.self) init", object: self, type: .info, filePath: "")
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  deinit {
    log("\(Self.self) deinit", object: self, type: .info, filePath: "")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    log("\(Self.self) viewDidLoad", object: self, type: .info, filePath: "")
  }
}
