//
//  BookMarkList.swift
//  RecipeStepController
//
//  Created by jaeseong on 2017. 8. 23..
//  Copyright © 2017년 sevenTeam. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Toaster

class BookMarkListPage: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var data: JSON = JSON.init(rawValue: [])!
    
    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        fetchBookMakrData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    @IBAction func ok(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
extension BookMarkListPage {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bookmarklist") as? BookMarkListCell
        
        let recipeTitle = self.data[indexPath.row]["recipe_title"].stringValue
        let recipePK = self.data[indexPath.row]["recipe"].intValue
        let recipeMemo = self.data[indexPath.row]["memo"].stringValue
        UserDefaults.standard.set(recipePK, forKey: "recipePKDetail")
        print(recipeMemo)
        print("UserDefaults                       :",UserDefaults.standard.object(forKey: "recipePKDetail") as! Int)
        
        cell?.recipeTitle.text = recipeTitle
        cell?.recipeMemo.text = recipeMemo
        
        return cell!
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            var memo = self.data.arrayValue
            
            print(memo)
            
            
            memo.remove(at: (indexPath as NSIndexPath).row)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        }else if editingStyle == .insert {
            
        }
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "삭제"
        
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        var memo = self.data.arrayValue
        
       
        let itemImageToMove = memo[(sourceIndexPath as NSIndexPath).row]
        
        memo.remove(at: (sourceIndexPath as NSIndexPath).row)
        
        memo.insert(itemImageToMove, at: (destinationIndexPath as NSIndexPath).row)
        
        
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: editing)
        tableView.setEditing(editing, animated: editing)
    }
    
    @IBAction func backToPage(_ sender: UIButton) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
}

extension BookMarkListPage {
    func fetchBookMakrData() {
        
        guard let token = UserDefaults.standard.string(forKey: "token") else { return }
        
        let url = "http://pickycookbook.co.kr/api/recipe/bookmark/"
        let headers: HTTPHeaders = ["Authorization":"token \(token)"]
        
        let call = Alamofire.request(url, method: .get, encoding: JSONEncoding.default, headers: headers)
        call.responseJSON { (response) in
            switch response.result {
            case .success(let value):
                
                self.data = JSON(value)
                self.tableView.reloadData()
                print(self.data)
                
            case .failure(let error):
                print(error)
            }
        }
    }
}
