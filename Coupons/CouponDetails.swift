//
//  CouponDetails.swift
//  Coupons
//
//  Created by Antoine on 12/04/2020.
//  Copyright © 2020 BOUBERBOUCHE Antoine. All rights reserved.
//

import SwiftUI

struct CouponDetails: View {
    
    @Environment(\.managedObjectContext) var moc
    
    var coupon: Coupon
    @State var showEditionView: Bool = false
    
//    var editor: CouponEditorView {
//        let cev = CouponEditorView(coupon: coupon)
//        cev.brand = coupon.brand
//        cev.location = coupon.location ?? ""
//        cev.offerStringValue = coupon.offerValue.stringValue
//        cev.offerType = coupon.offerTypeRV.intValue
//        cev.minimumAmount = coupon.minimumAmount?.stringValue ?? ""
//        cev.expirationDate = coupon.expirationDate ?? Date()
//        if let imageData = coupon.image {
//            cev.image = UIImage(data: imageData as Data)
//        }
//        cev.hasMinimumAmount = coupon.minimumAmount != nil
//        cev.hasExpirationDate = coupon.expirationDate != nil
//        return cev
//    }
    
    var value: String {
        switch coupon.offerType {
        case .percentage:
            return "\(Int(coupon.offerValue))%"
        case .value:
            let (eur, cents) = Double(coupon.offerValue).priceComponants()
            if cents == "00" {
                return "\(eur)€"
            }
            return "\(eur)€\(cents)"
        }
    }
    
    var navBarTitle: String {
        return "\(coupon.brand) - \(value)"
    }
    
    var couponLocationText: Text? {
        if let location = coupon.location {
            return Text(location)
        }
        return Text("-")
    }
    
    var minimumAmountText: Text? {
        if let (eur, cents) = coupon.minimumAmount?.doubleValue.priceComponants() {
            return Text(eur + "€" + cents)
        }
        return Text("-")
    }
    
    var dateText: Text? {
        if let date = coupon.expirationDate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "d MMMM yyyy"
            let formattedDate = dateFormatter.string(from: date)
            return Text(formattedDate)
        }
        return Text("-")
    }
    
    var image: Image {
        if let data = coupon.image as? Data, let uiImage = UIImage(data: data) {
            return Image(uiImage: uiImage)
        }
        return Image("Logo2")
    }
    
    var couponImage: UIImage? {
        if let data = coupon.image as? Data, let uiImage = UIImage(data: data) {
            return uiImage
        }
        return nil
    }
    
    var body: some View {
        ScrollView(.vertical) {
            image
                .resizable()
                .cornerRadius(10)
                .aspectRatio(contentMode: .fit)
                .padding(.bottom, 20)
                
            HStack {
                Text("Brand")
                    .font(.system(.headline, design: .rounded))
                    .foregroundColor(Color(UIColor.label))
                Spacer()
                Text(coupon.brand)
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundColor(Color(UIColor.secondaryLabel))
            }
            
            HStack {
                Text("Location")
                    .font(.system(.headline, design: .rounded))
                    .foregroundColor(Color(UIColor.label))
                Spacer()
                couponLocationText
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundColor(Color(UIColor.secondaryLabel))
            }
            
            HStack {
                Text("Value")
                    .font(.system(.headline, design: .rounded))
                    .foregroundColor(Color(UIColor.label))
                Spacer()
                Text(value)
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundColor(Color(UIColor.secondaryLabel))
            }
            
            HStack {
                Text("Minimum amount")
                    .font(.system(.headline, design: .rounded))
                    .foregroundColor(Color(UIColor.label))
                Spacer()
                minimumAmountText
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundColor(Color(UIColor.secondaryLabel))
            }
            
            HStack {
                Text("Expiration")
                    .font(.system(.headline, design: .rounded))
                    .foregroundColor(Color(UIColor.label))
                Spacer()
                dateText
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundColor(Color(UIColor.secondaryLabel))
            }
        }
        .padding(.horizontal, 20)
        .navigationBarTitle(navBarTitle)
        .navigationBarItems(trailing: Button("Edit") {
            self.showEditionView = true
        }.sheet(isPresented: $showEditionView) {

            CouponEditorView(image: self.couponImage,
                             coupon: self.coupon,
                             brand: self.coupon.brand,
                             location: self.coupon.location ?? "",
                             offerType: self.coupon.offerTypeRV.intValue,
                             offerStringValue: self.coupon.offerValue.stringValue,
                             hasExpirationDate: self.coupon.expirationDate != nil,
                             expirationDate: self.coupon.expirationDate ?? Date(),
                             hasMinimumAmount: self.coupon.minimumAmount != nil,
                             minimumAmount: self.coupon.minimumAmount?.stringValue ?? "").environment(\.managedObjectContext, self.moc)
        })
        
    }
    
    init(coupon: Coupon) {
        UIScrollView.appearance().showsVerticalScrollIndicator = false
        self.coupon = coupon
    }
}
