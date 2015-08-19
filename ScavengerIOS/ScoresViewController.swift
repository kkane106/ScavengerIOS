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

    var completedHunt : PFObject?

    override func viewWillAppear(animated: Bool) {
        viewWillAppear(true)
        setupScoreBoard()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func setupScoreBoard() {
        if let completedHunt = completedHunt {
            didReceiveScores(completedHunt, completion: { (playerScores) -> () in
                println(playerScores)
            })

        } else {
            println("no scores returned")
        }
    }
    
    func didReceiveScores(passedScores : PFObject, completion : (playerScores : PFObject) -> ()) {
        let receivedScores = passedScores
        completion(playerScores: receivedScores)
        
    }
}
