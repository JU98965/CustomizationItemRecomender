//
//  ViewControllerTopSelect.swift
//  FlaskPractice
//
//  Created by 신정욱 on 2022/08/28.
//

import UIKit

protocol SelectDelegate{
    func topSelectingIsDone(_ controller: ViewControllerTopSelect, topData: String)
    func bottomSelectingIsDone(_ controller: ViewControllerTopSelect, bottomData: String)
    func shoesSelectingIsDone(_ controller: ViewControllerTopSelect, shoesData: String)
    
}

class ViewControllerTopSelect: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    let imageNameArray = ["t1.png", "t2.png", "t3.png", "b1.png", "b2.png", "b3.png", "s1.png", "s2.png", "s3.png"]
    var imageArray: [UIImage?] = []
    let requestArray = ["AnemosSuspenders", "CasualJacket", "Raincoat", "SouthernSeasSkirt", "CalfskinRider\'sBottoms", "CasualHalfslops", "CollegiateShoes", "CalfskinRider\'sShoes", "CrescentMoonSlippers"]
    let productNameArray = ["아네모스 멜빵셔츠", "캐주얼 재킷", "비옷", "남해의 치마", "송아지 가죽 라이더 하의", "캐주얼 반바지", "에오르제아 교복 로퍼: 장목양말", "송아지 가죽 라이더 신발", "초승달 실내화"]
    var reqTop: String = "AnemosSuspenders"
    var reqBottom: String = "SouthernSeasSkirt"
    var reqShoes: String = "CollegiateShoes"
    var reqTopTemp: String = ""
    var reqBottomTemp: String = ""
    var reqShoesTemp: String = ""
    var identfierReceive: String = ""
    var delegate: SelectDelegate?

    @IBOutlet var pickerCombination: UIPickerView!
    @IBOutlet var imgRecommend1: UIImageView!
    @IBOutlet var imgRecommend2: UIImageView!
    @IBOutlet var imgRecommend3: UIImageView!
    @IBOutlet var lblHowAboutThis: UILabel!
    @IBOutlet var btnConfirm: UIButton!
    @IBOutlet var btnUseThisCombination: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //네비게이션 바 백버튼 색 변경
        self.navigationController?.navigationBar.tintColor = .white
        
        self.view.backgroundColor = UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 1.0)//백그라운드 색 변경
        btnConfirm.backgroundColor = UIColor(red: 34/255, green: 109/255, blue: 249/255, alpha: 1.0)
        btnUseThisCombination.backgroundColor = UIColor(red: 34/255, green: 109/255, blue: 249/255, alpha: 1.0)
        btnConfirm.setTitleColor(.white, for: .normal)
        btnUseThisCombination.setTitleColor(.white, for: .normal)
        btnConfirm.layer.cornerRadius = 10
        btnUseThisCombination.layer.cornerRadius = 10
        
        imgRecommend1.layer.cornerRadius = 10
        imgRecommend2.layer.cornerRadius = 10
        imgRecommend3.layer.cornerRadius = 10
        
        
        for i in 0 ..< imageNameArray.count{//이미지 뷰 배열 추가
            let image = UIImage(named: imageNameArray[i])
            imageArray.append(image)
        }
        //어떤게 선택됐는지 확인차 보려고 써둔 코드
