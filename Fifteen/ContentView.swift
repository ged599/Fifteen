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
        VStack {
            Spacer()
            LazyVGrid(columns: rowGuides) {
                ForEach(cellGrid.cells) { cell in
                    Button(action: cell.wasTapped, label: {
                        Image(systemName: cell.imageName).resizable().frame(width: 75, height: 75)
                    }).foregroundColor(.black)
                }
            }
            //RoundedRectangle( .fill(.cyan)
            Button(action: cellGrid.shuffleOnce, label: {
                Text("shuffle").frame(width:100, height:50).border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: 6)
            }).foregroundColor(.black).background(Color.cyan).cornerRadius(20)
            Spacer()
            Spacer()
        }
    }
}

#Preview {
    ContentView().environmentObject(CellGrid(rows:4, cols:4))
}
