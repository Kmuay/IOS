/// Copyright (c) 2020 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import NaturalLanguage
import CoreML

let esCharToInt:[Character:Int] = [" ": 0, "!": 1, "\"": 2, "$": 3, "%": 4, "'": 5, "(": 6, ")": 7, "+": 8, ",": 9,
                                   "-": 10, ".": 11, "/": 12, "0": 13, "1": 14, "2": 15, "3": 16, "4": 17, "5": 18, "6": 19,
                                   "7": 20, "8": 21, "9": 22, ":": 23, ";": 24, "?": 25, "A": 26, "B": 27, "C": 28, "D": 29,
                                   "E": 30, "F": 31, "G": 32, "H": 33, "I": 34, "J": 35, "K": 36, "L": 37, "M": 38, "N": 39,
                                   "O": 40, "P": 41, "Q": 42, "R": 43, "S": 44, "T": 45, "U": 46, "V": 47, "W": 48, "X": 49,
                                   "Y": 50, "Z": 51, "a": 52, "b": 53, "c": 54, "d": 55, "e": 56, "f": 57, "g": 58, "h": 59,
                                   "i": 60, "j": 61, "k": 62, "l": 63, "m": 64, "n": 65, "o": 66, "p": 67, "q": 68, "r": 69,
                                   "s": 70, "t": 71, "u": 72, "v": 73, "w": 74, "x": 75, "y": 76, "z": 77, "\u{00a1}": 78, "\u{00ab}": 79,
                                   "\u{00b0}": 80, "\u{00ba}": 81, "\u{00bb}": 82, "\u{00bf}": 83, "\u{00c1}": 84, "\u{00c9}": 85, "\u{00d3}": 86, "\u{00da}": 87, "\u{00e1}": 88, "\u{00e8}": 89,
                                   "\u{00e9}": 90, "\u{00ed}": 91, "\u{00f1}": 92, "\u{00f3}": 93, "\u{00f6}": 94, "\u{00fa}": 95, "\u{00fc}": 96, "\u{015b}": 97, "\u{0441}": 98, "\u{2014}": 99,
                                   "\u{20ac}": 100]

let intToEnChar:[Int:Character] = [0: "\t", 1: "\n", 2: " ", 3: "!", 4: "\"", 5: "$", 6: "%", 7: "'", 8: ",", 9: "-",
                                   10: ".", 11: "/", 12: "0", 13: "1", 14: "2", 15: "3", 16: "4", 17: "5", 18: "6", 19: "7",
                                   20: "8", 21: "9", 22: ":", 23: ";", 24: "?", 25: "A", 26: "B", 27: "C", 28: "D", 29: "E",
                                   30: "F", 31: "G", 32: "H", 33: "I", 34: "J", 35: "K", 36: "L", 37: "M", 38: "N", 39: "O",
                                   40: "P", 41: "Q", 42: "R", 43: "S", 44: "T", 45: "U", 46: "V", 47: "W", 48: "X", 49: "Y",
                                   50: "Z", 51: "a", 52: "b", 53: "c", 54: "d", 55: "e", 56: "f", 57: "g", 58: "h", 59: "i",
                                   60: "j", 61: "k", 62: "l", 63: "m", 64: "n", 65: "o", 66: "p", 67: "q", 68: "r", 69: "s",
                                   70: "t", 71: "u", 72: "v", 73: "w", 74: "x", 75: "y", 76: "z", 77: "\u{00b0}", 78: "\u{00e1}", 79: "\u{00e3}",
                                   80: "\u{00e8}", 81: "\u{00e9}", 82: "\u{00f6}", 83: "\u{2018}", 84: "\u{2019}", 85: "\u{2082}", 86: "\u{20ac}"]

let maxOutSequenceLength = 87
let startTokenIndex = 0
let stopTokenIndex = 1

func getLanguage(text: String) -> NLLanguage? {
    return NLLanguageRecognizer.dominantLanguage(for: text)
}

func getPeopleNames(text: String, block: (String) -> Void) {
    // 1
    let tagger = NLTagger(tagSchemes: [.nameType])
    tagger.string = text
    // 2
    let options: NLTagger.Options = [ .omitWhitespace, .omitPunctuation, .omitOther, .joinNames]
    // 3
    tagger.enumerateTags(in: text.startIndex..<text.endIndex, unit: .word, scheme: .nameType, options: options) {
        tag, tokenRange in
        // 4
        if tag == .personalName {
            block(String(text[tokenRange]))
        }
        return true
    }
}

