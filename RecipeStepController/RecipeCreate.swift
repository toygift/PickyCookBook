//
//  Aaa.swift
//  RecipeStepController
//
//  Created by js on 2017. 8. 18..
//  Copyright © 2017년 sevenTeam. All rights reserved.
//

import UIKit
import MobileCoreServices
import Alamofire
import SwiftyJSON
import AssetsLibrary
import Toaster

class RecipeCreate: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate , UITextFieldDelegate {
    
    // MARK: var, let
    //
    let imagePicker: UIImagePickerController! = UIImagePickerController()
    var flagImageSave = false
    var captureImage: UIImage!
    var videoURL: URL!
    var data: JSON = JSON.init(rawValue: [])!
    
    let firstNameMessage        = "레시피 제목을 입력해주세요"
    let lastNameMessage         = "레시피 설명을 입력해주세요"
    let emailMessage            = "재료를 입력해 주세요"
    let passwordMessage         = "테그를 입력해주세요"
    
    // MARK: OUTLET
    //

    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var descriptionTextField: UITextField!
    @IBOutlet var ingredientTextField: UITextField!
    @IBOutlet var tagTextField: UITextField!
    @IBOutlet var selectPicture: UIButton!
    @IBOutlet var inputStep: UIButton!
    @IBOutlet var cancelRecipe: UIButton!
    @IBOutlet var imageView: UIImageView!
    
    @IBAction func cancelRecipe(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    // MARK: 사진선택
    //
    @IBAction func pictureSelect(_ sender: UIButton){
        let alert = UIAlertController(title: "선택", message: "선택해주세요", preferredStyle: .actionSheet)
        let photo = UIAlertAction(title: "포토라이브러리", style: .default) { (_) in
            self.media(.photoLibrary, flag: false, editing: true)
        }
        let carema = UIAlertAction(title: "카메라", style: .default) { (_) in
            self.media(.camera, flag: true, editing: false)
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(cancel)
        alert.addAction(photo)
        alert.addAction(carema)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: 스텝입력
    //
    @IBAction func nextStep(_ sender: UIButton) {
        guard let title = titleTextField.text else { return }
        guard let description = descriptionTextField.text else { return }
        guard let ingredient = ingredientTextField.text else { return }
        guard let tag = tagTextField.text else { return }
        guard let img_recipe = captureImage else { return }
        
        createRecipe(title: title, description: description, ingredient: ingredient, tag: tag, img_recipe: img_recipe)
    }
    
    // MARK: viewDidLoad()
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        titleTextField.delegate = self
        descriptionTextField.delegate = self
        ingredientTextField.delegate = self
        tagTextField.delegate = self
        
        setupCustomButton()
        textFieldBorderColor()
        textFieldCustom()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        titleTextField.resignFirstResponder()
        descriptionTextField.resignFirstResponder()
        ingredientTextField.resignFirstResponder()
        tagTextField.resignFirstResponder()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(textField.isEqual(self.titleTextField)) {
            self.descriptionTextField.becomeFirstResponder()
        } else if(textField.isEqual(self.descriptionTextField)){
            self.ingredientTextField.becomeFirstResponder()
        } else if(textField.isEqual(self.ingredientTextField)){
            self.tagTextField.becomeFirstResponder()
        } else {
            self.view.endEditing(true)
        }
        
        return true
    }
    // MARK: viewWillAppert 키보드 add옵저버
    //
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: .UIKeyboardWillShow, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: .UIKeyboardWillHide, object: nil)
    }
    // MARK: viewWillDisappear 키보드 remove옵저버
    //
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    
    // MARK: Alert
    // 미사용 -> Toaster로 대체
    func myAlert(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default, handler: nil)
        
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: BackToMain
    //
    @IBAction func backToMain(_ segue: UIStoryboardSegue) {}
}

// MARK: 포토라이브러리, 카메라
//
extension RecipeCreate {
    func media(_ type: UIImagePickerControllerSourceType, flag: Bool, editing: Bool){
        if (UIImagePickerController.isSourceTypeAvailable(type)) {
            flagImageSave = flag
            
            imagePicker.delegate = self
            imagePicker.sourceType = type
            imagePicker.mediaTypes = [kUTTypeImage as String]
            imagePicker.allowsEditing = editing
            
            present(imagePicker, animated: true, completion: nil)
        } else {
            if type == .photoLibrary{
                Toast(text: "포토라이브러리에 접근할수 없음").show()
            } else {
                Toast(text: "카메라에 접근할수 없음").show()
            }
        }
    }
    
    // MARK: 사진, 비디오, 포토라이브러리 선택 끝났을때
    //
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let mediaType = info[UIImagePickerControllerMediaType] as! NSString
        
