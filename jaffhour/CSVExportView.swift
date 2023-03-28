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
    
    
    // TODO: move all of this logic out into a class where we can call it
    
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
            for wd in job.workdays.reversed() {
                if wd.date >= Calendar.current.date(byAdding: .day, value: -1, to: start)! && wd.date <= end {
                    if wd.expenses.count == 0 {
                        inputData.append([dateFormatter.string(from: wd.date),
                                          timeFormatter.string(from: wd.startTime),
                                          timeFormatter.string(from: wd.endTime),
                                          String(wd.hours),
                                          wd.tasks,
                                          "",
                                          "",
                                          "",
                                          String(wd.expenses.map{$0.amount}.reduce(0, +)),
                                          wd.notes])
                    } else {
                        var first = true
                        for e in wd.expenses {
                            if first {
                                inputData.append([dateFormatter.string(from: wd.date),
                                                  timeFormatter.string(from: wd.startTime),
                                                  timeFormatter.string(from: wd.endTime),
                                                  String(wd.hours),
                                                  wd.tasks,
                                                  e.name,
                                                  e.description,
                                                  String(e.amount),
                                                  String(wd.expenses.map{$0.amount}.reduce(0, +)),
                                                  wd.notes])
                                first = false
                            } else {
                                inputData.append(["",
                                                  "",
                                                  "",
                                                  "",
                                                  "",
                                                  e.name,
                                                  e.description,
                                                  String(e.amount),
                                                  "",
                                                  ""])
                            }
                        }
                    }
                    
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
            Label("Export Table", systemImage: "arrow.up.square")
                .font(.title.bold())
//            HStack {
//                Text("Export Table")
//                    .fontWeight(.bold)
//                Image(systemName: "arrow.up.square")
//                    .fontWeight(.bold)
//            }
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
