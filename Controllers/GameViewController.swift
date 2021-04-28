//
//  GameViewController.swift
//  CatchDogGame
//
//  Created by 粘辰晧 on 2021/4/17.
//

import UIKit
import AVFoundation

class GameViewController: UIViewController {

    @IBOutlet var dogButtonOutlet: [UIButton]!
    @IBOutlet weak var gameTimeLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    let shibainuArray = Array(repeating: Dog.shibainu, count: 6)
    let chihuahuaArray = Array(repeating: Dog.chihuahua, count: 3)
    let bordercollieArray = Array(repeating: Dog.bordercollie, count: 1)
    
    var gameTime = 35
    
    var shibainuNum = 0
    var chihuahuaNum = 0
    var bordercollieNum = 0
    
    var totalscore = 0
    
    let player = AVPlayer()
    
    let defaults = UserDefaults.standard
    
    @IBAction func startButtonPressed(_ sender: UIButton) {
        playMusic()
        gameStart()
        sender.isHidden = true
    }
    
    @IBAction func dogButtonPressed(_ sender: UIButton) {
        let dogHit = dogButtonOutlet[sender.tag - 1]
        
        if dogHit.currentImage != nil {
            
            // Set the score of each dog
            switch dogHit.titleLabel?.text {
            case Dog.chihuahua.name:
                totalscore += Dog.chihuahua.score
                chihuahuaNum += 1
            case Dog.bordercollie.name:
                totalscore += Dog.bordercollie.score
                bordercollieNum += 1
            default:
                totalscore += Dog.shibainu.score
                shibainuNum += 1
            }
            scoreLabel.text = "\(totalscore)"
            
            // Let the image and title disappear after hit
            dogHit.setImage(nil, for: .normal)
            dogHit.setTitle(nil, for: .normal)
        }
    }
    
    // MARK: - Function
    func playMusic() {
        let fileUrl = Bundle.main.url(forResource: "BackgroundMusic", withExtension: "mp3")!
        let playerItem = AVPlayerItem(url: fileUrl)
        player.replaceCurrentItem(with: playerItem)
        player.play()
    }
    
    // The actions when game starts
    func gameStart() {
        
        // Timer: game countdown
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
            self.gameTime -= 1
            self.gameTimeLabel.text = String(self.gameTime)
            if self.gameTime == 0 {
                timer.invalidate()
                self.showTimesUpAlert()
                self.player.pause()
            }
        }
        
        // Timer: showing dog until time's up
        Timer.scheduledTimer(withTimeInterval: Double.random(in: 0.5...1.5), repeats: true) { (timer) in
            self.showDog()
            if self.gameTime == 0 {
                timer.invalidate()
                
                // all dog disappear when time's up
                for i in 0..<self.dogButtonOutlet.count {
                    self.dogButtonOutlet[i].setImage(nil, for: .normal)
                    self.dogButtonOutlet[i].isEnabled = false
                }
            }
        }
    }
    
    // Show dog image
    @objc func showDog(){
        
        //button: find all the empty button
        var emptyButtonArray = [UIButton]()
        for i in 1...dogButtonOutlet.count {
            if dogButtonOutlet[i - 1].currentImage == nil {
                emptyButtonArray.append(dogButtonOutlet[i - 1])
            }
        }
        
        // Generate weighted random dog
        let dogArray = shibainuArray + chihuahuaArray + bordercollieArray
        
        // random number of dog to appear
        let numberToAdd = Int.random(in: 1...3)
        
        // button: random empty button to show dog
        if emptyButtonArray.count > 6 {
            emptyButtonArray.shuffle()
            
            for i in 0..<numberToAdd {
                
                // Generate random dog to show
                let randomDog = dogArray.randomElement()
                
                // Set the random dog image
                emptyButtonArray[i].setImage(UIImage(named: "\(randomDog?.name ?? "shibainu")"), for: .normal)
                
                // Set the random dog title
                emptyButtonArray[i].setTitle(randomDog?.name ?? "shibainu", for: .normal)
                
                // Appear time of each type of dog
                var dogAppearTime: Double = 3.0
                switch randomDog {
                case Dog.chihuahua:
                    dogAppearTime = Dog.chihuahua.appearTime
                case Dog.bordercollie:
                    dogAppearTime = Dog.bordercollie.appearTime
                default:
                    dogAppearTime = Dog.shibainu.appearTime
                }
                
                // Timer: count down each dog's appear time
                Timer.scheduledTimer(withTimeInterval: TimeInterval(dogAppearTime), repeats: false) { (timer) in
                    
                    // let the dog image disappear
                    emptyButtonArray[i].setImage(nil, for: .normal)
                    
                    // let the dog title disappear
                    emptyButtonArray[i].setTitle(nil, for: .normal)
                }
            }
        }
    }
    
    func showTimesUpAlert() {
        let alert = UIAlertController(title: "TIME'S UP!", message: "Your score is  \(totalscore)", preferredStyle: .alert)
        let seeResultAction = UIAlertAction(title: "See Result", style: .default) { (alertaction) in
            self.storeLatestResult()
            self.storeRank()
            self.performSegue(withIdentifier: "gameToLeaderboardSG", sender: self)
        }
        alert.addAction(seeResultAction)
        present(alert, animated: true, completion: nil)
    }
    
    func storeLatestResult() {
        let resultArray = [shibainuNum, chihuahuaNum, bordercollieNum, totalscore]
        defaults.set(resultArray, forKey: "ResultArray")
    }
    
    func storeRank() {
        var temp: Int!
        var comparedScore = totalscore
        
        // Check if the app is played for the first time on the device
        if defaults.array(forKey: "ScoreArray") != nil {
            
            var scoreArray = defaults.array(forKey: "ScoreArray") as! [Int]
            
            for i in 0 ..< 5 {
                if comparedScore >= scoreArray[i] {
                    temp = scoreArray[i]
                    scoreArray[i] = comparedScore
                    comparedScore = temp
                }
            }
            defaults.set(scoreArray,forKey: "ScoreArray")
        }else{
            
            // Build a UserDefault if user plays for the first time
            let scoreArray = [comparedScore, 0, 0, 0, 0]
            defaults.set(scoreArray,forKey: "ScoreArray")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        gameTimeLabel.text = String(gameTime)
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
