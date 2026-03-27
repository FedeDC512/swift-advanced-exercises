//
//  ContentView.swift
//  SimpleTextClassifier
//
//  Created by Federico Agnello on 27/03/26.
//

import SwiftUI
import CoreML
import NaturalLanguage

struct ContentView: View
{
     @State var text = ""
     @State var sentence = ""
     @State var sentiment = ""
    
    //Instance of the text classifier (type NATURAL LANGUAGE MODEL - NLMODEL)
    let model: NLModel = {
        do {
            //Use a model configuration instance to configure an MLModel instance
            let config = MLModelConfiguration()
            
            //Instance of the model created with CreateML file
            let model = try SentimentAnalysis(configuration: config).model
            
            //Final sentiment classifier instance to use
            let sentimentClassifier = try NLModel(mlModel: model)
            
            return sentimentClassifier
            
        } catch {
            print(error)
            fatalError("Couldn't create Sentiment Classifier!")
        }
    }()
    
   
    // UI SECTION
    var body: some View
       {
        VStack {
            
            Text("Sentence Classifier")
                .bold()
                .padding()
                .font(.title)
             
            TextField("Write here your sentence...", text: $sentence)
                .padding()
                
           
            Button(action: {
            self.classify()
            })
            {
                Text("Classify")
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .font(.title)
            
            Text(sentiment)
                .bold()
                .padding()
                .font(.system(size: 60))
            
            Spacer()
        }
       }
    
    /**
     * Function that use the CoreML model for the inference phase
     */
    func classify()
    {
        if let label = model.predictedLabel(for: sentence)
        {
            switch label {
            case "pos":
                self.sentiment = "Positive 😃"
            case "neg":
                self.sentiment = "Negative 🙁"
            default:
                self.sentiment = "😒" //Never shown in this case
            }
        }
    }
    
    
    
}

#Preview {
    ContentView()
}
