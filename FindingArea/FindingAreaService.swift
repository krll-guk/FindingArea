import Foundation

protocol FindingAreaServiceProtocol {
    func areaOfCircle(withParameters r: Double) -> String
    func areaOfTriangle(withParameters a: Double, _ b: Double, _ c: Double) -> String
}

final class FindingAreaService: FindingAreaServiceProtocol {
    func areaOfCircle(withParameters r: Double) -> String {
        let S = Double.pi * pow(r, 2)
        let roundedValue = String(format: "%.2f", S)
        return roundedValue
    }

    func areaOfTriangle(withParameters a: Double, _ b: Double, _ c: Double) -> String {
        var S = Double()

        let powA = pow(a, 2)
        let powB = pow(b, 2)
        let powC = pow(c, 2)

        if powA + powB == powC {
            S = a * b / 2
        } else if powA + powC == powB {
            S = a * c / 2
        } else if powB + powC == powA {
            S = b * c / 2
        } else {
            let p = (a + b + c) / 2
            S = sqrt(p * (p - a) * (p - b) * (p - c))
        }

        let roundedValue = String(format: "%.2f", S)
        return roundedValue
    }
}