        if mediaType.isEqual(to: kUTTypeImage as NSString as String){
            captureImage = info[UIImagePickerControllerOriginalImage] as! UIImage
            
            if flagImageSave {
                UIImageWriteToSavedPhotosAlbum(captureImage, self, nil, nil)
            }
            //capture image(이미지 저장된것 처리)
        }
            // 비디오 처리(사용하진 않음)
        else if mediaType.isEqual(to: kUTTypeMovie as NSString as String) {
            if flagImageSave {
                videoURL = (info[UIImagePickerControllerMediaURL] as! URL)
                
                UISaveVideoAtPathToSavedPhotosAlbum(videoURL.relativePath, self, nil, nil)
            }
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: 사진, 비디오 취소시
    //
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}


// MARK: API연결  ALAMOFIRE FUNC
//
extension RecipeCreate {
    func createRecipe(title: String, description: String, ingredient: String, tag: String, img_recipe: UIImage) {
        //        guard let token = UserDefaults.standard.string(forKey: "token") else {
        //            return
        //        }
        //        let url = "http://pickycookbook.co.kr/api/recipe/create/"
        //        let parameters: Parameters = ["title":self.titleTextField.text!, "description":self.descriptionTextField.text!, "ingredient":self.ingredientTextField.text!,"tag":tagTextField.text!]
        //        print("토큰입니다: \(token)")
        //        let headers: HTTPHeaders = ["Authorization":"token \(token)"]
        //
        //        let call = Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
        //        call.responseJSON { (response) in
        //            switch response.result {
        //            case .success(let value):
        //                print(JSON(value))
        //                let recipePK = JSON(value)["pk"].intValue
        //                UserDefaults.standard.set(recipePK, forKey: "PK")
        //                print(recipePK)
        //                print("성공")
        //            case .failure(let error):
        //                print(JSON(error))
        //                print("실패")
        //
        //            }
        //        }
        
        
        guard let token = UserDefaults.standard.string(forKey: "token") else { return }
        
        
        let url = "http://pickycookbook.co.kr/api/recipe/create/"
        let parameters : [String:Any] = ["title":title, "description":description, "ingredient":ingredient,"tag":tag, "img_recipe":img_recipe]
        let headers: HTTPHeaders = ["Authorization":"token \(token)"]
        
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            
            for (key, value) in parameters {
                
                if key == "title" || key == "description" || key == "ingredient" || key == "tag" {
                    
                    multipartFormData.append(("\(value)").data(using: .utf8)!, withName: key)
                } else if let photo = self.captureImage, let imgData = UIImageJPEGRepresentation(photo, 0.25) {
                    multipartFormData.append(imgData, withName: "img_recipe", fileName: "photo.jpg", mimeType: "image/jpg")
                }
                
            }//for
            
        }, to: url, method: .post, headers: headers)
        { (response) in
            switch response {
            case .success(let upload, _, _):
                print("업로드드드드드", upload)
                upload.responseJSON(completionHandler: { (response) in
                    switch response.result {
                    case .success(let value):
                        let json = JSON(value)
                        let recipePK = JSON(value)["pk"].intValue
                        if !(json["title_error"].stringValue.isEmpty) {
                            Toast(text: "제목을 입력하세요").show()
                        } else if !(json["description_error"].stringValue.isEmpty) {
                            Toast(text: "설명을 입력하세요").show()
                        } else if !(json["ingredient_error"].stringValue.isEmpty) {
                            Toast(text: "재료를 입력하세요").show()
                        } else {
                            print("피케이값을 알려줘라",recipePK)
                            UserDefaults.standard.set(recipePK, forKey: "recipePK")
                            print("JSON                   :", value)
                            guard let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "step") else { return
                            }
                            
                            self.present(nextViewController, animated: true, completion: nil)
                        }
                        
                    case .failure(let error):
                        print(error)
                    }
                    print("리스폰스스스스스: ",response)
                    
                })
                
            case .failure(let encodingError):
                print(encodingError)
                Toast(text: "네트워크에러").show()
            }
        }
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
        
        selectPicture.backgroundColor = buttonColor1
        selectPicture.layer.cornerRadius = 10
        selectPicture.layer.borderWidth = 1
        selectPicture.layer.borderColor = UIColor.clear.cgColor
        selectPicture.tintColor = .white
        
        let buttonColor2 = UIColorFromHex(0x20B2AA, alpha: 0.8)
        
        inputStep.backgroundColor = buttonColor2
        inputStep.layer.cornerRadius = 10
        inputStep.layer.borderWidth = 1
        inputStep.layer.borderColor = UIColor.clear.cgColor
        inputStep.tintColor = .white
        
        let buttonColor3 = UIColorFromHex(0x39589A, alpha: 0.8)
        
        cancelRecipe.backgroundColor = buttonColor3
        cancelRecipe.layer.cornerRadius = 10
        cancelRecipe.layer.borderWidth = 1
        cancelRecipe.layer.borderColor = UIColor.clear.cgColor
        cancelRecipe.tintColor = .white
        
    }
    
    func textFieldCustom() {
        titleTextField.keyboardType = .default
        titleTextField.autocorrectionType = UITextAutocorrectionType.no
        titleTextField.isSecureTextEntry = false
        titleTextField.keyboardType = .default
        titleTextField.minimumFontSize = .init(20)
        titleTextField.textColor = .white
        titleTextField.keyboardAppearance = UIKeyboardAppearance.dark
        titleTextField.clearButtonMode = .always
        titleTextField.borderStyle = .none
        titleTextField.returnKeyType = UIReturnKeyType.next
        titleTextField.addBorderBottoms(height: 1.0, color: UIColor.white)
        titleTextField.attributedPlaceholder = NSAttributedString(string: "제목을 입력하세요.",
                                                                  attributes: [NSForegroundColorAttributeName: UIColor.white])
        
        
        
        descriptionTextField.keyboardType = .default
        descriptionTextField.autocorrectionType = UITextAutocorrectionType.no
        descriptionTextField.isSecureTextEntry = false
        descriptionTextField.keyboardType = .default
        descriptionTextField.minimumFontSize = .init(20)
        descriptionTextField.textColor = .white
        descriptionTextField.keyboardAppearance = UIKeyboardAppearance.dark
        descriptionTextField.clearButtonMode = .always
        descriptionTextField.borderStyle = .none
        descriptionTextField.returnKeyType = UIReturnKeyType.next
        descriptionTextField.addBorderBottoms(height: 1.0, color: UIColor.white)
        descriptionTextField.attributedPlaceholder = NSAttributedString(string: "레시피 정보를 입력하세요.",
                                                                        attributes: [NSForegroundColorAttributeName: UIColor.white])
        
        
        
        
        
        
        ingredientTextField.keyboardType = .default
        ingredientTextField.autocorrectionType = UITextAutocorrectionType.no
        ingredientTextField.isSecureTextEntry = false
        ingredientTextField.keyboardType = .default
        ingredientTextField.minimumFontSize = .init(20)
        ingredientTextField.textColor = .white
        ingredientTextField.keyboardAppearance = UIKeyboardAppearance.dark
        ingredientTextField.clearButtonMode = .always
        ingredientTextField.borderStyle = .none
        ingredientTextField.returnKeyType = UIReturnKeyType.next
        ingredientTextField.addBorderBottoms(height: 1.0, color: UIColor.white)
        ingredientTextField.attributedPlaceholder = NSAttributedString(string: "재료 정보를 입력하세요.",
                                                                       attributes: [NSForegroundColorAttributeName: UIColor.white])
        
        
        
        tagTextField.keyboardType = .default
        tagTextField.autocorrectionType = UITextAutocorrectionType.no
        tagTextField.isSecureTextEntry = false
        tagTextField.keyboardType = .default
        tagTextField.minimumFontSize = .init(20)
        tagTextField.textColor = .white
        tagTextField.keyboardAppearance = UIKeyboardAppearance.dark
        tagTextField.clearButtonMode = .always
        tagTextField.borderStyle = .none
        tagTextField.returnKeyType = UIReturnKeyType.done
        tagTextField.addBorderBottoms(height: 1.0, color: UIColor.white)
        tagTextField.attributedPlaceholder = NSAttributedString(string: "태그 정보를 입력하세요.",
                                                                attributes: [NSForegroundColorAttributeName: UIColor.white])

    }
}

