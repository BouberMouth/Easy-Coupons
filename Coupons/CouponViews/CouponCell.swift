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
    
    var expirationDateLabel: String {
        guard let date = coupon.expirationDate else {
            return "N'expire jamais"
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMMM yyyy"
        let formattedDate = dateFormatter.string(from: date)
        return "Expire le \(formattedDate)"
    }
    
    var conditionLabel : String {
        guard let minimalAmount = coupon.minimumAmount?.doubleValue else {
            return "Sans minimum d'achat"
        }
        if minimalAmount.remainder(dividingBy: 1.0) == 0 {
            return "À partir de \(Int(minimalAmount))€ d'achat"
        }
        let (leftPart, rightPart) = minimalAmount.priceComponants()
        return "À partir de \(leftPart)€\(rightPart) d'achat"
    }
    
    var offer: String {
        //let value = coupon.offerValue!.doubleValue
        let value = coupon.offerValue.doubleValue
        switch coupon.offerType {
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
    
    var image: Image {
        if let data = coupon.image as? Data, let uiImage = UIImage(data: data) {
            return Image(uiImage: uiImage)
        }
        return Image(systemName: "photo")
    }
    
    var body: some View {
        HStack(alignment: .center) {
            image
                .resizable()
                .foregroundColor(Color(UIColor.systemFill))
                .cornerRadius(4)
                .frame(minWidth: 50, maxWidth: 50, minHeight: 50, maxHeight: 50, alignment: .center)
                .aspectRatio(contentMode: .fit)
                .rotationEffect(.degrees(coupon.imageRotation?.doubleValue ?? 0))
                .padding(8)
                .onTapGesture {
                    self.showImageSheet = true
            }
            /*.sheet(isPresented: $showImageSheet) {
                Image(uiImage: UIImage(data: self.coupon.image as! Data)!)
                    .resizable()
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
                    .aspectRatio(nil, contentMode: .fit)
            }*/

            VStack(alignment: .leading) {
                Text(coupon.brand)
                    .font(.system(.headline, design: .rounded))
                    .foregroundColor(Color(UIColor.systemPink))
                Text(expirationDateLabel)
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundColor(Color(UIColor.secondaryLabel))
                Text(conditionLabel)
                    .font(.system(.subheadline, design: .rounded))
                .foregroundColor(Color(UIColor.label))
            }
            .padding(8)
            
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
