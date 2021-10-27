//
//  Question.swift
//  private fantasy
//
//  Created by Apple on 04/08/21.
//

import UIKit


class Question: NSObject, Codable {
    
    var question : String?
    var position : Int?
    var qid : String?
    var answers : [Answer]?
    
    private static var question : [Question] = []
    
    static var data : [Question] {
        set(question) {
            self.question = question
        }
        get {
            return question
        }
    }

    override init() {
       
    }
    
    public static func sortQuestion(questions : [Question]) -> [Question] {
        return questions.sorted(by: { $0.position! < $1.position! })
    }
    public static func sortAnswer(answers : [Answer]) -> [Answer] {
      
       return answers.sorted(by: { $0.position! < $1.position! })
    }
}

class Answer: NSObject,Codable {
    var answer : String?
    var fanswer : String?
    var aid : String?
    var position : Int?
    var isChecked : Bool?
    override init() {
       
    }
    
}
