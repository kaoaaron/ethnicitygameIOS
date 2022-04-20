//
//  GameManagerVM.swift
//  EthnicityApp
//
//  Created by Aaron Kao on 2022-04-07.
//

import Foundation
import SwiftUI

class GameManagerVM: ObservableObject {
    static var currentIndex = 0
    static var ethnicities: [String] = []
    static var answer = "Chinese"
    static var celebrities: [PlayMenuViewController.Celebrities] = [PlayMenuViewController.Celebrities(name: "Aaron Kao", image: "https://photos.app.goo.gl/sVcZqG3oyp5CN3HW8", nativeName: "", occupation: "", ethnicity: "chinese")]

    init(ethnicities: [String], celebrities: [PlayMenuViewController.Celebrities]) {
        GameManagerVM.ethnicities = ethnicities
        GameManagerVM.celebrities = celebrities
        print(celebrities[0].name)
    }

    @Published var model = GameManagerVM.createGameModel(i: GameManagerVM.currentIndex)

    static func createGameModel(i: Int) -> Quiz {
        if (GameManagerVM.celebrities[0].name == "Aaron Kao") {
            let firstQ =  QuizModel(question: "", answer: "B", optionsList: [QuizOption(id: 11, optionId: "A", option: "Japanese"),                                                                  QuizOption(id: 12, optionId: "B", option: "Chinese"),
                                                                                QuizOption(id: 13, optionId: "C", option: "Korean"),
                                                                                QuizOption(id: 14, optionId: "D", option: "Malaysian"),
                                                                                ])
            GameManagerVM.currentIndex = 0
            return Quiz(currentQuestionIndex: i, quizModel: firstQ)
        }
        
        let options = ["A", "B", "C", "D"]
        let correctChoice = options.randomElement()
        let ethnicityChoices = GameManagerVM.ethnicities.filter{ $0 != GameManagerVM.celebrities[i].ethnicity }.shuffled()
        var quizOptions : [QuizOption] = []
        
        GameManagerVM.answer = GameManagerVM.celebrities[i].ethnicity

        if (correctChoice == "A") {
            quizOptions.append(QuizOption(id: 11, optionId: "A", option:GameManagerVM.celebrities[i].ethnicity))
        } else {
            quizOptions.append(QuizOption(id: 11, optionId: "A", option:ethnicityChoices[0]))
        }
        
        if (correctChoice == "B") {
            quizOptions.append(QuizOption(id: 12, optionId: "B", option:GameManagerVM.celebrities[i].ethnicity))
        } else {
            quizOptions.append(QuizOption(id: 12, optionId: "B", option:ethnicityChoices[1]))
        }
        
        if (correctChoice == "C") {
            quizOptions.append(QuizOption(id: 13, optionId: "C", option:GameManagerVM.celebrities[i].ethnicity))
        } else {
            quizOptions.append(QuizOption(id: 13, optionId: "C", option:ethnicityChoices[2]))
        }
        
        if (correctChoice == "D") {
            quizOptions.append(QuizOption(id: 14, optionId: "D", option:GameManagerVM.celebrities[i].ethnicity))
        } else {
            quizOptions.append(QuizOption(id: 14, optionId: "D", option:ethnicityChoices[3]))
        }
        
        
        
       let firstQ =  QuizModel(question: "Question \(i)", answer: "B", optionsList: quizOptions)
        
        return Quiz(currentQuestionIndex: i, quizModel: firstQ)
    }
    
    
    func verifyAnswer(selectedOption: QuizOption) -> Bool {
        for index in model.quizModel.optionsList.indices {
            model.quizModel.optionsList[index].isMatched = false
            model.quizModel.optionsList[index].isSelected = false
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            GameManagerVM.currentIndex = GameManagerVM.currentIndex + 1
            self.model = GameManagerVM.createGameModel(i: GameManagerVM.currentIndex)
        }

        if (selectedOption.option == GameManagerVM.answer) {
            return true
        }
        
        return false
    }
}
