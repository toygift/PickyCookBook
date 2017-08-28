//
//  SignUpViewController.swift
//  RecipeStepController
//
//  Created by js on 2017. 8. 20..
//  Copyright © 2017년 sevenTeam. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Toaster

class SignUpPage: UIViewController, UITextFieldDelegate {
    // MARK: var, let
    //
    var data: JSON = JSON.init(rawValue: [])!
    let firstNameMessage        = "email을 입력하세요"
    let lastNameMessage         = "닉네임을 입력하세요"
    let emailMessage            = "패스워드를 입력하세요"
    let passwordMessage         = "패스워드를 확인합니다"
    
    // MARK: Outlet
    //
//    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var emailInputTextField: UITextField!
    @IBOutlet var nicknameInputTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var passwordVerifyTextField: UITextField!
    @IBOutlet var signupButtons: UIButton!
    @IBOutlet var cancel: UIButton!
    
    @IBAction func cancelsignup(_ sender: UIButton){
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func signupButton(_ sender: UIButton) {
        // guard validateData() else { return }
        guard let email = emailInputTextField.text else { return }
        guard let nickname = nicknameInputTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        guard let passwordConfirm = passwordVerifyTextField.text else { return }
        
        createUserData(email: email, nickname: nickname, password: password, passwordConfirm: passwordConfirm)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailInputTextField.delegate = self
        nicknameInputTextField.delegate = self
        passwordTextField.delegate = self
        passwordVerifyTextField.delegate = self
        
        
        emailInputTextField.delegate = self
        passwordTextField.delegate = self
        passwordVerifyTextField.delegate = self
        nicknameInputTextField.delegate = self
        
        textFieldCustom()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        emailInputTextField.resignFirstResponder()
        nicknameInputTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        passwordVerifyTextField.resignFirstResponder()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(textField.isEqual(self.emailInputTextField)) {
            self.passwordTextField.becomeFirstResponder()
        } else if(textField.isEqual(self.passwordTextField)){
            self.passwordVerifyTextField.becomeFirstResponder()
        } else if(textField.isEqual(self.passwordVerifyTextField)){
            self.nicknameInputTextField.becomeFirstResponder()
        } else {
            self.view.endEditing(true)
        }
        
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: .UIKeyboardWillShow, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
        
        self.emailInputTextField.text = ""
        self.nicknameInputTextField.text = ""
        self.passwordTextField.text = ""
        self.passwordVerifyTextField.text = ""
    }
}

// MARK: ALAMOFIRE
//
extension SignUpPage {
    func createUserData(email: String, nickname: String, password: String, passwordConfirm: String) {
        
        
        let url = "http://pickycookbook.co.kr/api/member/create/"
        let parameters: Parameters = ["email":email, "nickname":nickname, "password1":password, "password2":passwordConfirm]
        let headers : HTTPHeaders = ["Content-Type":"application/json"]
        
        let call = Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
        
        call.responseJSON { (response) in
            
            switch response.result {
            case .success(let value):
                
                print("가입성공")
                let json = JSON(value)
                print("JSON: \(json)")
                
                if !(json["email_empty"].stringValue.isEmpty) {
                    Toast(text: "email을 입력해주세요").show()
                } else if !(json["empty_password1"].stringValue.isEmpty) {
                    Toast(text: "password를 입력해주세요").show()
                } else if !(json["empty_password2"].stringValue.isEmpty) {
                    Toast(text: "password확인을 입력해주세요").show()
                } else if !(json["nickname_empty"].stringValue.isEmpty) {
                    Toast(text: "닉네임을 입력해주세요").show()
                } else if !(json["passwords_not_match"].stringValue.isEmpty) {
                    Toast(text: "입력된 패스워드가 일치하지 않습니다").show()
                } else if !(json["email_error"].stringValue.isEmpty) {
                    Toast(text: "다른사용자가 사용중인 이메일입니다").show()
                } else if !(json["nickname_error"].stringValue.isEmpty){
                    Toast(text: "다른사용자가 사용중인 닉네임입니다").show()
                } else if !(json["email_invalid"].stringValue.isEmpty){
                    Toast(text: "유효한이메일입력해주세요").show()
                } else if !(json["empty_passwords"].stringValue.isEmpty){
                    Toast(text: "password를 입력해주세요").show()
                } else if !(json["too_short_password"].stringValue.isEmpty){
                    Toast(text: "password는 최소4자이상 이어야합니다").show()
                } else {
                    guard let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "MyPageStoryBoard") else {
                        return
                    }
                    self.present(nextViewController, animated: true, completion: nil)
                    
                }
                
            case .failure(let error):
                print(JSON(error))
                Toast(text: "네트워크에러").show()
            }
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        print("텍스트 필드 수정 시작")
        

        emailInputTextField.alpha = 1
        passwordTextField.alpha = 1
        passwordVerifyTextField.alpha = 1
        nicknameInputTextField.alpha = 1
        return true
    }
    

}

//extension SignUpPage {
//    
//    func keyboardWillShow(notification:Notification) {
//        guard let keyboardHeight = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue else { return }
//        scrollView.contentInset = UIEdgeInsetsMake(0, 0, keyboardHeight.height, 0)
//    }
//    
//    func keyboardWillHide(notification:Notification) {
//        scrollView.contentInset = .zero
//    }

