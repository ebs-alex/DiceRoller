//
//  ContentView.swift
//  DiceRoller
//
//  Created by Alex Moran on 10/14/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = ViewModel()
    
    private var preRollGridItems: [GridItem] {
        if viewModel.diceSides < 11 {
            [
                .init(.flexible(), spacing: 2),
                .init(.flexible(), spacing: 2),
            ]
        } else {
            [
                .init(.flexible(), spacing: 2),
                .init(.flexible(), spacing: 2),
                .init(.flexible(), spacing: 2),
                .init(.flexible(), spacing: 2),
            ]
        }
    }
    
    private var postRollGridItems: [GridItem] {
        var gridItems: [GridItem] = []

        if rollResult < 2 {
            gridItems = [
                .init(.flexible(), spacing: 2)
            ]
        } else if rollResult < 11 {
            gridItems = [
                .init(.flexible(), spacing: 2),
                .init(.flexible(), spacing: 2),
            ]
        } else {
            gridItems = [
                .init(.flexible(), spacing: 2),
                .init(.flexible(), spacing: 2),
                .init(.flexible(), spacing: 2),
                .init(.flexible(), spacing: 2),
            ]
        }

        return gridItems
    }
    
    @State private var rollTime = 3
    let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    @State private var timerIsActive = false

    @StateObject var rolls = RollResults()
//    @State private var viewModel.diceSides = 6
    @State private var rollResult = 6
    @State private var hasRolled = false
    @State private var feedback = UINotificationFeedbackGenerator()
    
    var body: some View {
        VStack {
            
            Text("Your rolled a: ")
            Text( hasRolled ? "\(rollResult)" : "...")
                .font(.title2)
                .bold()
                .padding(.bottom)
            
            Button {
                rollDice()
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 15.0)
                        .frame(width: 200, height: 200)
                        .foregroundStyle(.white)
                        .shadow(radius: 12, x: -40, y: -15)
                    
                    if hasRolled {
                        LazyVGrid (columns: postRollGridItems, spacing: 25) {
                            ForEach (0...rollResult - 1, id: \.self) { circle in
                                Circle()
                                    .frame(width: min(40, CGFloat(120 / rollResult)), height: min(40, CGFloat(120 / rollResult)))
                                    .foregroundStyle(.black)
                            }
                        }
                        .frame(width: 130, height: 200)
                    } else {
                        LazyVGrid (columns: preRollGridItems, spacing: 25) {
                            ForEach (0...viewModel.diceSides - 1, id: \.self) { circle in
                                Circle()
                                    .frame(width: min(40, CGFloat(120 / viewModel.diceSides)), height: min(40, CGFloat(120 / viewModel.diceSides)))
                                    .foregroundStyle(.black)
                            }
                        }
                        .frame(width: 130, height: 200)
                    }
                }
            }
            
            VStack {
                Text("Amount of Dice Sides")
                Picker("Amount of Dice Sides", selection: $viewModel.diceSides) {
                    ForEach (2...20, id: \.self) {
                        Text("\($0)")
                    }
                }
                .onChange(of: viewModel.diceSides) {
                    hasRolled = false
                }
                .accentColor(.white)
                .scaleEffect(CGSize(width: 1.5, height: 1.5))
            }
            .padding(.vertical, 35)
            
            VStack {
                if rolls.results.isEmpty {
                    Spacer()
                } else {
                    Text("Previous results:")
                        .font(.headline)
                    
                    List {
                        ForEach(rolls.results, id: \.self) {result in
                            Text("\(result)")
                        }
                        .foregroundStyle(.black)
                        .listRowSeparatorTint(.brown, edges: .all)
//                        .listRowBackground(Color(.brown))
                    }
                    .scrollContentBackground(.hidden)
                    .background(.ultraThinMaterial.opacity(0.6))
                    .clipShape(RoundedRectangle(cornerRadius: 15.0))
                    
                    Button {
                        rolls.clearResults()
                    } label: {
                        Text("Clear Results")
                            .foregroundStyle(.mint)
                            .font(.title.bold())
                            .padding(10)
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .shadow(radius: 10)
                            
                    }
                    .padding(.top)
                }
                
            }
                
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .background(Image("billiardsGreen"))
        .onReceive(timer) { time in
            guard timerIsActive else { return }
            if rollTime > 0 {
                rollTime -= 1
                rollResult = Int.random(in: 1...viewModel.diceSides)
            } else {
                timerIsActive = false
                recordRoll()
            }
        }
        .foregroundStyle(.white)
        .preferredColorScheme(.light)
    }
    
    func rollDice() {
        rollTime = 3
        hasRolled = true
        timerIsActive = true
        feedback.notificationOccurred(.success)
    }
    
    func recordRoll() {
        rolls.add(rollResult)
    }
}

#Preview {
    ContentView()
}
