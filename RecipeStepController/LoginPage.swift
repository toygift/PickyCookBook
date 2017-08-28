//
//  LoginPage.swift
//  PickyCookBook
//
//  Created by 이재성 on 2017. 8. 3..
//  Copyright © 2017년 이재성. All rights reserved.
//

import UIKit
import AVFoundation
import Alamofire
import SwiftyJSON
import FBSDKLoginKit
import FBSDKCoreKit
import Toaster

class LoginPage: UIViewController, FBSDKLoginButtonDelegate ,UITextFieldDelegate{
    
    // MARK: var, let
    var data: JSON = JSON.init(rawValue: [])!
    let emailMessage            = "이메일을 입력해주세요"
    let passwordMessage         = "패스워드를 입력해주세요"
    
    // MARK: Outlet
    //
    //    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var emailInputTextField: UITextField!
    @IBOutlet var passwordIntputTextField: UITextField!
    @IBOutlet var loginB: UIButton!
    @IBOutlet var signupB: UIButton!
    @IBOutlet weak var toMainB: UIButton!
    @IBOutlet weak var tabbar: UITabBarItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        videoURL = Bundle.main.url(forResource: "loginBackground", withExtension: "mov")! as NSURL
        self.setupVideoBackgrond()
        
        emailInputTextField.delegate = self
        passwordIntputTextField.delegate = self
        
        setupLoginButton()
        facebookSigninButton()
        textFieldCustom()
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        emailInputTextField.resignFirstResponder()
        passwordIntputTextField.resignFirstResponder()
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(textField.isEqual(self.emailInputTextField)) {
            self.passwordIntputTextField.becomeFirstResponder()
        } else if(textField.isEqual(self.passwordIntputTextField)){
            self.view.endEditing(true)
        }
        
        return true
    }
    
    @IBAction func login(_ sender: UIButton){
        guard let email = emailInputTextField.text else { return }
        guard let password = passwordIntputTextField.text else { return }
        
        loginUserData(email: email, password: password)
    }
    
    @IBAction func signUpButton(_ sender: UIButton) {
        let signupconnect = storyboard?.instantiateViewController(withIdentifier: "SignUpPageStoryBoard") as? SignUpPage
        self.navigationController?.pushViewController(signupconnect!, animated: true)
    }
    
    // MARK: Facebook LoginButton
    func facebookSigninButton(){
        
        //        let loginButton = FBSDKLoginButton()
        //        loginButton.layer.borderColor = UIColor.black.cgColor
        ////        loginButton.layer.borderWidth = 0.5
        ////        loginButton.layer.cornerRadius = 10
        //
        //        loginButton.frame = CGRect(x: 50, y: 250, width: 275, height: 38)
        //
        //        loginButton.delegate = self
        //        loginButton.readPermissions = ["email","public_profile"]
        //
        //
        //        view.addSubview(loginButton)
        
        //Facebook login Costom
        let customFBButton = UIButton(type: .system)
        let buttonColor = UIColor(red: 59 / 255, green: 89 / 255, blue: 152 / 255, alpha: 0.9)
        customFBButton.backgroundColor = buttonColor
        customFBButton.frame = CGRect(x: 50, y: 250, width: 275, height: 38)
        customFBButton.setTitle("FaceBookLogin", for: .normal)
        customFBButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        customFBButton.setTitleColor(.white, for: .normal)
        customFBButton.layer.cornerRadius = 10
        
        view.addSubview(customFBButton)
        customFBButton.addTarget(self, action: #selector(handleCostomFBlogin), for: .touchUpInside)
    }
    
    func handleCostomFBlogin() {
        FBSDKLoginManager().logIn(withReadPermissions: ["email", "public_profile"], from: self) { (result, err) in
            if err != nil {
                print(11)
                return
            }
            
            let accessToken = FBSDKAccessToken.current()
            
            guard let accessTokenString = accessToken?.tokenString else { return }
            print("페이스북토큰:   ",accessTokenString)
            self.faceBookSignin(token: accessTokenString)
        }
    }
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("did log out facebook")
    }
    
    // MARK: Facebook login get Token
    //
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
        if error != nil {
            print(error)
            return
        }
        
        let accessToken = FBSDKAccessToken.current()
        
        guard let accessTokenString = accessToken?.tokenString else { return }
        print("페이스북토큰:   ",accessTokenString)
        self.faceBookSignin(token: accessTokenString)
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
        self.passwordIntputTextField.text = ""
    }
    @IBAction func backToMainButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    // MARK: Background Effect
    //
    public var videoURL: NSURL? {
        didSet {
            setupVideoBackgrond()
        }
    }
    
    public var loginButtonColor: UIColor? {
        didSet {
            setupLoginButton()
        }
    }
    
    
    // 로그인 페이지 백그라운드 설정
    func setupVideoBackgrond() {
        
        var theURL = NSURL()
        if let url = videoURL {
            
            let shade = UIView(frame: self.view.frame)
            shade.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
            view.addSubview(shade)
            view.sendSubview(toBack: shade)
            
            theURL = url
            
            var avPlayer = AVPlayer()
            avPlayer = AVPlayer(url: theURL as URL)
            let avPlayerLayer = AVPlayerLayer(player: avPlayer)
            avPlayerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
            avPlayer.volume = 0
            avPlayer.actionAtItemEnd = AVPlayerActionAtItemEnd.none
            
            avPlayerLayer.frame = view.layer.bounds
            
            let layer = UIView(frame: self.view.frame)
            view.backgroundColor = UIColor.clear
            view.layer.insertSublayer(avPlayerLayer, at: 0)
            view.addSubview(layer)
            view.sendSubview(toBack: layer)
            
            NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidReachEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: avPlayer.currentItem)
            
            avPlayer.play()
        }
    }
    
    
 
    
    
    // 메인 이동 버튼
    func playerItemDidReachEnd(notification: NSNotification) {
        
        if let p = notification.object as? AVPlayerItem {
            p.seek(to: kCMTimeZero)
        }
    }
}
// MARK: Facebook Login
//
extension LoginPage {
    func faceBookSignin(token: String){
        let url = "http://pickycookbook.co.kr/api/member/facebook-login/"
        let parameters: Parameters = ["token":token]
        let call = Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
        
        call.responseJSON { (response) in
            
            switch response.result {
            case .success(let value):
                
                let json = JSON(value)
                let currentUserToken = json["token"].stringValue
                UserDefaults.standard.set(currentUserToken, forKey: "token")
                let currentUserPk = json["pk"].intValue
                UserDefaults.standard.set(currentUserPk, forKey: "userPK")
                // UserDefaults 에 토큰 저장
                
                
                guard let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "MyPageStoryBoard") else {
                    return
                }
                self.present(nextViewController, animated: true, completion: nil)
                
            case .failure(let error):
                Toast(text: "네트워크에러").show()
                print(error)
            }
        }
    }
    // MARK: Email Login
    //
    func loginUserData(email: String, password: String) {
        
        let url = "http://pickycookbook.co.kr/api/member/login/"
        let parameters: Parameters = ["email":email, "password":password]
        let headers: HTTPHeaders = ["Content-Type":"application/json"]
        let call = Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
        
        call.responseJSON { (response) in
            
            switch response.result {
            case .success(let value):
                
                let json = JSON(value)
                print(json)
                if !(json["email_empty"].stringValue.isEmpty) {
                    Toast(text: "email을 입력해주세요").show()
                } else if !(json["empty_password1"].stringValue.isEmpty) {
                    Toast(text: "password를 입력해주세요").show()
                } else if !(json["empty_error"].stringValue.isEmpty) {
                    Toast(text: "email과 password를 입력해주세요").show()
                } else if !(json["login_error"].stringValue.isEmpty) {
                    Toast(text: "email 또는 비밀번호가 맞지 않습니다").show()
                } else {
                    // UserDefaults 에 토큰 저장
                    let currentUserToken = json["token"].stringValue
                    UserDefaults.standard.set(currentUserToken, forKey: "token")
                    let currentUserPk = json["pk"].intValue
                    UserDefaults.standard.set(currentUserPk, forKey: "userPK")
                    
                    guard let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "MyPageStoryBoard") else {
                        return
                    }
                    self.present(nextViewController, animated: true, completion: nil)
                }
                
                
                
            case .failure(let error):
                Toast(text: "네트워크에러").show()
                print(error)
                
            }
        }
    }
    
    
}

