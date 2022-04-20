//
//  SwiftUIView.swift
//  EthnicityApp
//
//  Created by Aaron Kao on 2022-04-07.
//

import SwiftUI

var isCorrect = false

struct OptionsGridView: View {
    @State var isAnswered = false
    var gameManagerVM: GameManagerVM
    var columns: [GridItem] = Array (repeating: GridItem(.fixed(170), spacing: 0), count: 2)
    var body: some View {
        if (!isAnswered) {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(gameManagerVM.model.quizModel.optionsList) { quizOption in
                    OptionCardView(quizOption: quizOption)
                        .onTapGesture {
                            isCorrect = gameManagerVM.verifyAnswer(selectedOption: quizOption)
                            isAnswered = true
                            
                            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(5)) {
                                isAnswered = false
                            }
                        }
                }
            }
        } else {
            VStack {
                if (isCorrect) {
                    Text(GameManagerVM.currentIndex == 0 ? "Chinese" : GameManagerVM.celebrities[GameManagerVM.currentIndex].ethnicity).foregroundColor(.green).font(.system(size: 40))
                } else {
                    Text(GameManagerVM.currentIndex == 0 ? "Chinese" : GameManagerVM.celebrities[GameManagerVM.currentIndex].ethnicity).foregroundColor(.red).font(.system(size: 40))
                }
                Text(GameManagerVM.currentIndex == 0 ? "Aaron Kao" :  GameManagerVM.celebrities[GameManagerVM.currentIndex].name).font(.system(size: 30))

                Text(GameManagerVM.currentIndex == 0 ? "高文轩" : GameManagerVM.celebrities[GameManagerVM.currentIndex].nativeName).font(.system(size: 30))
                
                Text(GameManagerVM.currentIndex == 0 ? "Developer" : GameManagerVM.celebrities[GameManagerVM.currentIndex].occupation).font(.system(size: 30))
                
            }.frame(width: 340, height: 340).background(Color.white).padding().cornerRadius(60)
            Spacer()
        }
    }
}

struct OptionCardView: View {
    var quizOption: QuizOption
    var body: some View {
        VStack {
            if (quizOption.isMatched) && (quizOption.isSelected) {
                OptionStatusImageView(imageName: "checkmark")
            } else if (!(quizOption.isMatched) && quizOption.isSelected) {
                OptionStatusImageView(imageName: "xmark")
            } else {
                OptionView(quizOption: quizOption)
            }
        }.frame(width: 150, height: 150).background(setBackgroundColor()).cornerRadius(40)
    }
    
    func setBackgroundColor() -> Color {
        if (quizOption.isMatched) && (quizOption.isSelected) {
            return Color.green
        } else if (!(quizOption.isMatched) && (quizOption.isSelected)) {
            return Color.red
        } else {
            return Color.white
        }
    }
}

struct OptionView: View {
    var quizOption: QuizOption
        var body: some View {
            VStack {
                Text(quizOption.optionId)
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    .frame(width: 50, height: 50)
                    .background(.white)
                    .cornerRadius(25)
                
                Text(quizOption.option)
                    .frame(width: 150, height: 30)
                    .font(.system(size: 20, weight: .bold, design: .rounded))
            }
        }
}

struct OptionStatusImageView: View {
    var imageName: String
    var body: some View {
        Image(systemName: imageName)
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
}
