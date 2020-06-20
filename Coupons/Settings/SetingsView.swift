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
                Section(header: Text(String.localize(forKey: "SETTINGS.CURRENCY.SECTION_TITLE"))) {
                    
//                    Picker("Language", selection: $model.selectedLanguage) {
//                        ForEach(Language.allCases) { language in
//                            Text(language.description)
//                        }
//                    }
                    Picker(String.localize(forKey: "SETTINGS.CURRENCY.CURRENCY"), selection: $model.selectedCurrency) {
                        ForEach(Currency.allCases) { currency in
                            Text(currency.description)
                        }
                    }
                }
                
                Section(header: Text(String.localize(forKey: "SETTINGS.APPEARANCE.SECTION_TITLE"))) {
                    Picker(String.localize(forKey: "SETTINGS.APPEARANCE.TINT_COLOR"), selection: $model.selectedTintColor) {
                        ForEach(TintColor.allCases) { tint in
                            HStack(alignment: .center) {
                                Color(tint.toUIColor)
                                    .clipShape(Circle())
                                    .frame(minWidth: 10, maxWidth: 20, minHeight: 10, maxHeight: 20)
                                Text(tint.description)
                            }
                        }
                    }
                }
                
                Section(header: Text(String.localize(forKey: "SETTINGS.NOTIFICATIONS.SECTION_TITLE"))) {
                    DatePicker(String.localize(forKey: "SETTINGS.NOTIFICATIONS.REMINDERS_TIME"), selection: $model.selectedNotificationTime, displayedComponents: .hourAndMinute)
                }
                
                Section(header: Text(String.localize(forKey: "SETTINGS.CONTACT.SECTION_TITLE"))) {
                    Text(String.localize(forKey: "SETTINGS.CONTACT.CONTACT_US"))
                        .onTapGesture {
                            self.isShowingMailView.toggle()
                    }
                    .disabled(!MFMailComposeViewController.canSendMail())
                    .sheet(isPresented: $isShowingMailView) {
                        MailView(result: self.$result)
                    }
                }
                
            }.customSettingsStyle()
                
                .navigationBarTitle(String.localize(forKey: "TAB_BAR_TITLE.SETTINGS"))
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

//MARK: -  DEBUG: Notifications viewer
struct NotifView: View {
    
    var notifications: [UNNotificationRequest] {
        var arr = [UNNotificationRequest]()
        var time = false
        UserNotificationsService.shared.center.getPendingNotificationRequests { (notifications) in
            for n in notifications {
                arr.append(n)
            }
            time = true
            
        }
        while time == false {}
        return arr
    }
    
    var body: some View {
        List {
            ForEach(0..<notifications.count) { i in
                NavigationLink(destination: NotificationDetails(notif: self.notifications[i])) {
                    Text(verbatim: "\(self.notifications[i].identifier)")
                }
            }
        }
    }
}
struct NotificationDetails: View {
    
    let notif: UNNotificationRequest
    
    var trigger: UNCalendarNotificationTrigger {
        return notif.trigger! as! UNCalendarNotificationTrigger
    }
    
    var date: String {
        let comp = trigger.dateComponents
        let dte = Calendar.current.date(from: comp)!
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM yyyy HH:mm"
        let formattedDate = formatter.string(from: dte)
        return formattedDate
    }
    
    var body: some View {
        VStack {
            Text("ID --- \(notif.identifier)")
            Text("TIME --- \(date)")
        }
    }
}