// MARK: 키보드
//
//extension LoginPage {
//
//    func keyboardWillShow(notification:Notification) {
//        guard let keyboardHeight = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue else { return }
//        view.contentInset = UIEdgeInsetsMake(0, 0, keyboardHeight.height, 0)
//    }
//
//    func keyboardWillHide(notification:Notification) {
//        view.contentInset = .zero
//    }
//
//    //    func validateData() -> Bool {
//    //
//    //        guard !emilInputTextField.text!.isEmptyStr else {
//    //            emilInputTextField.showError(message: emailMessage)
//    //            return false
//    //        }
//    //
//    //        guard !passwordIntputTextField.text!.isEmptyStr else {
//    //            passwordIntputTextField.showError(message: passwordMessage)
//    //            return false
//    //        }
//    //        loginUserData(email: emilInputTextField.text!, password: passwordIntputTextField.text!)
//    //
//    //
//    //        return true
//    //    }
//
//}
// MARK: Alert custom
//
extension LoginPage {
    func alert(_ message: String, completion: (()->Void)? = nil) {
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
// MARK: TextField Custom
//
extension LoginPage {
    func textFieldCustom(){
        // 이메일 텍스트 필드 커스텀
        
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
                                                                       attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
        
        // 패스워드 텍스트 필드 커스텀
        passwordIntputTextField.autocorrectionType = UITextAutocorrectionType.no
        passwordIntputTextField.isSecureTextEntry = true
        passwordIntputTextField.minimumFontSize = .init(30)
        passwordIntputTextField.textColor = .white
        passwordIntputTextField.keyboardAppearance = UIKeyboardAppearance.dark
        passwordIntputTextField.clearButtonMode = .always
        passwordIntputTextField.borderStyle = .none
        passwordIntputTextField.returnKeyType = UIReturnKeyType.done
        passwordIntputTextField.addBorderBottoms(height: 1.0, color: UIColor.lightGray)
        passwordIntputTextField.attributedPlaceholder = NSAttributedString(string: "Password",
                                                                           attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
        
        
    }
    
    // 로그인 버튼 커스텀
    func setupLoginButton() {
        
        
        let buttonColor = UIColor(red: 20 / 255, green: 230 / 255, blue: 167 / 255, alpha: 0.9)
        
        loginB.backgroundColor = buttonColor
        loginB.layer.cornerRadius = 10
        loginB.layer.borderWidth = 1
        loginB.layer.borderColor = UIColor.clear.cgColor
        
        toMainB.tintColor = .white
        signupB.tintColor = .white
        
        
    }
    
    
    
}