func getSearchTerms(text: String, language: String? = nil, block: (String) -> Void) {
    // 1
    let tagger = NLTagger(tagSchemes: [.lemma])
    tagger.string = text
    // 2
    if let language = language {
        tagger.setLanguage(NLLanguage(rawValue: language),range: text.startIndex..<text.endIndex)
    }
    // 3
    let options: NLTagger.Options = [.omitWhitespace, .omitPunctuation, .omitOther, .joinNames]
    tagger.enumerateTags(in: text.startIndex..<text.endIndex, unit: .word, scheme: .lemma, options: options) {
        tag, tokenRange in
        let token = String(text[tokenRange]).lowercased()
        if let tag = tag {
            // 4
            let lemma = tag.rawValue.lowercased()
            block(lemma)
            if lemma != token {
                block(token)
            }
        }
        else {
            block(token)
        }
        return true
    }
}

func analyzeSentiment(text:String) -> Double? {
    // 1
    let tagger = NLTagger(tagSchemes: [.sentimentScore])
    tagger.string = text
    // 2
    let (tag, _) = tagger.tag(at: text.startIndex, unit: .paragraph, scheme: .sentimentScore)
    // 3
    guard let sentiment = tag,
    let score = Double(sentiment.rawValue)
    else { return nil }
    return score
}

func getSentimentClassifier() -> NLModel? {
    return try! NLModel(mlModel: SentimentClassifier(configuration: .init()).model)
}

func predictSentiment(text: String, sentimentClassifier: NLModel) -> String? {
    sentimentClassifier.predictedLabel(for: text)
}

// ------------------------------------------------------------------
// -------  Everything below here is for translation chapters -------
// ------------------------------------------------------------------

func getSentences(text: String) -> [String] {
    let tokenizer = NLTokenizer(unit: .sentence)
    tokenizer.string = text
    let sentenceRanges = tokenizer.tokens(for: text.startIndex..<text.endIndex)
    return sentenceRanges.map { String(text[$0]) }
}

func spanishToEnglish(text: String) -> String? {
    guard let encoderIn = getEncoderInput(text) else {
        return nil
    }

    let decoderIn = getDecoderInput(encoderInput: encoderIn)

    let decoder = try! Es2EnCharDecoder16Bit(configuration: .init())
    var translatedText: [Character] = []
    var doneDecoding = false
    var decodedIndex = startTokenIndex
      
    while !doneDecoding {
        decoderIn.encodedChar[decodedIndex] = 1

        let decoderOut = try! decoder.prediction(input: decoderIn)
        decoderIn.decoder_lstm_h_in = decoderOut.decoder_lstm_h_out
        decoderIn.decoder_lstm_c_in = decoderOut.decoder_lstm_c_out
        decoderIn.encodedChar[decodedIndex] = 0
        
        decodedIndex = argmax(array: decoderOut.nextCharProbs)
        if decodedIndex == stopTokenIndex {
            doneDecoding = true
        } else {
            translatedText.append(intToEnChar[decodedIndex]!)
        }

        if translatedText.count >= maxOutSequenceLength {
            doneDecoding = true
        }
    }
    return String(translatedText)
}


func getEncoderInput(_ text: String) -> MLMultiArray? {
    let cleanedText = text.filter { esCharToInt.keys.contains($0) }
  
    if cleanedText.isEmpty {
        return nil
    }
    
    let vocabSize = esCharToInt.count
    let encoderIn = initMultiArray(
        shape: [NSNumber(value: cleanedText.count),
                1,
                NSNumber(value: vocabSize)])

    for (i, c) in cleanedText.enumerated() {
        encoderIn[i * vocabSize + esCharToInt[c]!] = 1
    }
    
    return encoderIn
}

func getDecoderInput(encoderInput: MLMultiArray) ->Es2EnCharDecoder16BitInput {
    let encoder = try! Es2EnCharEncoder16Bit(configuration: .init())
    let encoderOut = try! encoder.prediction(
        encodedSeq: encoderInput,
        encoder_lstm_h_in: nil,
        encoder_lstm_c_in: nil)
    
    let decoderIn = initMultiArray(shape: [NSNumber(value: intToEnChar.count)])

    return Es2EnCharDecoder16BitInput(
        encodedChar: decoderIn,
        decoder_lstm_h_in: encoderOut.encoder_lstm_h_out,
        decoder_lstm_c_in: encoderOut.encoder_lstm_c_out)
}