//        lblHowAboutThis.text = identfierReceive
    }
    
    @IBAction func confirmButtom(_ sender: UIButton) {
        if delegate != nil{
            if identfierReceive == "top"{
                delegate?.topSelectingIsDone(self, topData: reqTop)
            }
            else if identfierReceive == "bottom"{
                delegate?.bottomSelectingIsDone(self, bottomData: reqBottom)
            }
            else if identfierReceive == "shoes"{
                delegate?.shoesSelectingIsDone(self, shoesData: reqShoes)
            }
        }
        _ = navigationController?.popViewController(animated: true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        //피커뷰 컴포넌트 갯수
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        //1개의 컴포넌트 안에 표시할 데이터 수
        return 3
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        //컴포넌트 안의 데이터에 이미지삽입
        var returnValue = UIImageView(image: imageArray[row])//이프문 안에서 리턴을 안받아줘서 만든 변수, 일단 아무 데이터로나 초기화시켜둠
        if identfierReceive == "top"{
            if (component == 0){
                let imageView = UIImageView(image: imageArray[row])
                imageView.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
                returnValue = imageView
            }
        }
        else if identfierReceive == "bottom"{
            if (component == 0){
                let imageView = UIImageView(image: imageArray[row + 3])
                imageView.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
                returnValue = imageView
            }
        }
        else if identfierReceive == "shoes"{
            if (component == 0){
                let imageView = UIImageView(image: imageArray[row + 6])
                imageView.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
                returnValue = imageView
            }
        }
        return returnValue
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        //컴포넌트 안의 데이터의 이미지 높이(간격)설정
        return 150
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if identfierReceive == "top"{
            if (component == 0){
                //컴포넌트 row값에 따라 요청하는 변수가 달라짐
                reqTop = requestArray[row]
                //1차 추천 로직
                switch reqTop{
                case requestArray[0]:
                    imgRecommend1.image = imageArray[0]
                    imgRecommend2.image = imageArray[3]
                    imgRecommend3.image = imageArray[6]
                    //피커뷰를 움직일때마다 '이 조합 사용하기'전용 변수의 값을 지정함
                    reqTopTemp = requestArray[0]
                    reqBottomTemp = requestArray[3]
                    reqShoesTemp = requestArray[6]
                    break//스위프트는 굳이 브레이크 명시할 필요는 없음 대신 fallthrough는 따로 명시해야함
                case requestArray[1]:
                    imgRecommend1.image = imageArray[1]
                    imgRecommend2.image = imageArray[5]
                    imgRecommend3.image = imageArray[7]
                    //피커뷰를 움직일때마다 '이 조합 사용하기'전용 변수의 값을 지정함
                    reqTopTemp = requestArray[1]
                    reqBottomTemp = requestArray[5]
                    reqShoesTemp = requestArray[7]
                    break
                case requestArray[2]:
                    imgRecommend1.image = imageArray[2]
                    imgRecommend2.image = imageArray[5]
                    imgRecommend3.image = imageArray[8]
                    //피커뷰를 움직일때마다 '이 조합 사용하기'전용 변수의 값을 지정함
                    reqTopTemp = requestArray[2]
                    reqBottomTemp = requestArray[5]
                    reqShoesTemp = requestArray[8]
                    break
                default:
                    break
                }
                lblHowAboutThis.text = "\(productNameArray[row])와(과) 자주 매칭하는 대표적 조합이에요!"
            }
        }
        else if identfierReceive == "bottom"{
            if (component == 0){
                reqBottom = requestArray[row+3]
                switch reqBottom{
                case requestArray[3]:
                    imgRecommend1.image = imageArray[0]
                    imgRecommend2.image = imageArray[3]
                    imgRecommend3.image = imageArray[6]
                    //피커뷰를 움직일때마다 '이 조합 사용하기'전용 변수의 값을 지정함
                    reqTopTemp = requestArray[0]
                    reqBottomTemp = requestArray[3]
                    reqShoesTemp = requestArray[6]
                    break
                case requestArray[4]:
                    imgRecommend1.image = imageArray[0]
                    imgRecommend2.image = imageArray[4]
                    imgRecommend3.image = imageArray[7]
                    //피커뷰를 움직일때마다 '이 조합 사용하기'전용 변수의 값을 지정함
                    reqTopTemp = requestArray[0]
                    reqBottomTemp = requestArray[4]
                    reqShoesTemp = requestArray[7]
                    break
                case requestArray[5]:
                    imgRecommend1.image = imageArray[1]
                    imgRecommend2.image = imageArray[5]
                    imgRecommend3.image = imageArray[7]
                    //피커뷰를 움직일때마다 '이 조합 사용하기'전용 변수의 값을 지정함
                    reqTopTemp = requestArray[1]
                    reqBottomTemp = requestArray[5]
                    reqShoesTemp = requestArray[7]
                    break
                default:
                    break
                }
                lblHowAboutThis.text = "\(productNameArray[row+3])와(과) 자주 매칭하는 대표적 조합이에요!"
            }
        }
        else if identfierReceive == "shoes"{
            if (component == 0){
                reqShoes = requestArray[row+6]
                switch reqShoes{
                case requestArray[6]:
                    imgRecommend1.image = imageArray[0]
                    imgRecommend2.image = imageArray[3]
                    imgRecommend3.image = imageArray[6]
                    //피커뷰를 움직일때마다 '이 조합 사용하기'전용 변수의 값을 지정함
                    reqTopTemp = requestArray[0]
                    reqBottomTemp = requestArray[3]
                    reqShoesTemp = requestArray[6]
                    break
                case requestArray[7]:
                    imgRecommend1.image = imageArray[0]
                    imgRecommend2.image = imageArray[4]
                    imgRecommend3.image = imageArray[7]
                    //피커뷰를 움직일때마다 '이 조합 사용하기'전용 변수의 값을 지정함
                    reqTopTemp = requestArray[0]
                    reqBottomTemp = requestArray[4]
                    reqShoesTemp = requestArray[7]
                    break
                case requestArray[8]:
                    imgRecommend1.image = imageArray[1]
                    imgRecommend2.image = imageArray[5]
                    imgRecommend3.image = imageArray[8]
                    //피커뷰를 움직일때마다 '이 조합 사용하기'전용 변수의 값을 지정함
                    reqTopTemp = requestArray[1]
                    reqBottomTemp = requestArray[5]
                    reqShoesTemp = requestArray[8]
                    break
                default:
                    break
                }
                lblHowAboutThis.text = "\(productNameArray[row+6])와(과) 자주 매칭하는 대표적 조합이에요!"
            }
        }
    }
    
    @IBAction func useThisCombination(_ sender: UIButton) {
        delegate?.topSelectingIsDone(self, topData: reqTopTemp)
        delegate?.bottomSelectingIsDone(self, bottomData: reqBottomTemp)
        delegate?.shoesSelectingIsDone(self, shoesData: reqShoesTemp)
        _ = navigationController?.popViewController(animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
