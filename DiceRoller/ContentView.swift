//
//  ContentView.swift
//  DiceRoller
//
//  Created by Alex Moran on 10/14/23.
//

import SwiftUI

struct ContentView: View {
    private var preRollGridItems: [GridItem] {
        if diceSides < 11 {
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
    @State private var diceSides = 6
    @State private var rollResult = 6
    @State private var hasRolled = false
    @State private var feedback = UINotificationFeedbackGenerator()
    
    var body: some View {
        VStack {
            
            Text("Your rolled a: ")
            Text("\(rollResult)")
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
                        .shadow(radius: 20, x: -15, y: 10)
                    
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
                            ForEach (0...diceSides - 1, id: \.self) { circle in
                                Circle()
                                    .frame(width: min(40, CGFloat(120 / diceSides)), height: min(40, CGFloat(120 / diceSides)))
                                    .foregroundStyle(.black)
                            }
                        }
                        .frame(width: 130, height: 200)
                    }
                }
            }
            
            VStack {
                Text("Amount of Dice Sides")
                Picker("Amount of Dice Sides", selection: $diceSides) {
                    ForEach (2...20, id: \.self) {
                        Text("\($0)")
                    }
                }
                .onChange(of: diceSides) {
                    hasRolled = false
                }
                .accentColor(.black)
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
                        .listRowSeparatorTint(.brown, edges: .all)
//                        .listRowBackground(Color(.brown))
                    }
                    .scrollContentBackground(.hidden)
                    .background(Color.brown.edgesIgnoringSafeArea(.all))
                    
                    Button {
                        rolls.clearResults()
                    } label: {
                        Text("Clear Results")
                            .font(.title)
                            .padding(10)
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .shadow(radius: 10)
                            
                    }
                }
                
            }
                
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .background(.brown)
        .onReceive(timer) { time in
            guard timerIsActive else { return }
            if rollTime > 0 {
                rollTime -= 1
                rollResult = Int.random(in: 1...diceSides)
            } else {
                timerIsActive = false
                recordRoll()
            }
        }
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
