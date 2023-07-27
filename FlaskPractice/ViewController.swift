//
//  ViewController.swift
//  FlaskPractice
//
//  Created by 신정욱 on 2022/07/01.
//

import UIKit
import Alamofire
import SwiftyJSON

struct ReceiveData: Codable {
    let top: String?
    let bottom: String?
    let shoes: String?
    let rating: Float?
}

class ViewController: UIViewController, SelectDelegate {
    let imageNameArray = ["t1.png", "t2.png", "t3.png", "b1.png", "b2.png", "b3.png", "s1.png", "s2.png", "s3.png"]
    var imageArray: [UIImage?] = []
    let requestArray = ["AnemosSuspenders", "CasualJacket", "Raincoat", "SouthernSeasSkirt", "CalfskinRider\'sBottoms", "CasualHalfslops", "CollegiateShoes", "CalfskinRider\'sShoes", "CrescentMoonSlippers"]
    let productNameArray = ["아네모스 멜빵셔츠", "캐주얼 재킷", "비옷", "남해의 치마", "송아지 가죽 라이더 하의", "캐주얼 반바지", "에오르제아 교복 로퍼: 장목양말", "송아지 가죽 라이더 신발", "초승달 실내화"]
    var reqTop: String = "AnemosSuspenders"
    var reqBottom: String = "SouthernSeasSkirt"
    var reqShoes: String = "CollegiateShoes"
    var recommendedArrayTop: [String] = []
    var recommendedArrayBottom: [String] = []
    var recommendedArrayShoes: [String] = []
    var recommendedArrayRating: [Float] = []
    var count: Int = 0
    var identfierPush: String = ""
    var isTopSeleted: Bool = false
    var isBottomSeleted: Bool = false
    var isShoesSelected: Bool = false

    @IBOutlet var txfMain: UITextView!
    @IBOutlet var lblConnect: UILabel!
//    @IBOutlet var lblRecommend: UILabel!
    @IBOutlet var imgRecommend1: UIImageView!
    @IBOutlet var imgRecommend2: UIImageView!
    @IBOutlet var imgRecommend3: UIImageView!
    @IBOutlet var imgResult1: UIImageView!
    @IBOutlet var imgResult2: UIImageView!
    @IBOutlet var imgResult3: UIImageView!
    @IBOutlet var lblRsultTemp: UILabel!
    @IBOutlet var ijenTemp: UIButton!
    @IBOutlet var tsugiTemp: UIButton!
    @IBOutlet var btnItemSelect1: UIButton!
    @IBOutlet var btnItemSelect2: UIButton!
    @IBOutlet var btnItemSelect3: UIButton!
    @IBOutlet var btnRequest: UIButton!
    @IBOutlet var imgBackgroundDeco: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 1.0)//백그라운드 색 변경
        //스웨터 모양 데코레이션 이미지
        imgBackgroundDeco.image = UIImage(named: "backgroundDeco.png")
        
        btnItemSelect1.backgroundColor = UIColor(red: 34/255, green: 109/255, blue: 249/255, alpha: 1.0)
        btnItemSelect2.backgroundColor = UIColor(red: 34/255, green: 109/255, blue: 249/255, alpha: 1.0)
        btnItemSelect3.backgroundColor = UIColor(red: 34/255, green: 109/255, blue: 249/255, alpha: 1.0)
        btnRequest.backgroundColor = UIColor(red: 34/255, green: 109/255, blue: 249/255, alpha: 1.0)
        ijenTemp.backgroundColor = UIColor(red: 34/255, green: 109/255, blue: 249/255, alpha: 1.0)
        tsugiTemp.backgroundColor = UIColor(red: 34/255, green: 109/255, blue: 249/255, alpha: 1.0)
        btnItemSelect1.setTitleColor(.white, for: .normal)
        btnItemSelect2.setTitleColor(.white, for: .normal)
        btnItemSelect3.setTitleColor(.white, for: .normal)
        btnRequest.setTitleColor(.white, for: .normal)
//        ijenTemp.setTitleColor(.gray, for: UIControl.State.disabled)
        ijenTemp.setTitleColor(.white, for: UIControl.State.normal)
        tsugiTemp.setTitleColor(.white, for: .normal)
