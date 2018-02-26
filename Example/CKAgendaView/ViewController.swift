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
    @IBOutlet weak var agendaView: CKAgendaView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        agendaView.delegate = self
        
        CKAgendaManager.shared.addAgenda(title: "test", message: "this is a simple test!", type: "test", imageName: "icon_cards", identifier: "123", for: Date())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
}


extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("click event: " +  CKAgendaManager.shared.entities[indexPath.row].title!)
    }
    
}


