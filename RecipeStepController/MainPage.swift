//
//  MainPageViewController.swift
//  PickyCookBook
//
//  Created by jaeseong on 2017. 8. 11..
//  Copyright © 2017년 유하늘. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class MainPage: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource  {
    
    @IBOutlet weak var mainCollectionView: UICollectionView!
    
    let recipesURL = "http://pickycookbook.co.kr/api/recipe/"
    var pickyData:JSON = JSON.init(rawValue: [])!
    //    let sampleImage:[String] = ["1", "2", "3", "4", "5","1", "2", "3", "4", "5"]
    
    
    //=================================================================================================//
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        RecipesApi()
        print(RecipesApi())
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //=================================================================================================//
    
    
    
    ///Data
    //=================================================================================================//
    func refreshData() {
        DispatchQueue.main.async {
            self.mainCollectionView.reloadData()
        }
    }
    
    func RecipesApi() {
        Alamofire.request(recipesURL).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                self.pickyData = JSON(value)
                self.refreshData()
                break
            case .failure(let error):
                print(error)
                break
            }
        }
    }
    
    //=================================================================================================//
    
    
    @IBAction func searchButton(_ sender: Any) {
        
        guard let nextView = self.storyboard?.instantiateViewController(withIdentifier: "SearchPageStoryBoard") else {
            return
        }
        
        self.present(nextView, animated: true, completion: nil)
        
    }
    
    
    
    
    
    ///CollectionView
    //=================================================================================================//
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return pickyData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainCell", for: indexPath) as! MainPageCell
        let recipesTitle = pickyData[indexPath.row]["title"]
        //        let recipesImage = pickyData[indexPath.row]["img_recipe"]
        
        //        cell.recipesImage.image = UIImage.init(named: sampleImage[indexPath.row] + ".jpg")
        if let path = self.pickyData[indexPath.row]["img_recipe"].string {
            if let imageApi = try? Data(contentsOf: URL(string: path)!) {
                cell.recipesImage.image = UIImage(data: imageApi)
            }
        }
        cell.recipesImage.layer.cornerRadius = cell.recipesImage.frame.size.height/30
        cell.recipesTitle.text = recipesTitle.stringValue
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let dvc = self.storyboard?.instantiateViewController(withIdentifier: "DetailPageStoryBoard") as? DetailPage else {
            return
        }
        
        let sendRecipePk = self.pickyData[indexPath.row]["pk"].intValue
        // 값 전달
        dvc.recivedPk = sendRecipePk
        self.present(dvc, animated: true)
        
    }
    
}

// MARK: Textfield Effect
// 익스텐션 : 텍스트 필드 커스텀
extension UITextField {
    func addBorderBottoms(height: CGFloat, color: UIColor) {
        let border = CALayer()
        border.frame = CGRect(x: 0, y: self.frame.height-height, width: self.frame.width, height: height)
        border.backgroundColor = color.cgColor
        self.layer.addSublayer(border)
    }
}
