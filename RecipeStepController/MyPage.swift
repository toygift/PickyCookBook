//
//  MyPageViewController.swift
//  RecipeStepController
//
//  Created by js on 2017. 8. 21..
//  Copyright © 2017년 sevenTeam. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Toaster


class MyPage: UIViewController {
    
    @IBOutlet weak var myInfoPageGoBtn: UIButton!
    @IBOutlet weak var myBookmarkGoBtn: UIButton!
    @IBOutlet weak var myRecipeMakePageGoBtn: UIButton!
    @IBOutlet weak var goToMainBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCustomButton()
        
    }
    
    
    
    @IBAction func myInfoPageGoBtn(_ sender: UIButton) {
        guard let nextView = self.storyboard?.instantiateViewController(withIdentifier: "MyInfoModifyPageStoryBoard") else {
            return
        }
        
        self.present(nextView, animated: true, completion: nil)
    }
    @IBAction func backtomain(_ sender: Any) {
        let nextview = storyboard?.instantiateViewController(withIdentifier: "MainTabBar")
        self.present(nextview!, animated: true, completion: nil)
    }
    
    @IBAction func myBookmarkGoBtn(_ sender: UIButton) {
        guard let nextView = self.storyboard?.instantiateViewController(withIdentifier: "BookMarkListPageStoryBoard") else {
            return
        }
        
        self.present(nextView, animated: true, completion: nil)
    }
    
    @IBAction func myRecipeMakePageGoBtn(_ sender: UIButton) {
        guard let nextView = self.storyboard?.instantiateViewController(withIdentifier: "RecipeCreateStoryBoard") else {
            return
        }
        
        self.present(nextView, animated: true, completion: nil)
    }
    

    
    
    // CGFloat 값을 간단하게 헥사 코드로 입력 할 수 있는 코드
    func UIColorFromHex(_ rgbValue:UInt32, alpha:Double=1.0) -> UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
    
    // 로그인 버튼 커스텀
    func setupCustomButton() {
        
        
        let buttonColor1 = UIColorFromHex(0x20B2AA, alpha: 0.8)
        
        myInfoPageGoBtn.backgroundColor = buttonColor1
        myInfoPageGoBtn.layer.cornerRadius = 10
        myInfoPageGoBtn.layer.borderWidth = 1
        myInfoPageGoBtn.layer.borderColor = UIColor.clear.cgColor
        myInfoPageGoBtn.tintColor = .white
        
        let buttonColor2 = UIColorFromHex(0x20B2AA, alpha: 0.8)
        
        myBookmarkGoBtn.backgroundColor = buttonColor2
        myBookmarkGoBtn.layer.cornerRadius = 10
        myBookmarkGoBtn.layer.borderWidth = 1
        myBookmarkGoBtn.layer.borderColor = UIColor.clear.cgColor
        myBookmarkGoBtn.tintColor = .white
        
        let buttonColor3 = UIColorFromHex(0x39589A, alpha: 0.8)
        
        myRecipeMakePageGoBtn.backgroundColor = buttonColor3
        myRecipeMakePageGoBtn.layer.cornerRadius = 10
        myRecipeMakePageGoBtn.layer.borderWidth = 1
        myRecipeMakePageGoBtn.layer.borderColor = UIColor.clear.cgColor
        myRecipeMakePageGoBtn.tintColor = .white
        
        
        let buttonColor4 = UIColorFromHex(0x6666FF, alpha: 0.8)
        
        goToMainBtn.backgroundColor = buttonColor4
        goToMainBtn.layer.cornerRadius = 10
        goToMainBtn.layer.borderWidth = 1
        goToMainBtn.layer.borderColor = UIColor.clear.cgColor
        goToMainBtn.tintColor = .white
        
    }
    
    
}

