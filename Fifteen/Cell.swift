//
//  Cell.swift
//  swiftbs
//
//  Created by Glenn Dufour on 1/16/24.
//

//import Foundation
import SwiftUI

struct Location: Equatable {
    let row: Int
    let col: Int
    
    func plus(delta: Location) -> Location {
        Location(row: self.row + delta.row, col: self.col + delta.col)
    }
}

class CellGrid: ObservableObject {
    @Published var cells: [Cell] = []
    
    var rows: Int
    var cols: Int
    var zeroIndex: Int = 0
      
    init(rows:Int, cols:Int) {
        self.rows = rows
        self.cols = cols
        for i in 0..<(rows * cols) {
            cells.append(Cell(id:i,grid:self))
        }
    }
    
    var neighborsOfZero:[Location] {
        neighborsOf(locationFrom(zeroIndex))
    }
    
    func swapWithZero(_ cell: Cell) {
        let cellIndex = cell.currentIndex
        cells[zeroIndex] = cell
        cells[cellIndex] = Cell(id:0,grid:self)
        cell.updateIndex(zeroIndex)
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
    
    func isNeighborOfZero(_ location: Location) -> Bool {
        neighborsOfZero.contains(location)
    }
    
    func indexFrom(_ location:Location) -> Int {
        self.cols * location.row + location.col
    }
    
    func locationFrom(_ index: Int) -> Location {
        Location(row: index / self.cols, col: index % self.cols)
    }
    
    func locationIsValid(_ location: Location) -> Bool {
        location.row >= 0 && location.row < self.rows
            && location.col >= 0 && location.col < self.cols
    }
    func neighborsOf(_ location: Location) -> [Location] {
        var neighbors: [Location] = []
        let deltas = [Location(row: -1, col: 0), Location(row: +1, col: 0),
                      Location(row: 0, col: -1), Location(row: 0, col: +1)]
        for delta in deltas {
            let newLocation = location.plus(delta: delta)
            if locationIsValid(newLocation) {
                neighbors.append(newLocation)
            }
        }
        return neighbors
    }
    func OBSneighborsOf(_ location: Location) -> [Location] {
        var neighbors: [Location] = []
        for neighbor in [
            { (home:Location) -> Location in
                Location(row: home.row - 1,col: home.col)
            },
            { (home:Location) -> Location in
                Location(row: home.row + 1,col: home.col)
            },
            { (home:Location) -> Location in
                Location(row: home.row,col: home.col - 1)
            },
            { (home:Location) -> Location in
                Location(row: home.row,col: home.col + 1)
            }] {
            let neighborLocation = neighbor(location)
            if locationIsValid(neighborLocation) {
                neighbors.append(neighborLocation)
            }
        }
        return neighbors
    }
}

class Cell: Identifiable {
           
    let id: Int
    let grid: CellGrid
    var currentIndex: Int
    
    var imageName: String  {
        id == 0 ? "0.square.fill" : "\(id).square"
    }
    var location: Location {
        return Location(row: currentIndex / grid.cols, col: currentIndex % grid.cols)
    }
    init(id: Int, grid: CellGrid) {
        self.id = id
        self.grid = grid
        self.currentIndex = id
    }
       
    func wasTapped() {
        if (id == 0 || !grid.isNeighborOfZero(self.location)) {
            print("inactive cell \(id) at \(location) ignored")
        } else {
            print("tap \(id) at \(location) accepted")
            grid.swapWithZero(self)
            grid.display()
            print(grid.neighborsOfZero)
        }
    }
    func updateIndex(_ to: Int) {
        currentIndex = to
    }
}
