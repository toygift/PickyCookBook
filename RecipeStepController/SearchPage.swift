//
//  SearchViewController.swift
//  PickyCookBook
//
//  Created by ParkGuy on 2017. 8. 19..
//  Copyright © 2017년 유하늘. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SearchPage: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var searchCollection: UICollectionView!
    @IBOutlet weak var searchTF: UITextField!
    
    var pickyData:JSON = JSON.init(rawValue: [])!
    var resultData:JSON = JSON.init(rawValue: [])!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldCustom()
        searchTF.delegate = self
        self.searchTF.resignFirstResponder()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        searchTF.resignFirstResponder()
        
    }
 
    
//    @IBAction func keyBoard(_ sender: Any) {
//        
//        searchTF.resignFirstResponder()
//    }
    
    
    @IBAction func cancelButton(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        keyperformAvtion()
        if(textField.isEqual(self.searchTF)) {
            self.view.endEditing(true)
        }
        
        return true
    }
    
    func keyperformAvtion() {
        
        let searchText = searchTF.text
        let recipesURL = "http://pickycookbook.co.kr/api/recipe/search/?search=" + searchText!
        let searchEncoding = recipesURL.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        
        Alamofire.request(searchEncoding!).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                self.pickyData = JSON(value)
                self.resultValue()
                self.refreshData()
                print(self.pickyData)
                break
            case .failure(let error):
                print(error)
                break
            }
        }
    }
    
    func refreshData() {
        DispatchQueue.main.async {
            self.searchCollection.reloadData()
        }
    }
    
    func resultValue() {
        
        let resultApi = pickyData["results"]
        
        self.resultData = resultApi
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return resultData.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //        let resultCell = pickyData[indexPath.row]["results"]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "search", for: indexPath) as! SearchResultCollectionViewCell
        
        cell.recipesTitle.text = resultData[indexPath.row]["title"].stringValue
        if let path = resultData[indexPath.row]["img_recipe"].string {
            if let imageApi = try? Data(contentsOf: URL(string: path)!) {
                cell.recipesImage.image = UIImage(data: imageApi)
            }
        }
        cell.recipesImage.layer.cornerRadius = cell.recipesImage.frame.size.height/30
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let dvc = self.storyboard?.instantiateViewController(withIdentifier: "DetailPageStoryBoard") as? DetailPage else {
            return
        }
        
        let sendRecipePk = self.resultData[indexPath.row]["pk"].intValue
        // 값 전달
        dvc.recivedPk = sendRecipePk
        self.present(dvc, animated: true)
        
    }
}

extension SearchPage {
    func textFieldCustom(){


        // 패스워드 텍스트 필드 커스텀
        searchTF.autocorrectionType = UITextAutocorrectionType.no


        searchTF.keyboardAppearance = UIKeyboardAppearance.light
        searchTF.clearButtonMode = .always
        searchTF.borderStyle = .none
        searchTF.returnKeyType = UIReturnKeyType.done
        searchTF.attributedPlaceholder = NSAttributedString(string: "검색 내용을 입력해주세요.",
                                                                           attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
        
    }
}
