//
//  ColorAdaptive.swift
//  GradeMate
//
//  Created by Joaquin Sedamano on 12/2/25.
//

import SwiftUI

// ----------------------------------------------------------------
// Adds a convenience initializer to create a Color that adapts to
// light and dark mode.
// ----------------------------------------------------------------
extension Color {
    // Initialize with UIColors for light and dark appearances
    init(light: UIColor, dark: UIColor) {
        // Wrap a dynamic UIColor that switches based on the current interface style
        self = Color(UIColor { trait in
            trait.userInterfaceStyle == .dark ? dark : light
        })
    }
}
