import Foundation


struct DeliveryTimeIntervalHelper {

    // Возвращает массив с диапазонами времени
    static func setupTimeInterval() -> [String] {
        let startFirstInterval = 45 // Когда начало самой быстрой доставки (через 45 мин)
        let startSecondInterval = 60 // Когда начало второго интервала (через 45 мин)
        let deliveryDiapason = 45 // Длительность доставки

        var result: [String] = ["Побыстрее", "Другое время"]

        let now = Date()
        let calendar = Calendar.current
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"

        let firstIntervalToAdd = createTimeInterval(startInterval: startFirstInterval, deliveryDiapason: deliveryDiapason, calendar: calendar, now: now, formatter: formatter)
        let secondIntervalToAdd = createTimeInterval(startInterval: startSecondInterval, deliveryDiapason: deliveryDiapason, calendar: calendar, now: now, formatter: formatter)

        result.insert(firstIntervalToAdd, at: 1)
        result.insert(secondIntervalToAdd, at: 2)

        return result
    }

    // Вспомогательный метод, который выдает диапазон
    static private func createTimeInterval(startInterval: Int, deliveryDiapason: Int, calendar: Calendar, now: Date, formatter: DateFormatter) -> String {
        guard let startTime = calendar.date(byAdding: .minute, value: startInterval, to: now),
              let endTime = calendar.date(byAdding: .minute, value: startInterval+deliveryDiapason, to: now) else {
            print("We can't create date"); return ""}

        let start = formatter.string(from: startTime)
        let end = formatter.string(from: endTime)

        return "\(start) - \(end)"
    }
}

