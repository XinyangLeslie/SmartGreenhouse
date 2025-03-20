//
//  ButtonViewModel.swift
//  XinyangTestApp
//
//  Created by 张新杨 on 2025/3/15.
//

import Foundation

class ButtonViewModel: ObservableObject {
    @Published var isWaterPumpOn = false
    @Published var isFanOn = false
    @Published var isLedOn = false

    private let baseURL = "http://\(Config.serverIP):5001"

    func fetchDeviceStates() {
        fetchStatus(for: "servo") { self.isWaterPumpOn = $0 }
        fetchStatus(for: "fan") { self.isFanOn = $0 }
        fetchStatus(for: "led") { self.isLedOn = $0 }
    }

    private func fetchStatus(for device: String, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "\(baseURL)/api/get-\(device)") else { return }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            DispatchQueue.main.async {
                if let data = data,
                   let result = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let success = result["success"] as? Bool, success,
                   let data = result["data"] as? [String: Bool],
                   let isOn = data["is_on"] {
                    completion(isOn)
                }
            }
        }.resume()
    }

    func toggleDevice(device: String, isOn: Bool) {
        guard let url = URL(string: "\(baseURL)/api/set-\(device)") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = ["status": isOn]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { _, _, _ in
            DispatchQueue.main.async {
                switch device {
                case "servo":
                    self.isWaterPumpOn = isOn
                case "fan":
                    self.isFanOn = isOn
                case "led":
                    self.isLedOn = isOn
                default:
                    break
                }
            }
        }.resume()
    }
}

