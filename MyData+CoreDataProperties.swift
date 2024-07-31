//
//  MyData+CoreDataProperties.swift
//  
//
//  Created by 김은상 on 7/31/24.
//
//

import Foundation
import CoreData


extension MyData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MyData> {
        return NSFetchRequest<MyData>(entityName: "MyData")
    }

    @NSManaged public var index: Int16
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var title: String?

}
