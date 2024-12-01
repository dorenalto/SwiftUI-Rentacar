import SwiftUI

struct VehicleReservationView: View {
    @ObservedObject var viewModel = VehicleReservationViewModel()
    
    @State private var selectedVehicle: Vehicle?
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Date().addingTimeInterval(86400)
    
    var body: some View {
        NavigationView {
            VStack {
                Text(LocalizedStrings.reserveVehicleTitle)
                    .font(.title)
                    .padding()
                
                // Lista de veículos disponíveis
                List(viewModel.availableVehicles, id: \.id) { vehicle in
                    HStack {
                        Text(vehicle.name)
                        Spacer()
                        Text(vehicle.model)
                            .foregroundStyle(.gray)
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
                        DatePicker(LocalizedStrings.startDateLabel, selection: $startDate, displayedComponents: .date)
                            .padding()
                        DatePicker(LocalizedStrings.endDateLabel, selection: $endDate, displayedComponents: .date)
                            .padding()
                        
                        Button(action: {
                            viewModel.reserveVehicle(vehicle: selectedVehicle, startDate: startDate, endDate: endDate)
                        }) {
                            Text(LocalizedStrings.reserveButtonTitle)
                                .font(.headline)
                                .padding()
                                .foregroundStyle(.white)
                                .background(Color.primaryBlue)
                                .cornerRadius(8)
                        }
                        .padding()
                    }
                }
                
                // Mensagens de erro ou sucesso
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundStyle(.errorRed)
                        .padding()
                }
                if let reservation = viewModel.reservation {
                    Text(LocalizedStrings.reservationSuccess + "\(reservation.vehicle.name) de \(formatDate(reservation.startDate)) a \(formatDate(reservation.endDate))")
                        .foregroundStyle(.successGreen)
                        .padding()
                }
                
                Spacer()
            }
            .navigationTitle(LocalizedStrings.reserveVehicleTitle)
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
