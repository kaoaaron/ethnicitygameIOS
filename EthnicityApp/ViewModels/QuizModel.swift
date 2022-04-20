//
//  QuizModel.swift
//  EthnicityApp
//
//  Created by Aaron Kao on 2022-04-07.
//

import SwiftUI

struct Quiz {
    var currentQuestionIndex: Int
    var quizModel: QuizModel
    var quizCompleted: Bool = false
    var quizWinningStatus: Bool = false
}

struct QuizModel {
    var question: String
    var answer: String
    var optionsList: [QuizOption]
}

struct QuizOption: Identifiable {
    var id: Int
    var optionId: String
    var option: String
    var isSelected: Bool = false
    var isMatched: Bool = false
}
