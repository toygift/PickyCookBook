//
//  DetailPageImageSliderViewController.swift
//  PickyCookBook
//
//  Created by 유하늘 on 2017. 8. 21..
//  Copyright © 2017년 유하늘. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
//import LTMorphingLabel
//import AssetsLibrary

class DetailPage: UIViewController {
    
    // MARK: - Outlet Setting
    ////////////////////////////////////////////////////////////////
    //                        Outlet 셋팅                         //
    ////////////////////////////////////////////////////////////////
    
    @IBOutlet var imageView: UIImageView! // 레시피 이미지 뷰
    @IBOutlet var pageCountlabel: UILabel! // 현재 페이지 표시 라벨
    @IBOutlet weak var recipeDescriptionLabel: UILabel! // 레시피 간략 설명 라벨
    @IBOutlet weak var recipeTitleLabel: UILabel! // 레시피 타이틀 라벨
    @IBOutlet weak var recipeIngredientLabel: UILabel! // 레시피 재료 설명 라벨
    @IBOutlet weak var recipeTagLabel: UILabel! // 레시피 태그 라벨
    
    // 좋아요 평점
    @IBOutlet weak var star1: UIButton!
    @IBOutlet weak var star2: UIButton!
    @IBOutlet weak var star3: UIButton!
    @IBOutlet weak var star4: UIButton!
    @IBOutlet weak var star5: UIButton!

    // 이전 & 다음 단계 이동
    @IBOutlet var nextOutlet: UIButton! // 다음단계 레시피 버튼
    @IBOutlet var backOutlet: UIButton! // 한단계 전 레시피 버튼
    
    // MARK: - variable
    ////////////////////////////////////////////////////////////////
    //                         변수 셋팅                          //
    ////////////////////////////////////////////////////////////////
    
    // ************ 레시피 호출 값 ************
    var recivedPk = 0
    var showRecipePk = 1 // 불러올 데티일 페이지 Pk
    // ****************************************
    
    // Userdefault
    var userdefault: String?
    
    var stepIndex = 1 // 레이블 현재 페이지
    var recipeStepNumber = 0 // 레시피 스탭 구분
    var recipeStepCount = 0 // 레시피 스탭의 총 갯수
    
    
    // MARK: - Api data send to Array
    ////////////////////////////////////////////////////////////////
    //                         배열 셋팅                          //
    ////////////////////////////////////////////////////////////////
    
    // Api 데이터를 담는 배열 모음
    var imageGetArray:[Any] = []
    var titleGetArray:[String] = []
    var descriptionGetArray:[String] = []
    var tagGetArray:[String] = []
    var ingredientGetArray:[String] = []
    
    // 레시피 이미지가 없을 경우 사용
    let noImageGetArray:[String] = ["no_image.jpg"]
    
    let starFill : UIImage = UIImage(named: "star")!
    let starEmpty : UIImage = UIImage(named: "star_empty3")!
    
    var rate : Int = 0 {
        willSet {
            let stars = [star1, star2, star3, star4, star5]
            for (i, star) in stars.enumerated() {
                star?.isSelected = i < newValue
            }
//            rateLbl.text = "\(newValue)"
        }
    }
    
