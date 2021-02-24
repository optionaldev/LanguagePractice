//
// The LanguagePractice project.
// Created by optionaldev on 24/02/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

import SwiftPrint

final class Logger {
    
    static func performInitialSetup() {
        #if DEBUG
        SwiftPrint.Setup.isEnabled = true
        #else
        SwiftPrint.Setup.isEnabled = false
        #endif
    }
}

func log(_ message: Any?,
           object: AnyObject? = nil,
           filePath: String = #file,
           lineOfCode: UInt = #line)
{
    if let output = SwiftPrint.generateOutput(message: message,
                                              object: object,
                                              filePath: filePath,
                                              lineOfCode: lineOfCode)
    {
        Swift.print(output)
    }
}

