//
//  MainTabbarControllerViewController.swift
//  RecipeStepController
//
//  Created by jaeseong on 2017. 9. 1..
//  Copyright © 2017년 sevenTeam. All rights reserved.
//

import UIKit

class MainTabbarControllerViewController: UITabBarController, UITabBarControllerDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let token = UserDefaults.standard.string(forKey: "token")
        if !(token?.isEmpty)! {
            let nextview = storyboard?.instantiateViewController(withIdentifier: "MyPageStoryBoard")
            self.present(nextview!, animated: true, completion: nil)
        }
        
        return true
    }
}

