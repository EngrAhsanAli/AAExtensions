//
//  ViewController.swift
//  AAExtensions
//
//  Created by EngrAhsanAli on 03/14/2019.
//  Copyright (c) 2019 EngrAhsanAli. All rights reserved.
//

import UIKit
import AAExtensions

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        self.view.aa_addTapGesture {
            self.aa_callBack?("Some Value")
        }
        
        self.aa_callBack = {
            print($0)
        }
        

        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(_ animated: Bool) {
        
        let timeAgp = Date().aa_timeAgo(numericDates: true)
        print(timeAgp)
    }
    
    
    func aa_presentDocumentPicker() {
        let extensions = ".pdf,.jpeg,.png,.gif,.doc,.docx,.rtf,.txt,.odf,.xlsx,.ppt"

        aa.presentDocumentPicker(extensions) {
             print($0)
        }
    }
}
