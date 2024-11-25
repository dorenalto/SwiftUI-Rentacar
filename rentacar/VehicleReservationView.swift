import SwiftUI

struct VehicleReservationView: View {
    @ObservedObject var viewModel = VehicleReservationViewModel()
    
    @State private var selectedVehicle: Vehicle?
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Date().addingTimeInterval(86400)
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Reserve um Veículo")
                    .font(.title)
                    .padding()
                
                // Lista de veículos disponíveis
                List(viewModel.availableVehicles, id: \.id) { vehicle in
                    HStack {
                        Text(vehicle.name)
                        Spacer()
                        Text(vehicle.model)
                            .foregroundColor(.gray)
                    }
                    .onTapGesture {
                        selectedVehicle = vehicle
                    }
                }
                .onAppear {
                    viewModel.fetchAvailableVehicles()
                }
                
                if let selectedVehicle = selectedVehicle {
                    VStack {
                        DatePicker("Data de Início", selection: $startDate, displayedComponents: .date)
                            .padding()
                        DatePicker("Data de Término", selection: $endDate, displayedComponents: .date)
                            .padding()
                        
                        Button(action: {
                            viewModel.reserveVehicle(vehicle: selectedVehicle, startDate: startDate, endDate: endDate)
                        }) {
                            Text("Reservar Veículo")
                                .font(.headline)
                                .padding()
                                .foregroundColor(.white)
                                .background(Color.blue)
                                .cornerRadius(8)
                        }
                        .padding()
                    }
                }
                
                // Mensagens de erro ou sucesso
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
                if let reservation = viewModel.reservation {
                    Text("Reserva Confirmada: \(reservation.vehicle.name) de \(formatDate(reservation.startDate)) a \(formatDate(reservation.endDate))")
                        .foregroundColor(.green)
                        .padding()
                }
                
                Spacer()
            }
            .navigationTitle("Reservas")
        }
    }
    
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        VehicleReservationView()
    }
}
