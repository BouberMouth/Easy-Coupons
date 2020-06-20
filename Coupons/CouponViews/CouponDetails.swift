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
    
    let currency = Currency(rawValue: (UserDefaults.standard.string(forKey: UserDefaultsKeys.currencyPreferenceKey) ?? "eur")) ?? .eur
    
    var value: String {
        return coupon.offerDescription
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
        guard let minimalAmount = coupon.minimumAmount?.doubleValue else {
            return Text("-")
        }
        
        if minimalAmount.remainder(dividingBy: 1.0) == 0 {
            return Text("\(currency.formattedPriceFor(Int(minimalAmount)))")
        }
        return Text("\(currency.formattedPriceFor(minimalAmount))")
    }
    
    var dateText: Text? {
        if let date = coupon.expirationDate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = String.localize(forKey: "FORMAT.EXP_DATE")
            let formattedDate = dateFormatter.string(from: date)
            return Text(formattedDate)
        }
        return Text("-")
    }
    
    var image: UIImage? {
        if let data = coupon.image as? Data, let uiImage = UIImage(data: data) {
            return uiImage
        }
        return nil
    }
    
    var couponImage: UIImage? {
        if let data = coupon.image as? Data, let uiImage = UIImage(data: data) {
            return uiImage
        }
        return nil
    }
    
    var body: some View {
        ScrollView(.vertical) {
            if image != nil {
                Image(uiImage: image!)
                    .resizable()
                    .frame(width: UIWindow().frame.width * 0.9, height: UIWindow().frame.width * 0.9, alignment: .center)
                    .aspectRatio(contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.vertical, 20)
            } else {
                ImagePlaceholderView(cornerRadius: 10, imageFontSize: 100)
                    .frame(width: UIWindow().frame.width * 0.9, height: UIWindow().frame.width * 0.9, alignment: .center)
            }

                
            HStack {
                Text(String.localize(forKey: "COUPON.BRAND"))
                    .font(.system(.headline, design: .rounded))
                    .foregroundColor(Color(UIColor.label))
                Spacer()
                Text(coupon.brand)
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundColor(Color(UIColor.secondaryLabel))
            }
            
            HStack {
                Text(String.localize(forKey: "COUPON.LOCATION"))
                    .font(.system(.headline, design: .rounded))
                    .foregroundColor(Color(UIColor.label))
                Spacer()
                couponLocationText
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundColor(Color(UIColor.secondaryLabel))
            }
            
            HStack {
                Text(String.localize(forKey: "COUPON.VALUE"))
                    .font(.system(.headline, design: .rounded))
                    .foregroundColor(Color(UIColor.label))
                Spacer()
                Text(value)
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundColor(Color(UIColor.secondaryLabel))
            }
            
            HStack {
                Text(String.localize(forKey: "COUPON.MIN_AMOUNT"))
                    .font(.system(.headline, design: .rounded))
                    .foregroundColor(Color(UIColor.label))
                Spacer()
                minimumAmountText
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundColor(Color(UIColor.secondaryLabel))
            }
            
            HStack {
                Text(String.localize(forKey: "COUPON.EXPIRATION"))
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
        .navigationBarItems(trailing: Button(String.localize(forKey: "DEFAULT.EDIT")) {
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
        UIImageView.appearance()
        self.coupon = coupon
    }
}
