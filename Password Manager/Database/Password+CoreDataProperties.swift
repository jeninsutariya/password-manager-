//
//  Password+CoreDataProperties.swift
//  
//
//  Created by Apple on 29/07/24.
//
//

import Foundation
import CoreData


extension Password {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Password> {
        return NSFetchRequest<Password>(entityName: "Password")
    }

    @NSManaged public var id: String?
    @NSManaged public var password: String?
    @NSManaged public var accountname: String?
    @NSManaged public var username: String?

}
