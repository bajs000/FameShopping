/*
The MIT License (MIT)

Copyright (c) 2017 Kawoou (Jungwon An)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

import UIKit

public class DrawerSineEaseAnimator: DrawerTickAnimator {

    // MARK: - Enum
    
    public enum EaseType {
        case easeIn
        case easeOut
        case easeInOut
        
        internal func algorithm(value: Double) -> Double {
            switch self {
            case .easeIn:
                return sin((value - 1) * M_PI_2) + 1
            case .easeOut:
                return sin(value * M_PI_2)
            case .easeInOut:
                return 0.5 * (1 - cos(value * M_PI))
            }
        }
    }
    
    
    // MARK: - Property
    
    public var easeType: EaseType
    
    
    // MARK: - Public
    
    public override func tick(delta: TimeInterval, duration: TimeInterval, animations: @escaping (Float)->()) {
        
        animations(Float(self.easeType.algorithm(value: delta / duration)))
        
    }
    
    
    // MARK: - Lifecycle
    
    public init(easeType: EaseType = .easeInOut) {
        self.easeType = easeType
        
        super.init()
    }
    
}
