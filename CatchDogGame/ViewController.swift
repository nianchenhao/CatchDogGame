//
//  ViewController.swift
//  CatchDogGame
//
//  Created by 粘辰晧 on 2021/4/17.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var backgroundView: UIImageView!
    
    @IBAction func fbPressed(_ sender: UIButton) {
        openFacebook("100012853862111", "nianchenhao")
    }
    @IBAction func igPressed(_ sender: UIButton) {
        openInstagram("nianchenhao")
    }
    
    func openFacebook(_ pageId: String, _ pageName: String) {
        let schemeUrl = "fb://profile/\(pageId)"
        let url = "https://www.facebook.com/\(pageName)"
        
        if UIApplication.shared.canOpenURL(URL(string: schemeUrl)!) {
            UIApplication.shared.open(URL(string: schemeUrl)!, options: [:], completionHandler: nil)
        }else{
            UIApplication.shared.open(URL(string: url)!, options: [:], completionHandler: nil)
        }
    }
    
    func openInstagram(_ userName: String) {
        let schemeUrl = "instagram://user?username=\(userName)"
        let url = "https://instagram.com/\(userName)"
        if UIApplication.shared.canOpenURL(URL(string: schemeUrl)!) {
            UIApplication.shared.open(URL(string: schemeUrl)!, options: [:], completionHandler: nil)
        }else{
            UIApplication.shared.open(URL(string: url)!, options: [:], completionHandler: nil)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchImage()
        //doubleTapGesture()
        // Do any additional setup after loading the view.
    }

    @objc func fetchImage() {
        let urlStr = "https://picsum.photos/390/844"
        if let url = URL(string: urlStr) {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let data = data{
                    DispatchQueue.main.async {
                        self.backgroundView.image = UIImage(data: data)
                    }
                }
            }.resume()
        }
    }
    
//    func doubleTapGesture() {
//        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(fetchImage))
//        doubleTap.numberOfTapsRequired = 2
//        backgroundView.isUserInteractionEnabled = true
//        backgroundView.addGestureRecognizer(doubleTap)
//
//    }
    

}

