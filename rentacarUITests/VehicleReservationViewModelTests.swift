//
//  VehicleReservationViewModelTests.swift
//  rentacar
//
//  Created by dorenalto mangueira couto on 24/11/24.
//


import XCTest
@testable import rentacar

class VehicleReservationViewModelTests: XCTestCase {
    
    var viewModel: VehicleReservationViewModel?
    var vehicle: Vehicle?
    
    override func setUp() {
        super.setUp()
        viewModel = VehicleReservationViewModel()
        
        // Cria um veículo de exemplo
        vehicle = Vehicle(id: UUID(), name: "Carro A", model: "Modelo A", availableDates: [Date()])
    }
    
    override func tearDown() {
        viewModel = nil
        vehicle = nil
        super.tearDown()
    }
    
    func testReserveVehicle_Success() {
        // Testando reserva bem-sucedida
        guard let viewModel, let vehicle else { return }
        let startDate = Date()
        let endDate = startDate.addingTimeInterval(86400) // Um dia depois
        
        viewModel.reserveVehicle(vehicle: vehicle, startDate: startDate, endDate: endDate)
        
        XCTAssertNotNil(viewModel.reservation)
        XCTAssertEqual(viewModel.reservation?.vehicle.id, vehicle.id)
        XCTAssertNil(viewModel.errorMessage)
    }
    
    func testReserveVehicle_Error() {
        // Testando erro quando o veículo não está disponível
        guard let viewModel, let vehicle else { return }
        let startDate = Date().addingTimeInterval(86400) // Amanhã
        let endDate = startDate.addingTimeInterval(86400) // Dois dias depois
        
        viewModel.reserveVehicle(vehicle: vehicle, startDate: startDate, endDate: endDate)
        
        XCTAssertNil(viewModel.reservation)
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertEqual(viewModel.errorMessage, LocalizedStrings.errorVehicleNotAvailable)
    }
    
    func testReserveVehicle_InvalidVehicle() {
        // Testando quando o veículo não é encontrado
        guard let viewModel, let vehicle else { return }
        let invalidVehicle = Vehicle(id: UUID(), name: "Carro Inválido", model: "Modelo X", availableDates: [Date()])
        let startDate = Date()
        let endDate = startDate.addingTimeInterval(86400)
        
        viewModel.reserveVehicle(vehicle: invalidVehicle, startDate: startDate, endDate: endDate)
        
        XCTAssertNil(viewModel.reservation)
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertEqual(viewModel.errorMessage, LocalizedStrings.errorVehicleNotFound)
    }
}
