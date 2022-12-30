//
//  CSVExportView.swift
//  jaffhour
//
//  Created by Aidan on 2022-12-30.
//

import SwiftUI
import UniformTypeIdentifiers

struct CSVExportView: View {
    
    // this view should have a list of workdays passed into it
    
    @State private var showingExporter = false
    @State private var document = MessageDocument(message: "")
    
    var body: some View {
        Button {
            showingExporter = true
        } label: {
            HStack {
                Text("Export CSV")
                    .fontWeight(.bold)
                Image(systemName: "arrow.up")
            }
        }.fileExporter(isPresented: $showingExporter, document: document, contentType: .plainText, defaultFilename: "Test.csv") {
            result in
            switch result {
            case .success(let url):
                print("saved to \(url)")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        //    func makeCSV() -> MessageDocument {
        //        let message = "test csv" + "date or smt" + "\n\n" + "lig" + "ma" + "nutz"
        //        return MessageDocument(message: message)
        //    }
        
        
    }
}


// from Galen Smith on stackoverflow
struct MessageDocument: FileDocument {

    static var readableContentTypes: [UTType] { [.plainText] }

    var message: String = ""

    init(message: String) {
        self.message = message
    }

    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents,
              let string = String(data: data, encoding: .utf8)
        else {
            throw CocoaError(.fileReadCorruptFile)
        }

        message = string
    }
    // this will be called when the system wants to write our data to disk
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        return FileWrapper(regularFileWithContents: message.data(using: .utf8)!)
    }
}

struct CSVExportView_Previews: PreviewProvider {
    static var previews: some View {
        CSVExportView()
    }
}
