import Foundation

class VehicleReservationViewModel: ObservableObject {
    
    @Published var availableVehicles: [Vehicle] = []
    @Published var reservation: Reservation? = nil
    @Published var errorMessage: String? = nil
    
    // Simulação de veículos disponíveis
    private func loadAvailableVehicles() {
        let vehicle1 = Vehicle(id: UUID(), name: "Carro A", model: "Modelo A", availableDates: generateAvailableDates(for: Date()))
        let vehicle2 = Vehicle(id: UUID(), name: "Carro B", model: "Modelo B", availableDates: generateAvailableDates(for: Date().addingTimeInterval(86400))) // disponível amanhã
        
        availableVehicles = [vehicle1, vehicle2]
    }
    
    // Função para gerar datas disponíveis (simulação)
    private func generateAvailableDates(for baseDate: Date) -> [Date] {
        return [baseDate, baseDate.addingTimeInterval(86400), baseDate.addingTimeInterval(172800)] // Disponível hoje, amanhã e depois
    }
    
    // Função de reserva
    func reserveVehicle(vehicle: Vehicle, startDate: Date, endDate: Date) {
        guard let _ = availableVehicles.first(where: { $0.id == vehicle.id }) else {
            errorMessage = "Veículo não encontrado."
            return
        }
        
        // Verificar se o veículo está disponível
        if vehicle.availableDates.contains(where: { $0 >= startDate && $0 <= endDate }) {
            reservation = Reservation(vehicle: vehicle, startDate: startDate, endDate: endDate)
            errorMessage = nil
        } else {
            errorMessage = "Veículo não disponível nas datas selecionadas."
        }
    }
    
    // Função para iniciar o carregamento de veículos
    func fetchAvailableVehicles() {
        loadAvailableVehicles()
    }
}
