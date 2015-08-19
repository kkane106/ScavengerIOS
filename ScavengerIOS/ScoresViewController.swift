//
//  ScoresViewController.swift
//  
//
//  Created by Kristopher Kane on 8/18/15.
//
//

import UIKit
import Parse

class ScoresViewController: UIViewController {
    @IBOutlet weak var timeLabel: UILabel!

    var completedHunt : PFObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScoreBoard()
    }
    
    func setupScoreBoard() {
        if let completedHunt = completedHunt {
            didReceiveScores(completedHunt, completion: { (playerScores) -> () in
                println(playerScores)
                if let totalTime : [Int] = playerScores["totalTime"] as? [Int] {
                    self.timeLabel.text = "\(totalTime[3]) Days, \(totalTime[2]) Hours, \(totalTime[1]) Minutes, \(totalTime[0]) Seconds"
                }
            })

        } else {
            println("no scores returned")
        }
    }
    
    func didReceiveScores(passedScores : PFObject, completion : (playerScores : PFObject) -> ()) {
        let receivedScores = passedScores
        completion(playerScores: receivedScores)
        
    }
    @IBAction func returnToProfile(sender: UIButton) {
        self.performSegueWithIdentifier("segueToList", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "showCurrentHunt") {
            let navVC = segue.destinationViewController as! UINavigationController
            let destinationVC = navVC.topViewController as! ListHuntsViewController
        }
    }
    
}
