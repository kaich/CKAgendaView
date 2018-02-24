//
//  ViewController.swift
//  CKAgendaView
//
//  Created by chengkai1853@163.com on 02/23/2018.
//  Copyright (c) 2018 chengkai1853@163.com. All rights reserved.
//

import UIKit
import CKAgendaView

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        CKAgendaManager.shared.addAgenda(title: "test", message: "this is a simple test!", type: "test", imageName: "icon_cards", identifier: "123", for: Date())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

