//
//  ViewControllerResult.swift
//  FlaskPractice
//
//  Created by 신정욱 on 2022/08/28.
//

import UIKit

class ViewControllerResult: UIViewController {
    let imageNameArray = ["t1.png", "t2.png", "t3.png", "b1.png", "b2.png", "b3.png", "s1.png", "s2.png", "s3.png"]
    var imageArray: [UIImage?] = []
    let requestArray = ["jumper", "sweater", "dressShirt", "cargoPants", "wideJeans", "trousers", "slipper", "sneakers", "runningShoes"]
    let productNameArray = ["맨투맨", "스웨터", "와이셔츠", "카고팬츠", "와이드 팬츠", "슬랙스", "슬리퍼", "컨버스", "운동화"]
    var reqTop: String = "jumper"
    var reqBottom: String = "cargoPants"
    var reqShoes: String = "slipper"
    var recommendedArrayTop: [String] = []
    var recommendedArrayBottom: [String] = []
    var recommendedArrayShoes: [String] = []
    var recommendedArrayRating: [Float] = []
    var count: Int = 0

    @IBOutlet var imgResult1: UIImageView!
    @IBOutlet var imgResult2: UIImageView!
    @IBOutlet var imgResult3: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        for i in 0 ..< imageNameArray.count{//이미지 뷰 배열 추가
            let image = UIImage(named: imageNameArray[i])
            imageArray.append(image)
        }
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
