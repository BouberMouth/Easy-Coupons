//
//  CouponCreatorView.swift
//  Coupons
//
//  Created by Antoine on 09/04/2020.
//  Copyright © 2020 BOUBERBOUCHE Antoine. All rights reserved.
//

import SwiftUI
import CoreData


struct CouponCreatorView: View {
    
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentation
    @ObservedObject private var keyboard = KeyboardResponder()
    
    @State private var showSheet = false
    @State private var showImagePicker = false
    @State private var sourceType: UIImagePickerController.SourceType = .camera
    @State private var image: UIImage?
    
    @State var showNotificationAlert = false
    
    var canCreate: Bool {
        if let offerValue = offerDoubleValue {
            let brandCheck = brand.trimmingCharacters(in: [" "]) != ""
            let offerCheck = (OfferType(rawValue: offerType) == .value) || offerValue < 100.0
            let minAmountCheck = (minimumAmountDouble != nil) || !hasMinimumAmount
            return brandCheck && offerCheck && minAmountCheck
        }
       return false
    }
    
    var offerDoubleValue: Double? {
        return Double(offerStringValue)
    }
    
    var minimumAmountDouble: Double? {
        return Double(minimumAmount)
    }
    
    var dateClosedRange: ClosedRange<Date> {
        let min = Date()
        let max = Calendar.current.date(byAdding: .year, value: 5, to: Date())!
        return min...max
    }
    
    var offerPlaceholder: String {
        return  offerType == 1 ? "Value" : "Reduction"
    }
    
    @State var brand = ""
    @State var location = ""
    @State var offerType: Int = 0
    @State var offerStringValue: String = ""
    @State var hasExpirationDate = false
    @State var expirationDate: Date = Date()
    @State var hasMinimumAmount = false
    @State var minimumAmount: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                HStack {
                    VStack {
                        TextField("Brand", text: $brand)
                            .padding(15)
                            .background(Color(UIColor.secondarySystemBackground))
                            .cornerRadius(10)
                        
                        TextField("Location", text: $location)
                            .padding(15)
                            .background(Color(UIColor.secondarySystemBackground))
                            .cornerRadius(10)
                    }
                    
                    Image(uiImage: (image ?? UIImage(named: "Logo2")!)).resizable()
                        .frame(minWidth: 50, maxWidth: 120, minHeight: 50, maxHeight: 120)
                        //.aspectRatio(contentMode: .fill)
                        .cornerRadius(10)
                        .onTapGesture {
                            self.showSheet = true
                    }.actionSheet(isPresented: $showSheet) {
                        ActionSheet(title: Text("Select photo"), message: Text("Choose"), buttons: [
                            .default(Text("Camera"), action: {
                                self.showImagePicker = true
                                self.sourceType = .camera
                            }),
                            .default(Text("Photo library"), action: {
                                self.showImagePicker = true
                                self.sourceType = .photoLibrary
                            }),
                            .cancel()
                        ])
                    }.sheet(isPresented: $showImagePicker) {
                    ImagePicker(image: self.$image, isShown: self.$showImagePicker, sourceType: self.sourceType)
                    }
                }
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("Offer")
                            .font(.system(.headline, design: .rounded))
                            .foregroundColor(Color(UIColor.label))
                        Text("Enter the type of offer and the amount")
                            .font(.system(.subheadline, design: .rounded))
                            .foregroundColor(Color(UIColor.secondaryLabel))
                    }
                    Spacer()
                }
                
                HStack {
                    TextField(offerPlaceholder, text: $offerStringValue)
                        .padding(15)
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(10)
                        .keyboardType(.decimalPad)
                    Picker(selection: $offerType, label: Text("")) {
                        Text("%").tag(0)
                        Text("€").tag(1)
                    }
                    .padding(15)
                    .frame(width: 70)
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(10)
                }
                
                
                Toggle(isOn: $hasMinimumAmount) {
                    Text("Minimum amount")
                    .font(.system(.headline, design: .rounded))
                    .foregroundColor(Color(UIColor.label))
                }
                
                if hasMinimumAmount {
                    TextField("Minimum amount (€)", text: $minimumAmount)
                    .padding(15)
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(10)
                    .keyboardType(.decimalPad)
                }
                
                Toggle(isOn: $hasExpirationDate) {
                    Text("Expiration date")
                    .font(.system(.headline, design: .rounded))
                    .foregroundColor(Color(UIColor.label))
                }
                
                if hasExpirationDate {
                    DatePicker(selection: $expirationDate, in: dateClosedRange, displayedComponents: [.date]) {
                        Text("When does it expire ?")
                        .font(.system(.subheadline, design: .rounded))
                        .foregroundColor(Color(UIColor.secondaryLabel))
                    }.padding(15)
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(10)
                }
                
                Button(action: {
                    if self.canCreate {
                        self.add()
                    }
                }, label: {
                    Text("Create")
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundColor(Color(UIColor.white))
                })
                .frame(maxWidth: .infinity)
                .padding(15)
                .background(self.canCreate ? Color(UIColor.systemPink) : Color.gray)
                .cornerRadius(10)
                .padding(.top, 15)
                    .padding(.bottom, 0)
                
                
                
            }
            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            .padding(.bottom, keyboard.currentHeight)
                
            .actionSheet(isPresented: $showNotificationAlert, content: {
                ActionSheet(title: Text("Notifications disabled"), message: Text("You can enable notifications in Settings > Notifications > Coupons."), buttons: [.cancel(Text("OK"), action: {
                    print("‡‡‡ DISMISS ALERT ‡‡‡")
                })])
            })
                
            .navigationBarTitle("New Coupon")
            .navigationBarItems(leading: Button("Cancel") {
                self.presentation.wrappedValue.dismiss()
            })
        }
    }
    
    init() {
        UITableViewCell.appearance().backgroundColor = .systemBackground
        UITableView.appearance().separatorColor = .systemBackground
        UITableView.appearance().backgroundColor = .systemBackground
        UITableViewCell.appearance().selectionStyle = .none
        UITableView.appearance().showsVerticalScrollIndicator = false
    }
}


extension CouponCreatorView {
    
    func add() {
        let coupon = Coupon(context: moc)
        coupon.id = Coupon.getNewUniqueCouponID()
        coupon.brand = self.brand
        coupon.location = self.location.trimmingCharacters(in: [" "]) == "" ? nil : self.location
        coupon.expirationDate = self.hasExpirationDate ? self.expirationDate : nil
        coupon.minimumAmount = self.hasMinimumAmount ? NSNumber(value: Double(self.minimumAmount) ?? 0.0) : nil
        coupon.offerType = OfferType.init(rawValue: self.offerType)!
        coupon.offerValue = NSNumber(value: Double(self.offerStringValue) ?? 0.0)
        coupon.image = self.image?.pngData() as NSData?
        coupon.imageRotation = self.image != nil ? (self.sourceType == .camera ? 90 : 0) : 0
        
        do {
            try self.moc.save()
        } catch let err {
            print("UNABLE TO CREATE ! ERR: \(err.localizedDescription)")
            print(coupon)
        }
        
        UserNotificationsService.shared.setReminderFor(coupon: coupon) { (granted, err1, err2) in
            print(granted)
            if !granted {
                print("Notifications not authorized")
            }
            if let authorizationError = err1 {
                print(" AUTHORIZATION ERROR: \(authorizationError) ")
            }
            if let requestError = err2 {
                print(" REQUEST ERROR: \(requestError) ")
            }
        }
        
        self.presentation.wrappedValue.dismiss()
    }
}

