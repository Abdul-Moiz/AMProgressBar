//
//  ViewController.swift
//  AMProgressBar
//
//  Created by acct<blob>=<NULL> on 04/21/2017.
//  Copyright (c) 2017 acct<blob>=<NULL>. All rights reserved.
//

import UIKit
import AMProgressBar

class ViewController: UIViewController {
    
    @IBOutlet weak var progressBar1: AMProgressBar!
    @IBOutlet weak var progressBar2: AMProgressBar!
    @IBOutlet weak var progressBar3: AMProgressBar!
    @IBOutlet weak var progressBar4: AMProgressBar!
    @IBOutlet weak var progressBar5: AMProgressBar!
    @IBOutlet weak var progressBar6: AMProgressBar!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        testAnimation()
        
        // Global Config
        AMProgressBar.config.barColor = .blue
        AMProgressBar.config.barCornerRadius = 10
        AMProgressBar.config.barMode = .determined // .undetermined
        
        AMProgressBar.config.borderColor = .white
        AMProgressBar.config.borderWidth = 2
        
        AMProgressBar.config.cornerRadius = 10
        
        AMProgressBar.config.hideStripes = false
        
        AMProgressBar.config.stripesColor = .red
        AMProgressBar.config.stripesDelta = 80
        AMProgressBar.config.stripesMotion = .right // .none or .left
        AMProgressBar.config.stripesOrientation = .diagonalRight // .diagonalLeft or .vertical
        AMProgressBar.config.stripesWidth = 30
        
        AMProgressBar.config.textColor = .black
        AMProgressBar.config.textFont = UIFont.systemFont(ofSize: 12)
        AMProgressBar.config.textPosition = .onBar // AMProgressBarTextPosition
        
        let progressBar = AMProgressBar(frame: CGRect(x: 0, y: 0, width: 300, height: 40))
        progressBar.center = view.center
        
        progressBar.cornerRadius = 10
        progressBar.borderColor = UIColor.gray
        progressBar.borderWidth = 4
        
        progressBar.barCornerRadius = 10
        progressBar.barColor = UIColor.blue
        progressBar.barMode = AMProgressBarMode.determined.rawValue
        
        progressBar.hideStripes = false
        progressBar.stripesColor = UIColor.white
        progressBar.stripesWidth = 10
        progressBar.stripesDelta = 10
        progressBar.stripesMotion = AMProgressBarStripesMotion.right.rawValue
        progressBar.stripesOrientation = AMProgressBarStripesOrientation.diagonalRight.rawValue
        
        progressBar.textColor = UIColor.black
        progressBar.textFont = UIFont.systemFont(ofSize: 12)
        progressBar.textPosition = AMProgressBarTextPosition.middle.rawValue
        
        progressBar.progressValue = 1
        
//        progressBar.customize { (bar: AMProgressBar) in
//            bar.cornerRadius = 10
//        }
        
        progressBar.setProgress(progress: 1, animated: true)
        
        
        self.view.addSubview(progressBar)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func testAnimation() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.progressBar1.setProgress(progress: 0, animated: true)
            self.progressBar2.setProgress(progress: 0, animated: true)
            self.progressBar3.setProgress(progress: 0, animated: true)
            self.progressBar4.setProgress(progress: 0, animated: true)
            self.progressBar5.setProgress(progress: 0, animated: true)
            self.progressBar6.setProgress(progress: 0, animated: true)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            self.progressBar1.setProgress(progress: 0.2, animated: true)
            self.progressBar2.setProgress(progress: 0.2, animated: true)
            self.progressBar3.setProgress(progress: 0.2, animated: true)
            self.progressBar4.setProgress(progress: 0.2, animated: true)
            self.progressBar5.setProgress(progress: 0.2, animated: true)
            self.progressBar6.setProgress(progress: 0.2, animated: true)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
            self.progressBar1.setProgress(progress: 0.5, animated: true)
            self.progressBar2.setProgress(progress: 0.5, animated: true)
            self.progressBar3.setProgress(progress: 0.5, animated: true)
            self.progressBar4.setProgress(progress: 0.5, animated: true)
            self.progressBar5.setProgress(progress: 0.5, animated: true)
            self.progressBar6.setProgress(progress: 0.5, animated: true)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 8) {
            self.progressBar1.setProgress(progress: 0.8, animated: true)
            self.progressBar2.setProgress(progress: 0.8, animated: true)
            self.progressBar3.setProgress(progress: 0.8, animated: true)
            self.progressBar4.setProgress(progress: 0.8, animated: true)
            self.progressBar5.setProgress(progress: 0.8, animated: true)
            self.progressBar6.setProgress(progress: 0.8, animated: true)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            self.progressBar1.setProgress(progress: 1, animated: true)
            self.progressBar2.setProgress(progress: 1, animated: true)
            self.progressBar3.setProgress(progress: 1, animated: true)
            self.progressBar4.setProgress(progress: 1, animated: true)
            self.progressBar5.setProgress(progress: 1, animated: true)
            self.progressBar6.setProgress(progress: 1, animated: true)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 12) {
            self.testAnimation()
        }
    }

}

