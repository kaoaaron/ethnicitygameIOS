//
//  PlayOptionsViewScreen.swift
//  EthnicityApp
//
//  Created by Aaron Kao on 2022-04-06.
//

import SwiftUI

class ViewModel: ObservableObject {
    @Published var ethnicities = ["test"]
    
    
    func getEthnicityData() {
        guard let url = URL(string: "https://5d210z0x0a.execute-api.us-east-1.amazonaws.com/dev/ethnicities/asian") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                print("errors?")
                return
            }
            
            var result: Response?
            do {
                result = try JSONDecoder().decode(Response.self, from: data)
            } catch {
                print("failed to convert \(error.localizedDescription)")
            }
            
            guard let json = result else {
                return
            }
            
            var newethnicity : [String] = []
            for ethnicity in json.ethnicities {
                newethnicity.append(ethnicity.ethnicity)
            }
            
            self?.ethnicities = newethnicity
        }
        
        task.resume()
    }
}

struct Response: Codable {
    let ethnicities: [Ethnicities]
    let statusCode: Int
}

struct Ethnicities: Codable {
    let ethnicity: String
}

struct PlayOptionsViewScreen: View {
    @ObservedObject var gameManagerVM: GameManagerVM
    @StateObject var viewModel = ViewModel()

    var firstImage = true
    
    var body: some View {
        ZStack {
            Image("playbg").resizable().aspectRatio(contentMode: ContentMode.fill).ignoresSafeArea()
            
            if (gameManagerVM.model.quizCompleted) {
                
            } else {
                VStack {
                    QuestionText(text: "Question \(GameManagerVM.currentIndex + 1)", size: 30).padding()
                    
                    Spacer()
                    AsyncImage(url: URL(string: GameManagerVM.currentIndex == 0 ? "https://lh3.googleusercontent.com/pw/AM-JKLXj6PKItgeWfOaccyzl7-kvYgo25WrvhLeNZ5HE4YrflV1Ed3RbW2cohC0aWL1wConMN8szW2OxJUskSStn3WoAiNw59sPr5Htune2SHKOPXaDb3IcB1YykUzc5qS2U02bTlsUSe4f-0FaASdKeS2JY7w=w606-h807-no?authuser=0" : GameManagerVM.celebrities[GameManagerVM.currentIndex].image)) { phase in
                        if let image = phase.image {
                            image.resizable().scaledToFit()
                        } else if phase.error != nil {
                            Image(systemName: "exclamationmark.circle")
                        } else {
                            Image(systemName: "photo")
                        }
                    }.animation(.easeInOut(duration: 1.5))
                    
                    Spacer()
                    
                    OptionsGridView(gameManagerVM: gameManagerVM)
                }.onAppear {
                    viewModel.getEthnicityData()
                }
            }
        }
    }
}

struct QuestionText: View {
    var text:  String
    var size: CGFloat
    var body: some View {
        Text(text).foregroundColor(.white).font(.system(size: size, weight: .bold, design: .rounded))
    }
}
