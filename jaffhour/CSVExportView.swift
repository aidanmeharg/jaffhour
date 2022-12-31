//
//  CSVExportView.swift
//  jaffhour
//
//  Created by Aidan on 2022-12-30.
//

import SwiftUI
import UniformTypeIdentifiers
import CodableCSV

struct CSVExportView: View {
    
    // this view should have a list of workdays passed into it
    
    let job: Job
    let start: Date
    let end: Date
    
    @State private var showingExporter = false
    @State private var document = MessageDocument(message: "")
    
    var body: some View {
        Button {
            var inputData = [
            ["Date", "Start", "End", "Hours", "Tasks", "Payee", "Description", "Amount", "Expense Total", "Notes"]
            ]
            let dateFormatter = DateFormatter()
            let timeFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MMM-YY"
            timeFormatter.dateStyle = .none
            timeFormatter.timeStyle = .short
            for wd in job.workdays {
                if wd.date >= start && wd.date <= end {
                    inputData.append([dateFormatter.string(from: wd.date),
                                      timeFormatter.string(from: wd.startTime),
                                      timeFormatter.string(from: wd.endTime),
                                      String(wd.hours),
                                      wd.tasks,
                                     "payee here",
                                      "expense description here",
                                      "expense amount here",
                                      String(wd.expenses.map{$0.amount}.reduce(0, +)),
                                      wd.notes])
                }
            }
            do {
                let string = try CSVWriter.encode(rows: inputData, into: String.self)
                document.message = string
            } catch {
                fatalError("Error occured during encoding CSV: \(error)")
            }
            showingExporter = true
            
        } label: {
            HStack {
                Text("Export Table")
                    .fontWeight(.bold)
                Image(systemName: "arrow.up.square")
                    .fontWeight(.bold)
            }
        }.fileExporter(isPresented: $showingExporter, document: document, contentType: .plainText, defaultFilename: "\(job.title).csv") {
            result in
            switch result {
            case .success(let url):
                print("saved to \(url)")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        
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
        CSVExportView(job: Job.example, start: Date(), end: Date())
    }
}