    //    func validateData() -> Bool {
    //
    //        guard !emailInputTextField.text!.isEmptyStr else {
    //            emailInputTextField.showError(message: firstNameMessage)
    //            return false
    //        }
    //
    //        guard !nicknameInputTextField.text!.isEmptyStr else {
    //            nicknameInputTextField.showError(message: lastNameMessage)
    //            return false
    //        }
    //
    //        guard !passwordTextField.text!.isEmptyStr else {
    //            passwordTextField.showError(message: emailMessage)
    //            return false
    //        }
    //
    //        guard !passwordVerifyTextField.text!.isEmptyStr else {
    //            passwordVerifyTextField.showError(message: passwordMessage)
    //            return false
    //        }
    //         createUserData(email: emailInputTextField.text!, nickname: nicknameInputTextField.text!, password: passwordTextField.text!, passwordConfirm: passwordVerifyTextField.text!)
    //        return true
    //    }
    
//}
extension SignUpPage {
    func alerts(_ message: String, completion: (()->Void)? = nil) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "확인", style: .default) { (_) in
                completion?()
            }
            alert.addAction(okAction)
            self.present(alert, animated: true)
        }
    }
}
// MARK: Border setting
//
extension SignUpPage {
    func textFieldCustom() {
        
        emailInputTextField.autocorrectionType = UITextAutocorrectionType.no
        emailInputTextField.keyboardType = .emailAddress
        emailInputTextField.minimumFontSize = .init(20)
        emailInputTextField.textColor = .white
        emailInputTextField.keyboardAppearance = UIKeyboardAppearance.dark
        emailInputTextField.clearButtonMode = .always
        emailInputTextField.borderStyle = .none
        emailInputTextField.becomeFirstResponder()
        emailInputTextField.returnKeyType = UIReturnKeyType.done
        emailInputTextField.addBorderBottoms(height: 1.0, color: UIColor.lightGray)
        emailInputTextField.attributedPlaceholder = NSAttributedString(string: "Email",
                                                                  attributes: [NSForegroundColorAttributeName: UIColor.white])
        
        
        passwordTextField.keyboardType = .default
        passwordTextField.autocorrectionType = UITextAutocorrectionType.no
        passwordTextField.isSecureTextEntry = true
        passwordTextField.keyboardType = .default
        passwordTextField.minimumFontSize = .init(20)
        passwordTextField.textColor = .white
        passwordTextField.keyboardAppearance = UIKeyboardAppearance.dark
        passwordTextField.clearButtonMode = .always
        passwordTextField.borderStyle = .none
        passwordTextField.returnKeyType = UIReturnKeyType.done
        passwordTextField.addBorderBottoms(height: 1.0, color: UIColor.lightGray)
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password",
                                                                     attributes: [NSForegroundColorAttributeName: UIColor.white])
        
        passwordVerifyTextField.keyboardType = .default
        passwordVerifyTextField.autocorrectionType = UITextAutocorrectionType.no
        passwordVerifyTextField.isSecureTextEntry = true
        passwordVerifyTextField.minimumFontSize = .init(20)
        passwordVerifyTextField.textColor = .white
        passwordVerifyTextField.keyboardAppearance = UIKeyboardAppearance.dark
        passwordVerifyTextField.clearButtonMode = .always
        passwordVerifyTextField.borderStyle = .none
        passwordVerifyTextField.returnKeyType = UIReturnKeyType.done
        passwordVerifyTextField.addBorderBottoms(height: 1.0, color: UIColor.lightGray)
        passwordVerifyTextField.attributedPlaceholder = NSAttributedString(string: "Repeat Password",
                                                                            attributes: [NSForegroundColorAttributeName: UIColor.white])
        
        nicknameInputTextField.keyboardType = .default
        nicknameInputTextField.autocorrectionType = UITextAutocorrectionType.no
        nicknameInputTextField.minimumFontSize = .init(20)
        nicknameInputTextField.textColor = .white
        nicknameInputTextField.keyboardAppearance = UIKeyboardAppearance.dark
        nicknameInputTextField.clearButtonMode = .always
        nicknameInputTextField.borderStyle = .none
        nicknameInputTextField.returnKeyType = UIReturnKeyType.done
        nicknameInputTextField.addBorderBottoms(height: 1.0, color: UIColor.lightGray)
        nicknameInputTextField.attributedPlaceholder = NSAttributedString(string: "Nick Name",
                                                                     attributes: [NSForegroundColorAttributeName: UIColor.white])
        
        
    }
}

