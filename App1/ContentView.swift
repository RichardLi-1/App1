import SwiftUI

struct ContentView: View {
    @State private var display = "0"
    @State private var currentNumber = ""
    @State private var previousNumber = ""
    @State private var operation: CalculatorOperation?

    var body: some View {
        VStack {
            Spacer()
            Text(display)
                .font(.largeTitle)
                .padding()
                .frame(maxWidth: .infinity, alignment: .trailing)
            
            ForEach(CalculatorButton.allCases, id: \.self) { row in
                HStack {
                    ForEach(row, id: \.self) { button in
                        Button(action: {
                            self.buttonTapped(button)
                        }) {
                            Text(button.title)
                                .font(.largeTitle)
                                .frame(width: self.buttonWidth(button: button), height: self.buttonHeight())
                                .background(button.backgroundColor)
                                .foregroundColor(.white)
                                .cornerRadius(self.buttonWidth(button: button) / 2)
                        }
                    }
                }
            }
        }
        .padding()
    }

    private func buttonTapped(_ button: CalculatorButton) {
        switch button {
        case .digit(let number):
            handleDigit(number)
        case .operation(let operation):
            handleOperation(operation)
        case .equals:
            handleEquals()
        case .clear:
            handleClear()
        case .decimal:
            handleDecimal()
        }
    }

    private func handleDigit(_ number: String) {
        if currentNumber == "0" {
            currentNumber = number
        } else {
            currentNumber += number
        }
        display = currentNumber
    }

    private func handleOperation(_ operation: CalculatorOperation) {
        if let op = self.operation, let previous = Double(previousNumber), let current = Double(currentNumber) {
            let result = performOperation(op, previous, current)
            display = formatResult(result)
            previousNumber = "\(result)"
        } else {
            previousNumber = currentNumber
        }
        currentNumber = ""
        self.operation = operation
    }

    private func handleEquals() {
        if let op = operation, let previous = Double(previousNumber), let current = Double(currentNumber) {
            let result = performOperation(op, previous, current)
            display = formatResult(result)
            previousNumber = "\(result)"
            currentNumber = ""
            operation = nil
        }
    }

    private func handleClear() {
        display = "0"
        currentNumber = ""
        previousNumber = ""
        operation = nil
    }

    private func handleDecimal() {
        if !currentNumber.contains(".") {
            currentNumber += "."
        }
        display = currentNumber
    }

    private func performOperation(_ operation: CalculatorOperation, _ a: Double, _ b: Double) -> Double {
        switch operation {
        case .add:
            return a + b
        case .subtract:
            return a - b
        case .multiply:
            return a * b
        case .divide:
            return a / b
        }
    }

    private func formatResult(_ result: Double) -> String {
        return String(format: "%g", result)
    }

    private func buttonWidth(button: CalculatorButton) -> CGFloat {
        if button == .digit("0") {
            return (UIScreen.main.bounds.width - 5 * 10) / 2
        }
        return (UIScreen.main.bounds.width - 5 * 10) / 4
    }

    private func buttonHeight() -> CGFloat {
        return (UIScreen.main.bounds.width - 5 * 10) / 4
    }
}

enum CalculatorOperation {
    case add, subtract, multiply, divide
}

enum CalculatorButton: Hashable {
    case digit(String)
    case operation(CalculatorOperation)
    case equals
    case clear
    case decimal

    var title: String {
        switch self {
        case .digit(let number):
            return number
        case .operation(let operation):
            switch operation {
            case .add:
                return "+"
            case .subtract:
                return "-"
            case .multiply:
                return "×"
            case .divide:
                return "÷"
            }
        case .equals:
            return "="
        case .clear:
            return "C"
        case .decimal:
            return "."
        }
    }

    var backgroundColor: Color {
        switch self {
        case .digit:
            return .gray
        case .operation:
            return .orange
        case .equals, .clear, .decimal:
            return .blue
        }
    }

    static var allCases: [[CalculatorButton]] {
        return [
            [.clear, .operation(.divide), .operation(.multiply), .operation(.subtract)],
            [.digit("7"), .digit("8"), .digit("9"), .operation(.add)],
            [.digit("4"), .digit("5"), .digit("6"), .equals],
            [.digit("1"), .digit("2"), .digit("3"), .decimal],
            [.digit("0"), .digit("0")]
        ]
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
