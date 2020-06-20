//
//  CouponCell.swift
//  Coupons
//
//  Created by Antoine on 09/04/2020.
//  Copyright © 2020 BOUBERBOUCHE Antoine. All rights reserved.
//

import SwiftUI

struct CouponCell: View {
    
    @State var showImageSheet = false
    
    var coupon: Coupon

    let currency = Currency(rawValue: (UserDefaults.standard.string(forKey: UserDefaultsKeys.currencyPreferenceKey) ?? "eur")) ?? .eur
    
    var expirationDateLabel: String {
        guard let date = coupon.expirationDate else {
            return String.localize(forKey: "COUPON.NEVER_EXP")
        }
        return DateLabel().getLabel(date: date)
    }
    
    var conditionLabel : String {
        guard let minimalAmount = coupon.minimumAmount?.doubleValue else {
            return String.localize(forKey: "COUPON.NO_MIN")
        }
        
        if minimalAmount.remainder(dividingBy: 1.0) == 0 {
            let price = currency.formattedPriceFor(Int(minimalAmount))
            return String.localize(forKey: "COUPON.MIN_DESCRIPTION").replacingOccurrences(of: "%price%", with: price)
        }
        let price = currency.formattedPriceFor(minimalAmount)
        return String.localize(forKey: "COUPON.MIN_DESCRIPTION").replacingOccurrences(of: "%price%", with: price)
    }
    
    var offer: String {
        return coupon.offerDescription
    }
    
    var image: UIImage? {
        if let data = coupon.image as? Data, let uiImage = UIImage(data: data) {
            return uiImage
        }
        return nil
    }
    
    var body: some View {
        HStack(alignment: .center) {
            if image != nil {
                Image(uiImage: image!)
                .resizable()
                .foregroundColor(Color(UIColor.systemFill))
                .cornerRadius(8)
                .frame(minWidth: 50, maxWidth: 60, minHeight: 50, maxHeight: 60, alignment: .center)
                .aspectRatio(contentMode: .fit)
                .padding(8)
                .onTapGesture {
                    self.showImageSheet = true
                }
            } else {
                ImagePlaceholderView(cornerRadius: 8, imageFontSize: 20)
                .frame(minWidth: 50, maxWidth: 60, minHeight: 50, maxHeight: 60, alignment: .center)
                .padding(8)
            }


            VStack(alignment: .leading) {
                Text(coupon.brand)
                    .font(.system(.headline, design: .rounded))
                    .foregroundColor(Color(TintColor.userPreference))
                Text(expirationDateLabel)
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundColor(Color(UIColor.secondaryLabel))
                Text(conditionLabel)
                    .font(.system(.subheadline, design: .rounded))
                .foregroundColor(Color(UIColor.label))
            }
            .padding(.vertical, 8)
            
            Spacer()
            
            Text(offer)
                .font(.system(.headline, design: .rounded))
                .foregroundColor(Color(UIColor.label))
            Image(systemName: "chevron.right")
                .foregroundColor(Color(UIColor.systemFill))
                .padding(8)
        }
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(8)
        .padding(.vertical, 4)
    }
}
