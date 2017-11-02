//
//  DFA.swift
//  Algorithms_and_Data_structures
//
//  Created by Paul Kraft on 08.08.17.
//  Copyright © 2017 pauljohanneskraft. All rights reserved.
//

// swiftlint:disable trailing_whitespace

struct DFAState <Character> {
    init(transition: @escaping (Character) -> Int) {
        self.transition = transition
    }
    
    var transition: (Character) -> Int
    
}

struct DFA <Character> {
    let initialState: Int
    let states: [Int: DFAState<Character>]
    let finalStates: Set<Int>
    
    init(states: [Int: DFAState<Character>], initialState: Int, finalStates: Set<Int>) {
        self.states = states
        self.initialState = initialState
        self.finalStates = finalStates
    }
    
    func accepts<S: Sequence>(word: S) throws -> Bool where S.Iterator.Element == Character {
        let end = try finalState(ofWord: word)
        return finalStates.contains(end)
    }
    
    func finalState<S: Sequence>(ofWord word: S) throws -> Int where S.Iterator.Element == Character {
        var index = initialState
        guard var currentState = states[index] else { throw DFAError.statesIncomplete }
        for character in word {
            index = currentState.transition(character)
            guard let nextState = states[index] else { throw DFAError.statesIncomplete }
            currentState = nextState
        }
        return index
    }
    
    enum DFAError: Error {
        case statesIncomplete
    }
}