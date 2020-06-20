//
//  ImagePlaceholderView.swift
//  Coupons
//
//  Created by Antoine on 08/05/2020.
//  Copyright © 2020 BOUBERBOUCHE Antoine. All rights reserved.
//

import SwiftUI

struct ImagePlaceholderView: View {

    
    var cornerRadius: CGFloat
    var imageFontSize: CGFloat
    
    var body: some View {
        ZStack(alignment: .center) {
            Color(TintColor.userPreference)
            Image(systemName: "photo")
                .foregroundColor(.white)
                .font(.system(size: imageFontSize))
        }
        .clipShape(RoundedRectangle(cornerRadius: self.cornerRadius))
    }
}

struct ImagePlaceholderView_Previews: PreviewProvider {
    static var previews: some View {
        ImagePlaceholderView(cornerRadius: 10, imageFontSize: 20)
    }
}
