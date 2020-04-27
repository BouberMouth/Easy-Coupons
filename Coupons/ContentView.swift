//
//  ContentView.swift
//  Coupons
//
//  Created by Antoine on 08/04/2020.
//  Copyright © 2020 BOUBERBOUCHE Antoine. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        TabView {
            CouponsView()
                .tabItem {
                    Image(systemName: "rectangle.stack.fill")
                    Text("Coupons")
            }
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
            }
        }.accentColor(Color(UIColor.systemPink))
    }
}

//MARK: -

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        .environment(\.colorScheme, .dark)
    }
}