// MARK: TextField Custom
//
//extension RecipeCreate {
//    
//    func keyboardWillShow(notification:Notification) {
//        guard let keyboardHeight = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue else { return }
//        imageView.contentInset = UIEdgeInsetsMake(0, 0, keyboardHeight.height, 0)
//    }
//    
//    func keyboardWillHide(notification:Notification) {
//        imageView.contentInset = .zero
//    }

    //    func validateData() -> Bool {
    //
    //        guard !titleTextField.text!.isEmptyStr else {
    //            titleTextField.showError(message: firstNameMessage)
    //            return false
    //        }
    //
    //        guard !descriptionTextField.text!.isEmptyStr else {
    //            descriptionTextField.showError(message: lastNameMessage)
    //            return false
    //        }
    //
    //        guard !ingredientTextField.text!.isEmptyStr else {
    //            ingredientTextField.showError(message: emailMessage)
    //            return false
    //        }
    //
    //        guard !tagTextField.text!.isEmptyStr else {
    //            tagTextField.showError(message: passwordMessage)
    //            return false
    //        }
    //
    //        return true
    //    }
    
//}

// MARK: Border Setting
//
extension RecipeCreate {
    
    func textFieldBorderColor(){
        
        selectPicture.layer.borderColor = UIColor.black.cgColor
        selectPicture.layer.borderWidth = 0.5
        selectPicture.layer.cornerRadius = 10
        
        inputStep.layer.borderColor = UIColor.black.cgColor
        inputStep.layer.borderWidth = 0.5
        inputStep.layer.cornerRadius = 10

        

        
        
    }
}


