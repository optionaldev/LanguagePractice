//
// The LanguagePractice project.
// Created by optionaldev on 13/06/2022.
// Copyright © 2022 optionaldev. All rights reserved.
// 

import SwiftPrint

final class Logger {
  
  static func performInitialSetup() {
#if DEBUG
    SwiftPrint.Setup.isEnabled = true
    SwiftPrint.Setup.logLevel = .errorsAndUnexpected
#else
    SwiftPrint.Setup.isEnabled = false
#endif
  }
}

func log(_ message: Any?,
         object: AnyObject? = nil,
         type: SwiftPrint.LogType = .error,
         filePath: String = #file,
         lineOfCode: UInt = #line)
{
  if let output = SwiftPrint.generateOutput(message: message,
                                            object: object,
                                            logType: type,
                                            filePath: filePath,
                                            lineOfCode: lineOfCode)
  {
    Swift.print(output)
  }
}

