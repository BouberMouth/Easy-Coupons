//
//  Coupon.swift
//  Coupons
//
//  Created by Antoine on 08/04/2020.
//  Copyright © 2020 BOUBERBOUCHE Antoine. All rights reserved.
//

import Foundation
import CoreData

@objc(Coupon)
public class Coupon: NSManagedObject, Identifiable {
    @NSManaged public var id: NSNumber
    @NSManaged public var brand: String
    @NSManaged public var location: String?
    @NSManaged public var expirationDate: Date?
    @NSManaged public var minimumAmount: NSNumber?
    @NSManaged public var offerValue: NSNumber
    @NSManaged public var offerTypeRV: NSNumber
    @NSManaged public var image: NSData?
    @NSManaged public var imageRotation: NSNumber?
    
    var offerType: OfferType {
        get { return OfferType.init(rawValue: Int(offerTypeRV ?? 0)) ?? .value }
        set { offerTypeRV = NSNumber(value: Int16(newValue.rawValue)) }
    }
    
    var offerDescription: String {
        let value = offerValue.doubleValue
        switch offerType {
        case .percentage:
            return "\(Int(value))%"
            
        case .value:
            if value.remainder(dividingBy: 1.0) == 0 {
                return "\(Int(value))€"
            }
            let (leftPart, rightPart) = value.priceComponants()
            return "\(leftPart)€\(rightPart)"
        }
    }

    
    static func getNewUniqueCouponID() -> NSNumber {
        let uniqueID = UserDefaults.standard.integer(forKey: UserDefaultsKeys.uniqueCouponIdentifierKey)
        print(uniqueID)
        UserDefaults.standard.set(uniqueID + 1, forKey: UserDefaultsKeys.uniqueCouponIdentifierKey)
        return NSNumber(value: uniqueID)
    }
}

extension Coupon {
    static func fetchCoupons() -> NSFetchRequest<Coupon> {
        let request: NSFetchRequest<Coupon> = Coupon.fetchRequest() as! NSFetchRequest<Coupon>
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        return request
    }
}

enum OfferType: Int {
    case percentage, value
}

enum CouponOffer {
    case percentage(Int)
    case value(Double)
}


