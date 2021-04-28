//
//  LeaderboardViewController.swift
//  CatchDogGame
//
//  Created by 粘辰晧 on 2021/4/17.
//

import UIKit

class LeaderboardViewController: UIViewController {

    let defaults = UserDefaults.standard
    
    @IBOutlet var lastResultLabel: [UILabel]!
    @IBOutlet var rankLabel: [UILabel]!
    @IBOutlet weak var backgroundView: UIImageView!
    
    func displayLastResult() {
        
        // Check if there are previous game results
        if defaults.array(forKey: "ResultArray") != nil {
            let latestResultArray = defaults.array(forKey: "ResultArray") as! [Int]
            lastResultLabel[0].text = "SHIBAINU: \(latestResultArray[0])"
            lastResultLabel[1].text = "CHIHUAHUA: \(latestResultArray[1])"
            lastResultLabel[2].text = "BORDERCOLLIE: \(latestResultArray[2])"
            lastResultLabel[3].text = "SCORE: \(latestResultArray[3])"
            
        }else{
            lastResultLabel[0].text = "SHIBAINU: 0"
            lastResultLabel[1].text = "CHIHUAHUA: 0"
            lastResultLabel[2].text = "BORDERCOLLIE: 0"
            lastResultLabel[3].text = "SCORE: 0"
        }
    }
    
    func displayRank() {
        if defaults.array(forKey: "ScoreArray") != nil{
            let scoreArray = defaults.array(forKey: "ScoreArray") as! [Int]
            rankLabel[0].text = "1st \(scoreArray[0])"
            rankLabel[1].text = "2nd \(scoreArray[1])"
            rankLabel[2].text = "3rd \(scoreArray[2])"
            rankLabel[3].text = "4th \(scoreArray[3])"
            rankLabel[4].text = "5th \(scoreArray[4])"
        }else{
            rankLabel[0].text = "1st 0"
            rankLabel[1].text = "2nd 0"
            rankLabel[2].text = "3rd 0"
            rankLabel[3].text = "4th 0"
            rankLabel[4].text = "5th 0"
  
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayLastResult()
        displayRank()
        fetchImage()
    }

    @IBAction func share(_ sender: Any) {
        let controller = UIActivityViewController(activityItems: ["我在打狗棒法裡得到了\(String(lastResultLabel[3].text!))分！"], applicationActivities: nil)
        present(controller, animated: true, completion: nil)
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
