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
    
    
//    static func newCoupon(context: NSManagedObjectContext,
//                          brand: String,
//                          location: String? = nil,
//                          expirationDate: Date? = nil,
//                          minimumAmount: String? = nil,
//                          offerValue: Double,
//                          offerType: OfferType) -> Bool {
//
//        print("""
//            CONTEXT: \(context)
//            BRAND: \(brand)
//            LOCATION: \(location)
//            EXPIRATION: \(expirationDate)
//            MIN: \(minimumAmount)
//            OFFER \(offerValue) \(offerType == .percentage ? "%" : "€")
//            """)
//
//        let newCoupon = Coupon(context: context)
//        newCoupon.id = Coupon.getNewUniqueCouponID()
//        newCoupon.brand = brand
//        newCoupon.location = location
//        newCoupon.expirationDate = expirationDate
//        if let minAmount = minimumAmount, let doubleMinimumAmount = Double(minAmount) {
//            newCoupon.minimumAmount = NSNumber(value: doubleMinimumAmount)
//        }
//        newCoupon.offerValue = NSNumber(value: offerValue)
//        newCoupon.offerType = offerType
//
//        do {
//            try context.save()
//        } catch {
//            print(error)
//            return false
//        }
//        return true
//    }
    
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

extension Double {
    func priceComponants() -> (String, String) {
        let wholeValue = Int(self)
        let decimalValue = Int(self * 100) - (wholeValue * 100)
        if decimalValue < 10 {
            return (String(wholeValue), "\(0)\(String(decimalValue))")
        }
        return (String(wholeValue), String(decimalValue))
    }
}
