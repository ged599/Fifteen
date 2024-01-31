//
//  FifteenApp.swift
//  Fifteen
//
//  Created by Glenn Dufour on 1/29/24.
//

import SwiftUI

@main
struct FifteenApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(CellGrid(rows: 4, cols: 4))
        }
    }
}
