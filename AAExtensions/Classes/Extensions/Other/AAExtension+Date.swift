//
//  AAExtension+Date.swift
//  AAExtensions
//
//  Created by M. Ahsan Ali on 14/03/2019.
//
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.


// MARK:- Date
public extension Date {

    func aa_toString(fromFormat: String, currentTimeZone: Bool) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = fromFormat
        dateFormatter.timeZone = currentTimeZone ? TimeZone.current : TimeZone(abbreviation: "UTC")
        return dateFormatter.string(from: self)
    }
    
    func aa_toString(fromFormat: AADateFormatters, currentTimeZone: Bool) -> String {
        return aa_toString(fromFormat: fromFormat.rawValue, currentTimeZone: currentTimeZone)
    }
    
    func aa_timeAgo(numericDates: Bool) -> String {
        let calendar = Calendar.current
        let now = Date()
        let earliest = self < now ? self : now
        let latest =  self > now ? self : now
        
        let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfMonth, .month, .year, .second]
        let components: DateComponents = calendar.dateComponents(unitFlags, from: earliest, to: latest)
        
        let year = components.year ?? 0
        let month = components.month ?? 0
        let weekOfMonth = components.weekOfMonth ?? 0
        let day = components.day ?? 0
        let hour = components.hour ?? 0
        let minute = components.minute ?? 0
        let second = components.second ?? 0
        
        let agoString = "ago".aa_localized
        let yearsString = "years".aa_localized
        let yearString = "year".aa_localized
        let lastString = "Last".aa_localized
        let monthsSrting = "months".aa_localized
        let monthString = "month".aa_localized
        let weeksString = "weeks".aa_localized
        let weekString = "week".aa_localized
        let daysString = "days".aa_localized
        let dayString = "day".aa_localized
        let hoursString = "hours".aa_localized
        let hourString = "hour".aa_localized
        let minutesString = "minutes".aa_localized
        let minuteString = "minute".aa_localized
        let secondsString = "seconds".aa_localized
        let justNowString = "Just now".aa_localized
        let yesterdayString = "Yesterday".aa_localized
        let anString = "An".aa_localized
        let aString = "A".aa_localized
        let oneString = 1.aa_toLocalizedString()
        
        switch (year, month, weekOfMonth, day, hour, minute, second) {
        case (let year, _, _, _, _, _, _) where year >= 2:
            return "\(year.aa_toLocalizedString()) \(yearsString) \(agoString)"
        case (let year, _, _, _, _, _, _) where year == 1 && numericDates:
            return "\(oneString) \(yearString) \(agoString)"
        case (let year, _, _, _, _, _, _) where year == 1 && !numericDates:
            return "\(lastString) \(yearString)"
        case (_, let month, _, _, _, _, _) where month >= 2:
            return "\(month.aa_toLocalizedString()) \(monthsSrting) \(agoString)"
        case (_, let month, _, _, _, _, _) where month == 1 && numericDates:
            return "\(oneString) \(monthString) \(agoString)"
        case (_, let month, _, _, _, _, _) where month == 1 && !numericDates:
            return "\(lastString) \(monthString)"
        case (_, _, let weekOfMonth, _, _, _, _) where weekOfMonth >= 2:
            return "\(weekOfMonth.aa_toLocalizedString()) \(weeksString) \(agoString)"
        case (_, _, let weekOfMonth, _, _, _, _) where weekOfMonth == 1 && numericDates:
            return "\(oneString) \(weekString) \(agoString)"
        case (_, _, let weekOfMonth, _, _, _, _) where weekOfMonth == 1 && !numericDates:
            return "\(lastString) \(weekString)"
        case (_, _, _, let day, _, _, _) where day >= 2:
            return "\(day.aa_toLocalizedString()) \(daysString) \(agoString)"
        case (_, _, _, let day, _, _, _) where day == 1 && numericDates:
            return "\(oneString) \(dayString) \(agoString)"
        case (_, _, _, let day, _, _, _) where day == 1 && !numericDates:
            return yesterdayString
        case (_, _, _, _, let hour, _, _) where hour >= 2:
            return "\(hour.aa_toLocalizedString()) \(hoursString) \(agoString)"
        case (_, _, _, _, let hour, _, _) where hour == 1 && numericDates:
            return "\(oneString) \(hourString) \(agoString)"
        case (_, _, _, _, let hour, _, _) where hour == 1 && !numericDates:
            return "\(anString) \(hourString) \(agoString)"
        case (_, _, _, _, _, let minute, _) where minute >= 2:
            return "\(minute.aa_toLocalizedString()) \(minutesString) \(agoString)"
        case (_, _, _, _, _, let minute, _) where minute == 1 && numericDates:
            return "\(oneString) \(minuteString) \(agoString)"
        case (_, _, _, _, _, let minute, _) where minute == 1 && !numericDates:
            return "\(aString) \(minuteString) \(agoString)"
        case (_, _, _, _, _, _, let second) where second >= 3:
            return "\(second.aa_toLocalizedString()) \(secondsString) \(agoString)"
        default:
            return justNowString
        }
    }
}
