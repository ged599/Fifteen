//
//  Cell.swift
//  swiftbs
//
//  Created by Glenn Dufour on 1/16/24.
//

//import Foundation
import SwiftUI

struct Location {
    let row: Int
    let col: Int
}

class CellGrid: ObservableObject {
    @Published var cells: [Cell] = []
    
    var rows: Int
    var cols: Int
    var zeroIndex: Int = 0
    
    func validLocation(_ location: Location) -> Bool {
        if location.row - 1 > 0 && location.row + 1 <= self.rows {
            return false
        }
        return true
    }
    
    init(rows:Int, cols:Int) {
        self.rows = rows
        self.cols = cols

        for i in 0..<(rows * cols) {
            cells.append(Cell(id:i,grid:self))
        }
    }
    
    func swapWithZero(_ cell: Cell) {
        let cellIndex = cell.currentIndex
        cells[zeroIndex] = cell
        cells[cellIndex] = Cell(id:0,grid:self)
        cell.currentIndex = zeroIndex
        zeroIndex = cellIndex
    }
    
    func display() {
        var ndx = 0
        for _ in 0..<rows {
            for _ in 0..<cols {
                print("[\(ndx):\(cells[ndx].id):\(cells[ndx].currentIndex)]",terminator:"")
                ndx += 1
            }
            print("")
        }
    }
    
    func indexFrom(_ location:Location) -> Int {
        self.cols * location.row + location.col
    }
    
    func locationFrom(_ index: Int) -> Location {
        Location(row: index / self.cols, col: index % self.cols)
    }
    
    func neighbor(above location: Location) -> Location? {
        guard location.row - 1 < 0 else {
            return Location(row: location.row - 1, col: location.col)
        }
        return nil
    }
    func neighbor(below location: Location) -> Location? {
        guard location.row + 1 > self.rows else {
            return Location(row: location.row + 1, col: location.col)
        }
        return nil
    }
    func neighbor(leftOf location: Location) -> Location? {
        guard location.col - 1 < 0 else {
            return Location(row: location.row, col: location.col - 1)
        }
        return nil
    }
    func neighbor(rightOf location: Location) -> Location? {
        guard location.col + 1 < 0 else {
            return Location(row: location.row, col: location.col + 1)
        }
        return nil
    }
    func neighborsOf(_ location: Location) -> [Int] {
        for f in [{self.neighbor(above: $0)}]
    }
}

class Cell: Identifiable {
           
    let id: Int
    let grid: CellGrid
    var currentIndex: Int
    
    var imageName: String  {
        id == 0 ? "0.square.fill" : "\(id).square"
    }
//    var index: Int {
//        Int(grid.cells.firstIndex(where: {cell in cell.id == self.id})!)
//    }
    var location: Location {
        return Location(row: currentIndex / grid.cols, col: currentIndex % grid.cols)
    }
    init(id: Int, grid: CellGrid) {
        self.id = id
        self.grid = grid
        self.currentIndex = id
    }
    
    func wasTapped() {
        print("Cell \(id) at \(location) was tapped")
        grid.swapWithZero(self)
        grid.display()
    }
    func updateIndex(_ to: Int) {
        currentIndex = to
    }
}
