//
//  CKAgenda+CoreDataProperties.swift
//  
//
//  Created by mk on 2018/2/23.
//
//

import Foundation
import CoreData


extension CKAgenda {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CKAgenda> {
        return NSFetchRequest<CKAgenda>(entityName: "CKAgenda")
    }

    @NSManaged public var title: String?
    @NSManaged public var date: Date?
    @NSManaged public var dateString: String?
    @NSManaged public var message: String?
    @NSManaged public var type: String?
    @NSManaged public var imageName: String?
    @NSManaged public var identifier: String?

}
