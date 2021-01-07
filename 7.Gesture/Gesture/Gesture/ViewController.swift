//
//  ViewController.swift
//  Gesture
//
//  Created by nju on 2021/1/7.
//

import UIKit
import CoreML
import CoreMotion

class ViewController: UIViewController {
    
    // Config struct stores constants that control app's ML
    struct Config {
        static let samplesPerSecond = 25.0
        static let numberOfFeatures = 6
        static let windowSize = 20
        
        static let windowOffset = 5
        static let numberOfWindows = windowSize / windowOffset
        static let bufferSize = windowSize + windowOffset * (numberOfWindows - 1)
        
        static let doubleSize = MemoryLayout<Double>.stride
        static let windowSizeAsBytes = doubleSize * numberOfFeatures * windowSize
        static let windowOffsetAsBytes = doubleSize * numberOfFeatures * windowOffset
    }
    
    // MARK: - Core Motion properties
    let motionManager = CMMotionManager()
    let queue = OperationQueue()
    
    // MARK: - Core ML properties
    let modelInput: MLMultiArray! = makeMLMultiArray(numberOfSamples: Config.windowSize)
    let dataBuffer: MLMultiArray! = makeMLMultiArray(numberOfSamples: Config.bufferSize)
      
    var bufferIndex = 0
    var isDataAvailable = false
    
    let gestureClassifier = try! GestureClassifier(configuration: MLModelConfiguration())
    var predictResult : GestureClassifierOutput!
    
    @IBOutlet weak var motionResult: UILabel!
    @IBOutlet weak var motionProb: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        motionManager.deviceMotionUpdateInterval = 1 / Config.samplesPerSecond
        motionManager.startDeviceMotionUpdates(using: .xArbitraryZVertical, to: queue, withHandler: { [weak self] motionData, error in
            guard let self = self, let motionData = motionData else {
              if let error = error {
                print("Device motion update error: \(error.localizedDescription)")
              }
              return
            }
            self.process(motionData: motionData)
            if self.bufferIndex == 0 {
                self.isDataAvailable = true
            }
            self.predict()
        })
    }
    
    func process(motionData: CMDeviceMotion) {
        for offset in [0, Config.windowSize] {
                    let index = bufferIndex + offset
                    if index >= Config.bufferSize {
                        continue
                    }
                    addToBuffer(index, 0, motionData.rotationRate.x)
                    addToBuffer(index, 1, motionData.rotationRate.y)
                    addToBuffer(index, 2, motionData.rotationRate.z)
                    addToBuffer(index, 3, motionData.userAcceleration.x)
                    addToBuffer(index, 4, motionData.userAcceleration.y)
                    addToBuffer(index, 5, motionData.userAcceleration.z)
                }
                bufferIndex = (bufferIndex + 1) % Config.windowSize
    }
    
    func addToBuffer(_ idx1: Int, _ idx2: Int, _ data: Double) {
        let index = [0, idx1, idx2] as [NSNumber]
        dataBuffer[index] = NSNumber(value: data)
    }

    func predict(){
            if isDataAvailable
                && bufferIndex % Config.windowOffset == 0
                && bufferIndex + Config.windowOffset <= Config.windowSize {
        
                let window = bufferIndex / Config.windowOffset
                memcpy(
                    modelInput.dataPointer,
                    dataBuffer.dataPointer.advanced(by: window * Config.windowOffsetAsBytes),
                    Config.windowSizeAsBytes
                )
                
                var predictorInput: GestureClassifierInput! = nil
                if predictResult != nil{
                    predictorInput = GestureClassifierInput(features: modelInput, hiddenIn: predictResult.hiddenOut, cellIn: predictResult.cellOut)
                } else{
                    predictorInput = GestureClassifierInput(features: modelInput)
                }
                
                do {
                    predictResult = try gestureClassifier.prediction(input: predictorInput)
                } catch{
                    fatalError("Unable to predict!")
                }
                
                DispatchQueue.main.async {
                    let result = self.predictResult.activity
                    let confidence = self.predictResult.activityProbability[result]!
                    self.motionResult.text = result
                    self.motionProb.text = String(format: "%.3f%%", confidence * 100)
                }
                
            }
        }
    
    // MARK: - Core ML methods
    static private func makeMLMultiArray(numberOfSamples: Int) -> MLMultiArray? {
        try? MLMultiArray(
            shape: [1, numberOfSamples, Config.numberOfFeatures] as [NSNumber],
            dataType: .double)
    }
    
}

