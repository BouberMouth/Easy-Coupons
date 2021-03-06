//
//  CouponsView.swift
//  Coupons
//
//  Created by Antoine on 09/04/2020.
//  Copyright © 2020 BOUBERBOUCHE Antoine. All rights reserved.
//

import SwiftUI

struct CouponsView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(fetchRequest: Coupon.fetchCoupons()) var coupons: FetchedResults<Coupon>
    
    @State var showCreator = false
    

    
    var body: some View {
        NavigationView {
            List {
                ForEach(coupons) {coupon in
                    ZStack {
                        NavigationLink(destination: CouponDetails(coupon: coupon).environment(\.managedObjectContext, self.moc)) {
                            EmptyView()
                        }.buttonStyle(PlainButtonStyle())
                        CouponCell(coupon: coupon)
                            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 0)
                    }
                }.onDelete { (indexSet) in
                    let itemToDelete = self.coupons[indexSet.first!]
                    UserNotificationsService.shared.removeNotificationsFor(coupon: itemToDelete)
                    self.moc.delete(itemToDelete)
                }
                
                
                
                Button(action: {
                    UserNotificationsService.shared.requestAuthorization()
                    self.showCreator = true
                }, label: {
                    Text(String.localize(forKey: "COUPON.CREATE_BUTTON_TITLE"))
                        .font(.system(.subheadline, design: .rounded))
                        .foregroundColor(Color(UIColor.white))
                })
                    .frame(maxWidth: .infinity)
                    .padding(15)
                    .background(Color(TintColor.userPreference))
                    .cornerRadius(10)
                    .sheet(isPresented: $showCreator) {
                        CouponCreatorView().environment(\.managedObjectContext, self.moc)
                }
            }
            .padding(.top, 1)
            .padding(.bottom)
            .background(Color(UIColor.systemBackground))
            .navigationBarTitle(String.localize(forKey: "TAB_BAR_TITLE.COUPONS"))
        }.onAppear {
            UITableViewCell.appearance().backgroundColor = .systemBackground
            UITableView.appearance().backgroundColor = .systemBackground
            UITableView.appearance().separatorColor = .clear
            UITableViewCell.appearance().selectionStyle = .none
            UITableViewCell.appearance().accessoryType = .none
            UITableView.appearance().showsVerticalScrollIndicator = false
        }
    }
}
