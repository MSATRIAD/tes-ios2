//
//  TesWidgetBundle.swift
//  TesWidget
//
//  Created by Muhammad Satria Dharma on 10/03/26.
//

import WidgetKit
import SwiftUI

@main
struct TesWidgetBundle: WidgetBundle {
    var body: some Widget {
        TesWidget()
        TesWidgetControl()
        TesWidgetLiveActivity()
    }
}
