//
//  ImportButton.swift
//  InfoEnergy
//
//  Created by Jerónimo Cabezuelo Ruiz on 29/7/24.
//

import SwiftUI
import UniformTypeIdentifiers

struct InputDocument: Equatable {
    var input: String
    
    init(input: String) {
        self.input = input
    }
    
    static var mock: Self {
        if let path = Bundle.main.path(forResource: "mock", ofType: "csv"),
           let input = try? String(contentsOfFile: path) {
            return .init(input: input)
        } else {
            return .init(input: "")
        }
    }
    
    static func  == (lhs: Self, rhs: Self) -> Bool {
        return lhs.input == rhs.input
    }
}

struct ImportButton: View {
    @State private var document: InputDocument = .mock
    @State private var isImporting: Bool = false
    
    var onLoadDocument: (String) -> Void
    
    var body: some View {
        
        Button {
            isImporting = true
        } label: {
            Image(systemName: "square.and.arrow.down")
        }
        .fileImporter(
            isPresented: $isImporting,
            allowedContentTypes: [.plainText],
            allowsMultipleSelection: false
        ) { result in
            do {
                guard let selectedFile: URL = try result.get().first,
                      selectedFile.startAccessingSecurityScopedResource()
                else { return }
                let data = try Data(contentsOf: selectedFile)
                
                guard let input = String(data: data, encoding: .utf8) else { return }
                
                document = InputDocument(input: input)
            } catch {
                // Handle failure.
                print("Unable to read file contents")
                print(error.localizedDescription)
            }
        }
        .onChange(of: document) { oldDocument, newDocument in
            onLoadDocument(document.input)
        }
    }
}

#Preview {
    ImportButton(onLoadDocument: {
        print($0)
    })
}

struct FileImporterContentView: View {
    
    @State private var document: InputDocument = InputDocument(input: "")
    @State private var isImporting: Bool = false
    
    var body: some View {
        HStack {
            Button(action: { isImporting = true}, label: {
                Text("Push to browse to location of data file")
            })
            Text(document.input)
        }
        .padding()
        .fileImporter(
            isPresented: $isImporting,
            allowedContentTypes: [.plainText],
            allowsMultipleSelection: false
        ) { result in
            do {
                guard let selectedFile: URL = try result.get().first else { return }
                guard selectedFile.startAccessingSecurityScopedResource() else { // Notice this line right here
                    return
                }
                guard let input = String(data: try Data(contentsOf: selectedFile), encoding: .utf8) else { return }
                document.input = input
            } catch {
                // Handle failure.
                print("Unable to read file contents")
                print(error.localizedDescription)
            }
        }
    }
}
