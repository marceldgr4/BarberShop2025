//
//  DateExtensionsSchedule.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 9/01/26.
//

import Foundation
import Combine

extension Date {
    var dayOfWeek: Int{
        Calendar.current.component(.weekday, from: self) - 1
    }
    
    func toString() -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: self)
    }
    
    
        
    }

   
   

