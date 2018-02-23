//
//  CKAgendaManager.swift
//  CKAgendaView
//
//  Created by mk on 2018/2/23.
//

import UIKit
import SugarRecord

public class CKAgendaManager: NSObject {
    
    public static let shared = CKAgendaManager()
    
    public var selectedDate: Date? {
        didSet {
            self.updateData()
        }
    }
    var dataChangedHandler: (() -> ())?

    lazy var db: CoreDataDefaultStorage = {
        let store = CoreDataStore.named("agenda")
        let bundle = Bundle(for: CKAgenda.classForCoder())
        let model = CoreDataObjectModel.merged([bundle])
        let defaultStorage = try! CoreDataDefaultStorage(store: store, model: model)
        return defaultStorage
    }()
    
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
    
    var entities: [CKAgenda] = [] {
        didSet {
            if let dataChangedHandler = dataChangedHandler {
                dataChangedHandler()
            }
        }
    }
    

    public func addAgenda(title: String, message: String, type: String, imageName: String, identifier: String, for date: Date) {
        do {
            try db.operation { (context, save) throws -> Void in
                let agenda: CKAgenda = try! context.create()
                agenda.title = title
                agenda.message = message
                agenda.type = type
                agenda.imageName = imageName
                agenda.identifier = identifier
                agenda.date = Date()
                agenda.dateString = self.dateFormatter.string(from: agenda.date!)
                save()
            }
            updateData()
        }
        catch {
            // There was an error in the operation
            NSLog("add agenda error")
        }
    }
    
    public func removeAgendaWith(agendaId: String) {
        do {
            try db.operation { (context, save) throws in
                let agenda: CKAgenda? = try context.request(CKAgenda.self).filtered(with: "id", equalTo: agendaId).fetch().first
                if let agenda = agenda {
                    try context.remove([agenda])
                    save()
                }
            }
            updateData()
        } catch {
            // There was an error in the operation
            NSLog("remove agenda error")
        }
    }
    
    public func updateData() {
        if let date = selectedDate {
            self.entities = try! db.fetch(FetchRequest<CKAgenda>().filtered(with: "dateString", equalTo: dateFormatter.string(from: date)))
        }
        else {
            self.entities = try! db.fetch(FetchRequest<CKAgenda>())
        }
    }

}
