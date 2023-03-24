//
//  TransitionPractice.swift
//  jaffhour
//
//  Created by Aidan on 2023-03-23.
//

import SwiftUI

struct TransitionPractice: View {
    @Namespace var namespace
    @State private var showingDetails = false

        var body: some View {
            ZStack {
                if !showingDetails {
                    VStack {
                        Text("Calendar")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding()

                        Circle()
                            .foregroundColor(.green)
                            .frame(width: 50, height: 50)
                            .matchedGeometryEffect(id: "circle", in: namespace)
                            .onTapGesture {
                                withAnimation(.spring()) {
                                    showingDetails = true
                                }
                            }
                    }
                } else {
                    VStack {
                        Text("Details")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding()

                        Spacer()

                        Circle()
                            .foregroundColor(.green)
                            .frame(width: 200, height: 200)
                            .matchedGeometryEffect(id: "circle", in: namespace)
                            .onTapGesture {
                                withAnimation(.spring()) {
                                    showingDetails = false
                                }
                            }

                        Spacer()

                        Text("Some details about the day")
                            .padding()
                    }
                }
            }
        }
    }


struct TransitionPractice_Previews: PreviewProvider {
    static var previews: some View {
        TransitionPractice()
    }
}
