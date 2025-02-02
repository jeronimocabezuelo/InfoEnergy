//
//  InvoceImporterButtonView.swift
//  InfoEnergy
//
//  Created by Jerónimo Cabezuelo Ruiz on 28/1/25.
//

import SwiftUI
import DeveloperKit
import PDFKit

struct InvoceImporterButtonView: View {
    @State private var isImporting: Bool = false
    
    var onLoadInvoce: (InvoceData) -> Void
    
    var body: some View {
        Button {
            isImporting = true
        } label: {
            Text("Añadir factura")
        }
        .fileImporter(
            isPresented: $isImporting,
            allowedContentTypes: [.pdf],
            allowsMultipleSelection: true
        ) { result in
            do {
                let files = try result.get()
                for file in files {
                    guard file.startAccessingSecurityScopedResource(),
                          let pdf = PDFDocument(url: file),
                          let pdfString = pdf.string,
                          let invoce = extractInvoce(from: pdfString)
                    else {
                        // TODO: Añadir un onLoadInvoiceFailure para mostrar un mensaje de error cuando no se a podido procesar correctamente
                        return
                    }
                    
                    onLoadInvoce(invoce)
                }
            } catch {
                // Handle failure.
                print("Unable to read file contents")
                print(error.localizedDescription)
            }
        }
    }
    
    private func extractInvoce(from pdf: String) -> InvoceData? {
        let lines = pdf.split(separator: "\n")
        
        let periods = extractPeriods(from: lines)
        
        let energy = extractEnergy(from: lines, in: periods)
        let energyGeneration = extractGeneration(from: lines, in: periods)
        
        guard energy.isNotEmpty || energyGeneration.isNotEmpty else { return nil }
        
        let invoce = InvoceData(energy: energy, energyGeneration: energyGeneration)
        
        return invoce
    }
    
    private func extractPeriods(from lines: [String.SubSequence]) -> [DateRange] {
        let periods =  lines
            .filter({ $0.contains("kWh x €/kWh (")})
            .compactMap({
                let startIndex = $0.index(after: $0.firstIndex(of: "(") ?? $0.startIndex)
                let endIndex = $0.index(before: $0.firstIndex(of: ")") ?? $0.endIndex)
                let periodsString = $0[startIndex...endIndex].split(separator: " ")
                
                let startString = periodsString.at(1) ?? ""
                let endString = periodsString.at(3) ?? ""
                
                let startDate = String(startString).createDate(dateFormat: .presentationDateFormat)
                let endDate = String(endString).createDate(dateFormat: .presentationDateFormat)
                
                return DateRange(start: startDate, end: endDate)
            })
            .removingDuplicates()
        
        return periods
    }
    
    private func extractEnergy(from lines: [String.SubSequence], in periods: [DateRange]) -> [InvoceItemData] {
        guard let energyUses = extractVFP(from: lines, filter: "Electricidad utilizada [kWh]"),
              let energyPrices = extractVFP(from: lines, filter: "Precio energía [€/kWh]"),
              energyUses.count == energyPrices.count,
              energyUses.count == periods.count
        else { return [] }
        
        return .init(periods: periods, uses: energyUses, prices: energyPrices)
    }
    
    private func extractGeneration(from lines: [String.SubSequence], in periods: [DateRange]) -> [InvoceItemData] {
        guard let energyUses = extractVFP(from: lines, filter: "Electricidad GenerationkWh utilizada [kWh]"),
              let energyPrices = extractVFP(from: lines, filter: "Precio GenerationkWh [€/kWh]"),
              energyUses.count == energyPrices.count,
              energyUses.count == periods.count
        else { return [] }
        
        return .init(periods: periods, uses: energyUses, prices: energyPrices)
    }
    
    private func extractVFP(from lines: [String.SubSequence], filter: String) -> [TupleVFP]? {
        let energyUsesStrings = lines.filter({ $0.contains(filter)})
        let energyUsesSplitted = energyUsesStrings.map({ $0.split(separator: " ").suffix(3)})
        let energyUses = energyUsesSplitted.map({
            $0.compactMap({
                let n = NumberFormatter().number(from: String($0))
                return CGFloat(truncating: n)
            })
        })
        
        guard energyUses.allSatisfy({ $0.count == 3 }) else { return nil }
        
        let tuplesVFP = energyUses.map({ (valley: $0[2], flat: $0[1], point: $0[0])})
        
        return tuplesVFP
    }
}
