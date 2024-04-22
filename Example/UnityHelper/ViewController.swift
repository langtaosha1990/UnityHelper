//
//  ViewController.swift
//  UnityHelper
//
//  Created by langtaosha1990 on 04/20/2024.
//  Copyright (c) 2024 langtaosha1990. All rights reserved.
//

import UIKit
import UnityHelper


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let model = GTestModel(name: "gpf", age: 18)
        model.SayHai()
        
    }

}