    @IBAction func starBtnDidTap(_ sender: UIButton) {
        switch rate {
        case 1:
            if sender.tag == 1 {
                rate = 0
            } else {
                rate = sender.tag
            }
        default:
            rate = sender.tag
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("전달 받은 피케이")
        print(recivedPk)
        print(showRecipePk)
        


        
        if recivedPk != 0 {
            showRecipePk = recivedPk
        } else {
            showRecipePk = 1
        }
        
        

        
        self.backOutlet.isEnabled = false
        apiGet()
        
        
    }
    
    // 로그인 되어있을경우 로그인 버튼 사라지게 함
    override func viewWillAppear(_ animated: Bool) {
        userdefault = UserDefaults.standard.object(forKey: "token") as? String
        if userdefault == nil {
            loginButtonOutlet.isHidden = false
        }else {
            loginButtonOutlet.isHidden = true
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Step Next Button
    ////////////////////////////////////////////////////////////////
    //                    앞 단계 레시피 로드                     //
    ////////////////////////////////////////////////////////////////
    
    @IBAction func nextButton(_ sender: AnyObject) {
        
        recipeStepNumber += 1
        stepIndex += 1
        
        // 버튼 enable , disable 체크
        if (stepIndex > 1) && (stepIndex - recipeStepNumber == 1) {
            backOutlet.isEnabled = true
            print(" &&&&&&&&&&&&&")
        } else if stepIndex < recipeStepNumber {
            backOutlet.isEnabled = true
            nextOutlet.isEnabled = true
        } else if stepIndex == recipeStepNumber {
            nextOutlet.isEnabled = false
        }
        
        // 스텝 데이터 갱신
        self.imageView.image = UIImage(data: imageGetArray[recipeStepNumber] as! Data)
        self.recipeTitleLabel.text = String(titleGetArray[recipeStepNumber])
        self.recipeDescriptionLabel.text = descriptionGetArray[recipeStepNumber]
        
        
        pageCountlabel.text = String("\(stepIndex)/\(recipeStepCount)")
        
        print("넥스트 버튼 클릭")
        print("레시피 스탭 : \(recipeStepNumber)")
        print("스탭 인덱스 : \(stepIndex)")
        print("레시피 스탭 카운트 : \(recipeStepCount)")
        print("이미지 어레이 : \(imageGetArray)")
        print("타이틀 어레이 : \(titleGetArray)")
        if stepIndex == recipeStepCount {
            nextOutlet.isEnabled = false
        }
    }
    
    // MARK: - Step Bsck Button
    ////////////////////////////////////////////////////////////////
    //                    전 단계 레시피 로드                     //
    ////////////////////////////////////////////////////////////////
    
    @IBAction func backButton(_ sender: AnyObject) {
        
        recipeStepNumber -= 1
        stepIndex -= 1
        
        // 버튼 enable , disable 체크
        if stepIndex == 1 {
            backOutlet.isEnabled = false
            nextOutlet.isEnabled = true
        } else if stepIndex > 1 {
            backOutlet.isEnabled = true
            nextOutlet.isEnabled = true
        }
        
        // 스텝 데이터 갱신
        self.imageView.image = UIImage(data: imageGetArray[recipeStepNumber] as! Data)
        self.recipeTitleLabel.text = titleGetArray[recipeStepNumber]
        self.recipeDescriptionLabel.text = descriptionGetArray[recipeStepNumber]
        
        
        pageCountlabel.text = String("\(stepIndex)/\(recipeStepCount)")
        
        print("백 버튼 클릭")
        print("레시피 스탭 : \(recipeStepNumber)")
        print("스탭 인덱스 : \(stepIndex)")
        print("레시피 스탭 카운트 : \(recipeStepCount)")
        print("이미지 어레이 : \(imageGetArray)")
        print("타이틀 어레이 : \(titleGetArray)")
    }
    @IBOutlet weak var loginButtonOutlet: UIButton!
    @IBAction func loginButtonAction(_ sender: UIButton) {
        let nextview = storyboard?.instantiateViewController(withIdentifier: "LoginPageStoryBoard") as! LoginPage
        self.present(nextview, animated: true, completion: nil  )
    }
  
    @IBAction func backToMain(_ sender: UIButton) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func gradeBtnDidTap(_ sender: UIButton) {
        switch rate {
        case 1:
            if sender.tag == 1 {
                rate = 0
            } else {
                rate = sender.tag
            }
        default:
            rate = sender.tag
        }
    }
    
    // MARK: - Like Grade
    ////////////////////////////////////////////////////////////////
    //                      좋아요 평점 로드                      //
    ////////////////////////////////////////////////////////////////
    
    
    // MARK: - API Load
    ////////////////////////////////////////////////////////////////
    //                      레시피 API 로드                       //
    ////////////////////////////////////////////////////////////////
    
    func apiGet(){
        print("api 시작 \(showRecipePk)")
        let url = "http://pickycookbook.co.kr/api/recipe/detail/\(showRecipePk)"
        let call = Alamofire.request(url, method: .get, encoding: JSONEncoding.default)
        call.responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let step = JSON(value)
                
                // 스텝 불러오기
                let callStep = step["recipes"].arrayValue
                
                // MARK: - API StepCount
                ////////////////////////////////////////////////////////////////
                //                   레시피 스탭 카운트 로드                  //
                ////////////////////////////////////////////////////////////////
                
                print("레시피 스탭 카운트 \(self.recipeStepCount = step["recipes"].arrayValue.count)")
                self.recipeStepCount = step["recipes"].arrayValue.count + 1
                
                print("레시피 카운트 : \(self.recipeStepCount)")
                
                
                
                // MARK: - API Title
                ////////////////////////////////////////////////////////////////
                //                      레시피 Title 로드                     //
                ////////////////////////////////////////////////////////////////
                
                var titleLoofCount = 0
                for _ in titleLoofCount...self.recipeStepCount  {
                    
                    if step["title"].string != nil {
                        if let recipeTitle = step["title"].string {
                            if titleLoofCount == 0 {
                                self.titleGetArray.append(recipeTitle)
                            } else {
                                self.titleGetArray.append("\(recipeTitle) - 요리순서 \(titleLoofCount)")
                            }
                        }
                        
                    }
                    titleLoofCount += 1
                    
                }
                
                
                // MARK: - API Title
                ////////////////////////////////////////////////////////////////
                //                       레시피 Tag 로드                      //
                ////////////////////////////////////////////////////////////////
                
                if step["tag"].string != "" {
                    if let recipeTag = step["tag"].string {
                        self.tagGetArray.append(recipeTag)
                        print("태그 성공")
                    }
                } else {
                    self.tagGetArray.append("태그 데이터가 없습니다.")
                }
                
                
                // 스탭 코멘트 불러오기
                //                 = step["recipes"].arrayValue[self.recipeStepNumber]["comments"].arrayValue
                
                // MARK: - API ingredient
                ////////////////////////////////////////////////////////////////
                //                     레시피 재료설명 로드                   //
                ////////////////////////////////////////////////////////////////
                
                
                if step["ingredient"].string != nil {
                    if let recipeTab = step["ingredient"].string {
                        self.ingredientGetArray.append(recipeTab)
                        print("재료 설명 성공")
                    }
                } else {
                    self.ingredientGetArray.append("재료설명 데이터가 없습니다.")
                }
                
                
                // MARK: - API Desciption
                ////////////////////////////////////////////////////////////////
                //                     레시피 간략설명 로드                   //
                ////////////////////////////////////////////////////////////////
                
                
                var descriptionLoofCount = 0
                
                if self.recipeStepCount > descriptionLoofCount  {
                    for _ in descriptionLoofCount...self.recipeStepCount { //반복시작
                        
                        if descriptionLoofCount != self.recipeStepCount { //루프카운트 와 스탭 카운트가 같지 않으면
                            
                            if descriptionLoofCount == 0 { // 메인 레시피의 description 추가 1 번만 실행
                                if let recipeDescription = step["description"].string{
                                    self.descriptionGetArray.append(recipeDescription)
                                    print("레시피 설명 성공")
                                }
                            } // 메인 레시피의 description 추가 끝
                            
                            if (self.recipeStepCount - descriptionLoofCount) > 1 { // 래시피 스탭 카운트 만큼 배열에 찼으면 종료
                                if callStep[descriptionLoofCount]["description"].string != nil {
                                    if let stepDescription = callStep[descriptionLoofCount]["description"].string  {
                                        self.descriptionGetArray.append(stepDescription)
                                        print("스탭 설명 성공")
                                    }
                                } else {
                                    self.descriptionGetArray.append("입력된 데이터가 없습니다.") // 입력된 데이터가 없을 경우 표시
                                }
                            }
                        } //루프카운트 와 스탭 카운트 끝
                        descriptionLoofCount += 1
                        print("*********************")
                        print(descriptionLoofCount)
                        print(self.recipeStepCount)
                        print(self.descriptionGetArray)
                    } //반복 끝
                    print("재료 설명 끝")
                }
                
                
                // MARK: - API Image
                ////////////////////////////////////////////////////////////////
                //                     레시피 이미지 로드                     //
                ////////////////////////////////////////////////////////////////
                
                
                // 레시피 메인 이미지 불러오기
                var imageLoofCount = 0
                //                                print("$$$$$$$$$$$$$$$$$$$$$$")
                //                                print(step[imageLoofCount]["img_recipe"].count)
                //                                print(step[imageLoofCount]["img_recipe"].string)
                //                                print(step[imageLoofCount]["img_recipe"].stringValue)
                //                                print(step[imageLoofCount]["img_recipe"].boolValue)
                //                                print("$$$$$$$$$$$$$$$$$$$$$$")
                
                if step[imageLoofCount]["img_recipe"].string == nil {
                    
                    if let mainImagePath = step["img_recipe"].string {
                        if let mainImageData = try? Data(contentsOf: URL(string: mainImagePath)!) {
                            
                            self.imageGetArray.append(mainImageData)
                            print("메인 이미지 추가 완료")
                        }
                    }
                    
                    // 레시피 메인 이미지 nil 값 일때 배열에 noimage 추가
                } else if step[imageLoofCount]["img_recipe"].string == nil {
                    let noImageData: Data = UIImagePNGRepresentation(#imageLiteral(resourceName: "no_image.jpg"))! // 이미지를 데이터 형식으로 변환
                    self.imageGetArray.append(noImageData)
                    print(step[imageLoofCount]["img_recipe"].boolValue)
                    print("노 레시피 이미지 추가 완료")
                }
                
                // 스탭 이미지 불러오기
                
                
                
                if step["recipes"].count == 0 {
                    self.viewDidShowData()
                    print("레시피의 스탭이 없음")
                    return
                }
                
                for _ in imageLoofCount...self.recipeStepCount {
                    
                    // 스탭의 배열 카운트가 찼으면 리턴
                    if self.recipeStepCount - imageLoofCount == 1 {
                        print("레시피 루프 카운트 \(imageLoofCount)")
                        self.viewDidShowData()
                        
                        return
                    }
                    
                    // 스탭의 이미지가 nil 일때 배열에 noimage 추가
                    
                    if callStep[imageLoofCount]["img_step"].string == nil {
                        
                        let noImageData: Data = UIImagePNGRepresentation(#imageLiteral(resourceName: "no_image.jpg"))! // 이미지를 데이터 형식으로 변환
                        self.imageGetArray.append(noImageData)
                        print("노 스탭 이미지 추가 완료")
                    }
                    print("*******************")
                    
                    // 스탭의 이미지가 있을때 배열에 스탭 이미지 추가
                    if callStep[imageLoofCount]["img_step"].string !=  nil {
                        if let stepImagePath = callStep[imageLoofCount]["img_step"].string  {
                            if let stepImageData = try? Data(contentsOf: URL(string: stepImagePath)!) {
                                self.imageGetArray.append(stepImageData)
                                print("스탭\(imageLoofCount) 이미지 추가 완료")
                            }
                        }
                    }
                    if (self.recipeStepCount - imageLoofCount) == 1 {
                        print(self.recipeStepNumber)
                        return
                    }
                    
                    imageLoofCount += 1
                    
                    print("루프카운트 \(imageLoofCount)")
                    print("레시피 스탭 카운트 \(self.recipeStepCount)")
                    print(self.imageGetArray)
                    
                    //                    print("@@@@@@@@@@@@@@@@@@@@@")
                    //                    print(callStep[imageLoofCount]["img_step"].count)
                    //                    print("@@@@@@@@@@@@@@@@@@@@@")
                    //                    print(callStep[imageLoofCount]["img_step"].string)
                    //                    print("@@@@@@@@@@@@@@@@@@@@@")
                    //                    print(callStep[imageLoofCount]["img_step"].stringValue)
                    //                    print("@@@@@@@@@@@@@@@@@@@@@")
                    //                    print(callStep[imageLoofCount]["img_step"].boolValue)
                    //                    print("@@@@@@@@@@@@@@@@@@@@@")
                }
                
            case .failure(let error):
                print(JSON(error))
            }
        }
        
    }
    
    
    // MARK: - Option Setting
    ////////////////////////////////////////////////////////////////
    //                         옵션 세팅                          //
    ////////////////////////////////////////////////////////////////
    
    // 쉐도우 뷰 효과
    func viewShadeEffect() {
        let shade = UIView(frame: self.view.frame)
        shade.backgroundColor = .black
        shade.alpha = 0.6
        shade.tag = 0
        //        shade.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        view.addSubview(shade)
        view.sendSubview(toBack: shade)
        
    }
    
    
    // 처음 로드 할때 표시될 데이터 호출
    func viewDidShowData() {
        
        print("타이틀 어레이")
        print(titleGetArray)
        self.pageCountlabel.text = "\(stepIndex)/\(recipeStepCount)"
        
        if recipeStepCount == 1 {
            nextOutlet.isEnabled = false
            backOutlet.isEnabled = false
        }
        
        imageView.layer.cornerRadius = 20
        
        let stars = [star1, star2, star3, star4, star5]
        for star in stars {
            star?.setImage(starEmpty, for: .normal)
            star?.setImage(starFill, for: .selected)
        }
        
        self.imageView.image = UIImage(data: imageGetArray[recipeStepNumber] as! Data)
        self.recipeIngredientLabel.text = ingredientGetArray[recipeStepNumber]
        
        self.recipeTitleLabel.text = titleGetArray[recipeStepNumber]
        self.recipeDescriptionLabel.text = descriptionGetArray[recipeStepNumber]
        self.recipeTagLabel.text = tagGetArray[recipeStepNumber]
        print("viewDidShowData 가 실행 되었습니다.")
    }
    
    //        func uiLabelCustom() {
    //
    //                pageCountlabel.delegate = self
    //                recipeDescriptionLabel.delegate = self
    //                    recipeTitleLabel.delegate = self
    //                recipeIngredientLabel.delegate = self
    //                recipeTagLabel.delegate = self
    //            pageCountlabel.morphingEffect = .scale
    //        recipeDescriptionLabel.morphingEffect = .evaporate
    //            recipeTitleLabel.morphingEffect = .fall
    //        recipeIngredientLabel.morphingEffect = .pixelate
    //        recipeTagLabel.morphingEffect = .fall
    //        }
    
    
}
