//
//  Car+CoreDataProperties.swift
//  MyCoreData
//
//  Created by mac10 on 2021/4/15.
//  Copyright © 2021 mac10. All rights reserved.
//
//

import Foundation
import CoreData


extension Car {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Car> {
        return NSFetchRequest<Car>(entityName: "Car")
    }

    @NSManaged public var plate: String?
    @NSManaged public var belongto: UserData?

}
