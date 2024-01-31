//
//  ContentView.swift
//  Fifteen
//
//  Created by Glenn Dufour on 1/29/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var cellGrid: CellGrid
    
    let rowGuides = [
        GridItem(.fixed(75)),
        GridItem(.fixed(75)),
        GridItem(.fixed(75)),
        GridItem(.fixed(75))
    ]
    
    var body: some View {
        Spacer()
        LazyVGrid(columns: rowGuides) {
            ForEach(cellGrid.cells) { cell in
                Button(action: cell.wasTapped, label: {
                    Image(systemName: cell.imageName).resizable().frame(width: 75, height: 75)
                }).foregroundColor(.black)
            }
        }
        .padding()
        Spacer()
        Spacer()
    }
}

#Preview {
    ContentView().environmentObject(CellGrid(rows:4, cols:4))
}