//        tsugiTemp.setTitleColor(.gray, for: .disabled)//disable되었다면 각 상태별로 컬러를 지정하여야 함
        
        btnItemSelect1.layer.cornerRadius = 10
        btnItemSelect2.layer.cornerRadius = 10
        btnItemSelect3.layer.cornerRadius = 10
        btnRequest.layer.cornerRadius = 10
        ijenTemp.layer.cornerRadius = 10
        tsugiTemp.layer.cornerRadius = 10
        
        imgRecommend1.layer.cornerRadius = 10
        imgRecommend2.layer.cornerRadius = 10
        imgRecommend3.layer.cornerRadius = 10
        imgResult1.layer.cornerRadius = 10
        imgResult2.layer.cornerRadius = 10
        imgResult3.layer.cornerRadius = 10
        
        for i in 0 ..< imageNameArray.count{//이미지 뷰 배열 추가
            let image = UIImage(named: imageNameArray[i])
            imageArray.append(image)
        }
        

        //서버 응답여부
        AF.request("https://flaskprc-ceegg.run.goorm.io/").responseString { response in
            if response.value == "Connected"{
                self.lblConnect.text = "서버 온라인"
            }
            else{
                self.lblConnect.text = "서버 오프라인"
            }
         }
        //이미지 터치 할 수 있게 해주는 무언가
        let setTap = UITapGestureRecognizer(target: self, action: #selector(imgTapped))
        imgRecommend1.isUserInteractionEnabled = true
        imgRecommend1.addGestureRecognizer(setTap)
    }
    
    //다른 VC로 데이터 전송 관련
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let ViewControllerTopSelect = segue.destination as! ViewControllerTopSelect
        if segue.identifier == "topSelectButton"{
            ViewControllerTopSelect.identfierReceive = "top"
        }
        else if segue.identifier == "bottomSelectButton"{
            ViewControllerTopSelect.identfierReceive = "bottom"
        }
        else if segue.identifier == "shoesSelectButton"{
            ViewControllerTopSelect.identfierReceive = "shoes"
        }
        ViewControllerTopSelect.delegate = self
    }
    //프로토콜에서 정의한 함수
    func topSelectingIsDone(_ controller: ViewControllerTopSelect, topData: String) {
        reqTop = topData
        switch reqTop{
        case requestArray[0]:
            imgRecommend1.image = imageArray[0]
            break//스위프트는 굳이 브레이크 명시할 필요는 없음 대신 fallthrough는 따로 명시해야함
        case requestArray[1]:
            imgRecommend1.image = imageArray[1]
            break
        case requestArray[2]:
            imgRecommend1.image = imageArray[2]
            break
        default:
            break
        }
        isTopSeleted = true
        txfMain.text = reqTop
    }
    //프로토콜에서 정의한 함수
    func bottomSelectingIsDone(_ controller: ViewControllerTopSelect, bottomData: String) {
        reqBottom = bottomData
        switch reqBottom{
        case requestArray[3]:
            imgRecommend2.image = imageArray[3]
            break
        case requestArray[4]:
            imgRecommend2.image = imageArray[4]
            break
        case requestArray[5]:
            imgRecommend2.image = imageArray[5]
            break
        default:
            break
        }
        isBottomSeleted = true
        txfMain.text = reqBottom
    }
    //프로토콜에서 정의한 함수
    func shoesSelectingIsDone(_ controller: ViewControllerTopSelect, shoesData: String) {
        reqShoes = shoesData
        switch reqShoes{
        case requestArray[6]:
            imgRecommend3.image = imageArray[6]
            break
        case requestArray[7]:
            imgRecommend3.image = imageArray[7]
            break
        case requestArray[8]:
            imgRecommend3.image = imageArray[8]
            break
        default:
            break
        }
        isShoesSelected = true
        txfMain.text = reqShoes
    }
    
    // 이미지 터치하면 호출되는 함수
    @objc func imgTapped(){
        print("터치됨!")
    }
    
    @IBAction func btnRequest(_ sender: UIButton) {
        if (isTopSeleted && isBottomSeleted) && isShoesSelected{
            //웹 통신
            AF.request("https://flaskprc-ceegg.run.goorm.io/top/\(reqTop)/bottom/\(reqBottom)/shoes/\(reqShoes)").responseDecodable(of: [ReceiveData].self) { response in
                debugPrint(response)
                switch response.result {
                case .success:
                    self.ijenTemp.isHidden = false
                    self.tsugiTemp.isHidden = false
                    self.recommendedArrayTop = []
                    self.recommendedArrayBottom = []
                    self.recommendedArrayShoes = []
                    self.recommendedArrayRating = []
                    
                    for i in 1..<response.value!.count{
                        self.recommendedArrayTop.append(response.value![i].top!)
                        self.recommendedArrayBottom.append(response.value![i].bottom!)
                        self.recommendedArrayShoes.append(response.value![i].shoes!)
                        self.recommendedArrayRating.append(response.value![i].rating!)
                    }
                    print("============================================================")
                    print(self.recommendedArrayTop)
                    print("============================================================")
                    print(self.recommendedArrayBottom)
                    print("============================================================")
                    print(self.recommendedArrayShoes)
                    print("============================================================")
                    print(self.recommendedArrayRating)
                    print("============================================================")
                    print(self.recommendedArrayRating.count)
                    
                    self.count = 0
                    self.lblRsultTemp.text = "선택한 조합을 고른 사람들이 \(self.count+1)번 째로 높게 평가한 조합이에요"
                    self.parseTemp(self.count)
                    
                case .failure(let err):
                    print(err)
                    
                    let connectFailAlert = UIAlertController(title: "오류", message: "서버로부터 정보를 받아오지 못했어요! 무슨 문제가 있는 걸까요?", preferredStyle: UIAlertController.Style.alert)
                    let confirmAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil)
                    connectFailAlert.addAction(confirmAction)
                    self.present(connectFailAlert, animated: true, completion: nil)
                }
            }
        }
        else{
            let notMakedTheCombinationAlert = UIAlertController(title: "안내", message: "세 가지 부위를 모두 골라주세요!", preferredStyle: UIAlertController.Style.alert)
            let confirmAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil)
            notMakedTheCombinationAlert.addAction(confirmAction)
            present(notMakedTheCombinationAlert, animated: true, completion: nil)
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        //피커뷰 컴포넌트 갯수
        return 3
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        //1개의 컴포넌트 안에 표시할 데이터 수
        return 3
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        //컴포넌트 안의 데이터에 이미지삽입
        var returnValue = UIImageView(image: imageArray[row])//이프문 안에서 리턴을 안받아줘서 만든 변수, 일단 아무 데이터로나 초기화시켜둠
        if (component == 0){
            let imageView = UIImageView(image: imageArray[row])
            imageView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
            returnValue = imageView
        }
        else if (component == 1){
            let imageView = UIImageView(image: imageArray[row + 3])
            imageView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
            returnValue = imageView
        }
        else if (component == 2){
            let imageView = UIImageView(image: imageArray[row + 6])
            imageView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
            returnValue = imageView
        }
        return returnValue
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        //컴포넌트 안의 데이터의 이미지 높이(간격)설정
        return 100
    }
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        if (component == 0){
//            //컴포넌트 row값에 따라 요청하는 변수가 달라짐
//            reqTop = requestArray[row]
//            //1차 추천 로직
//            switch reqTop{
//            case requestArray[0]:
//                imgRecommend1.image = imageArray[1-1]
//                imgRecommend2.image = imageArray[1-1+3]
//                imgRecommend3.image = imageArray[3-1+6]
//                break//스위프트는 굳이 브레이크 명시할 필요는 없음 대신 fallthrough는 따로 명시해야함
//            case requestArray[1]:
//                imgRecommend1.image = imageArray[2-1]
//                imgRecommend2.image = imageArray[3-1+3]
//                imgRecommend3.image = imageArray[2-1+6]
//                break
//            case requestArray[2]:
//                imgRecommend1.image = imageArray[3-1]
//                imgRecommend2.image = imageArray[3-1+3]
//                imgRecommend3.image = imageArray[2-1+6]
//                break
//            default:
//                break
//            }
////            lblRecommend.text = "\(productNameArray[row])와(과) 자주 매칭하는 대표적 조합이에요!"
//        }
//        else if (component == 1){
//            reqBottom = requestArray[row+3]
//            switch reqBottom{
//            case requestArray[3]:
//                imgRecommend1.image = imageArray[1-1]
//                imgRecommend2.image = imageArray[1-1+3]
//                imgRecommend3.image = imageArray[3-1+6]
//                break
//            case "wideJeans":
//                imgRecommend1.image = imageArray[3-1]
//                imgRecommend2.image = imageArray[2-1+3]
//                imgRecommend3.image = imageArray[2-1+6]
//                break
//            case "trousers":
//                imgRecommend1.image = imageArray[2-1]
//                imgRecommend2.image = imageArray[3-1+3]
//                imgRecommend3.image = imageArray[2-1+6]
//                break
//            default:
//                break
//            }
////            lblRecommend.text = "\(productNameArray[row+3])와(과) 자주 매칭하는 대표적 조합이에요!"
//        }
//        else if (component == 2){
//            reqShoes = requestArray[row+6]
//            switch reqShoes{
//            case "CollegiateShoes":
//                imgRecommend1.image = imageArray[1-1]
//                imgRecommend2.image = imageArray[1-1+3]
//                imgRecommend3.image = imageArray[1-1+6]
//                break
//            case "sneakers":
//                imgRecommend1.image = imageArray[2-1]
//                imgRecommend2.image = imageArray[3-1+3]
//                imgRecommend3.image = imageArray[2-1+6]
//                break
//            case "runningShoes":
//                imgRecommend1.image = imageArray[1-1]
//                imgRecommend2.image = imageArray[1-1+3]
//                imgRecommend3.image = imageArray[3-1+6]
//                break
//            default:
//                break
//            }
////            lblRecommend.text = "\(productNameArray[row+6])와(과) 자주 매칭하는 대표적 조합이에요!"
//        }
//    }
    
    //받아온 어레이에서 결과값을 뽑기 편하게 만들어주는 무언가
    func parseTemp(_ cnt: Int) -> Void{
        switch self.recommendedArrayTop[cnt]{
        case requestArray[0]:
            self.imgResult1.image = self.imageArray[0]
            break//스위프트는 굳이 브레이크 명시할 필요는 없음 대신 fallthrough는 따로 명시해야함22
        case requestArray[1]:
            self.imgResult1.image = self.imageArray[1]
            break
        case requestArray[2]:
            self.imgResult1.image = self.imageArray[2]
            break
        default:
            break
        }
        switch self.recommendedArrayBottom[cnt]{
        case requestArray[3]:
            self.imgResult2.image = self.imageArray[3]
            break
        case requestArray[4]:
            self.imgResult2.image = self.imageArray[4]
            break
        case requestArray[5]:
            self.imgResult2.image = self.imageArray[5]
            break
        default:
            break
        }
        switch self.recommendedArrayShoes[cnt]{
        case requestArray[6]:
            self.imgResult3.image = self.imageArray[6]
            break
        case requestArray[7]:
            self.imgResult3.image = self.imageArray[7]
            break
        case requestArray[8]:
            self.imgResult3.image = self.imageArray[8]
            break
        default:
            break
        }
    }
    
    @IBAction func ijen(_ sender: Any) {
        if count <= 0 {
            lblRsultTemp.text = "처음 항목이라 더 이상 이전으로 갈 수 없어요!"
        }
        else{
            count = count - 1
            parseTemp(count)
            lblRsultTemp.text = "선택한 조합을 고른 사람들이 \(count+1)번 째로 높게 평가한 조합이에요"
        }
    }
    
    @IBAction func tsugi(_ sender: Any) {
        if count >= recommendedArrayRating.count-1 {
            lblRsultTemp.text = "끝 항목이라 더 이상 다음으로 갈 수 없어요!"
        }
        else{
            count = count + 1
            parseTemp(count)
            lblRsultTemp.text = "선택한 조합을 고른 사람들이 \(count+1)번 째로 높게 평가한 조합이에요"
        }
    }
}

