//
//  ColorAdaptive.swift
//  GradeMate
//
//  Created by Joaquin Sedamano on 12/2/25.
//

import SwiftUI

extension Color {
    init(light: UIColor, dark: UIColor) {
        self = Color(UIColor { trait in
            trait.userInterfaceStyle == .dark ? dark : light
        })
    }
}
