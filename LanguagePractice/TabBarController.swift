//
// The  project.
// Created by optionaldev on 31/05/2022.
// Copyright © 2022 optionaldev. All rights reserved.
// 

import UIKit

final class TabBarController: UITabBarController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let homeItem = UITabBarItem(title: "home", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house"))
    let lexiconItem = UITabBarItem(title: "lexicon", image: UIImage(systemName: "a.book.closed"), selectedImage: UIImage(systemName: "a.book.closed"))
    let settingsItem = UITabBarItem(title: "settings", image: UIImage(systemName: "wrench.and.screwdriver"), selectedImage: UIImage(systemName: "wrench.and.screwdriver"))

    let homeVC = HomeViewController()
    homeVC.tabBarItem = homeItem
    
    let lexiconVC = LexiconViewController()
    lexiconVC.tabBarItem = lexiconItem
    
    let settingsVC = SettingsViewController()
    settingsVC.tabBarItem = settingsItem
    
    viewControllers = [homeVC, lexiconVC, settingsVC]
    tabBar.backgroundColor = .white
  }
}

