//
//  SetingsView.swift
//  Coupons
//
//  Created by Antoine on 21/04/2020.
//  Copyright © 2020 BOUBERBOUCHE Antoine. All rights reserved.
//

import SwiftUI
import MessageUI

struct SettingsView: View {
    
    @ObservedObject var model = SettingsModel()
    
    @State var result: Result<MFMailComposeResult, Error>? = nil
    @State var isShowingMailView = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Language and currency")) {
                    
                    Picker("Language", selection: $model.selectedLanguage) {
                        ForEach(Language.allCases) { language in
                            Text(language.description)
                        }
                    }
                    Picker("Currency", selection: $model.selectedCurrency) {
                        ForEach(Currency.allCases) { currency in
                            Text(currency.description)
                        }
                    }
                }
                
                Section(header: Text("Notifications")) {
                    DatePicker("Notification time", selection: $model.selectedNotificationTime, displayedComponents: .hourAndMinute)
                }
                
                Section(header: Text("Contact")) {
                    Text("Contact us")
                        .onTapGesture {
                            self.isShowingMailView.toggle()
                    }
                    .disabled(!MFMailComposeViewController.canSendMail())
                    .sheet(isPresented: $isShowingMailView) {
                        MailView(result: self.$result)
                    }
                }
                
            }.customSettingsStyle()
                
        .navigationBarTitle("Settings")
                .navigationBarItems(trailing: Button(action: {
                    print(self.model.description)
                }, label: {
                    Text("Bite")
                }))
        }
    }
}


public struct CustomSettingsStyle: ViewModifier {
    public func body(content: Content) -> some View {
        content.onAppear {
            UITableView.appearance().backgroundColor = .systemBackground
            UITableViewCell.appearance().backgroundColor = .secondarySystemBackground
            UITableView.appearance().separatorColor = UIColor.gray.withAlphaComponent(0.5)
            UITableViewCell.appearance().selectionStyle = .none
            UITableView.appearance().showsVerticalScrollIndicator = false
        }
    }
}

extension View {
    public func customSettingsStyle() -> some View {
        modifier(CustomSettingsStyle())
    }
}
