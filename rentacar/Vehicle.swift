//
//  Vehicle.swift
//  rentacar
//
//  Created by dorenalto mangueira couto on 24/11/24.
//


import Foundation

// Modelo de dados para o Veículo
struct Vehicle {
    let id: UUID
    let name: String
    let model: String
    let availableDates: [Date] // Lista de datas em que o veículo está disponível
}

// Modelo de dados para a Reserva
struct Reservation {
    let vehicle: Vehicle
    let startDate: Date
    let endDate: Date
}
