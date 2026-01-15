//
//  TimeBlocksComponents.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 14/01/26.
//

import SwiftUI

// MARK: - Time Blocks Grid
struct TimeBlocksGrid: View {
    let blocks: [TimeBlock]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Available Time Slots")
                .font(.headline)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                ForEach(blocks) { block in
                    TimeBlockCell(block: block)
                }
            }
        }
    }
}

// MARK: - Time Block Cell
struct TimeBlockCell: View {
    let block: TimeBlock
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: block.blockType.icon)
                .font(.title3)
                .foregroundColor(Color(hex: block.blockType.color))
            
            Text(block.startTime)
                .font(.caption)
                .fontWeight(.semibold)
            
            Text(block.blockType.rawValue.capitalized)
                .font(.caption2)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(hex: block.blockType.color).opacity(0.1))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(hex: block.blockType.color), lineWidth: 1)
        )
    }
}
