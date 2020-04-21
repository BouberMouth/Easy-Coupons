//
//  CouponEditorView.swift
//  Coupons
//
//  Created by Antoine on 16/04/2020.
//  Copyright © 2020 BOUBERBOUCHE Antoine. All rights reserved.
//

import SwiftUI
import CoreData
import DispatchIntrospection

struct CouponEditorView: View {
    
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentation
    @ObservedObject private var keyboard = KeyboardResponder()
    
    @State private var showSheet = false
    @State private var showImagePicker = false
    @State private var sourceType: UIImagePickerController.SourceType = .camera
    @State var image: UIImage?
    
    var coupon: Coupon = Coupon()
    var couponImage: UIImage? {
        if let image = image {
            return image
        } else if let data = coupon.image as? Data, let img = UIImage(data: data) {
            return img
        }
        return nil
    }
    
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
    
    @State var brand: String = "a" {didSet {print(brand)}}
    @State var location: String = ""
    @State var offerType: Int = 0
    @State var offerStringValue: String = ""
    @State var hasExpirationDate: Bool = true
    @State var expirationDate: Date = Date()
    @State var hasMinimumAmount: Bool = true
    @State var minimumAmount: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                HStack {
                    VStack {
                        TextField("Name", text: $brand)
                            .padding(15)
                            .background(Color(UIColor.secondarySystemBackground))
                            .cornerRadius(10)
                        
                        TextField("Location", text: $location)
                            .padding(15)
                            .background(Color(UIColor.secondarySystemBackground))
                            .cornerRadius(10)
                    }
                    
                    Image(uiImage: (couponImage ?? UIImage(named: "Logo2")!)).resizable()
                        .frame(minWidth: 50, maxWidth: 120, minHeight: 50, maxHeight: 120)
                        .aspectRatio(contentMode: .fit)
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
                    Text("Save changes")
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundColor(Color(UIColor.white))
                })
                .frame(maxWidth: .infinity)
                .padding(15)
                .background(self.canCreate ? Color(UIColor.systemPink) : Color.gray)
                .cornerRadius(10)
                .padding(.top, 50)
                    .padding(.bottom, 0)
                
                
                
                }.customEditorStyle()
            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            .padding(.bottom, keyboard.currentHeight)
                
            .navigationBarTitle("New Coupon")
            .navigationBarItems(leading: Button("Cancel") {
                self.presentation.wrappedValue.dismiss()
            })
        }
        
        
    }
}


extension CouponEditorView {
    func add() {
        coupon.brand = self.brand
        coupon.location = self.location.trimmingCharacters(in: [" "]) == "" ? nil : self.location
        coupon.expirationDate = self.hasExpirationDate ? self.expirationDate : nil
        coupon.minimumAmount = self.hasMinimumAmount ? NSNumber(value: Double(self.minimumAmount) ?? 0.0) : nil
        coupon.offerType = OfferType.init(rawValue: self.offerType)!
        coupon.offerValue = NSNumber(value: Double(self.offerStringValue) ?? 0.0)
        coupon.image = self.image?.pngData() as NSData?
        
        do {
            try self.moc.save()
        } catch let err {
            print(" UNABLE TO SAVE UPDATES ! ERR: \(err.localizedDescription) ")
            print(coupon)
        }
        
        self.presentation.wrappedValue.dismiss()
    }
}

public struct CustomEditorStyle: ViewModifier {
    public func body(content: Content) -> some View {
        content.onAppear {
            UITableViewCell.appearance().backgroundColor = .systemBackground
            UITableView.appearance().separatorColor = .systemBackground
            UITableView.appearance().backgroundColor = .systemBackground
            UITableViewCell.appearance().selectionStyle = .none
            UITableView.appearance().showsVerticalScrollIndicator = false
        }
//        .onDisappear {
//            UITableViewCell.appearance().backgroundColor = .systemBackground
//            UITableView.appearance().separatorColor = .systemBackground
//            UITableView.appearance().backgroundColor = .systemBackground
//            UITableViewCell.appearance().selectionStyle = .none
//            UITableView.appearance().showsVerticalScrollIndicator = false
//        }
    }
}

extension View {
    public func customEditorStyle() -> some View {
        modifier(CustomEditorStyle())
    }
}
