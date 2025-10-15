# QBox Delivery Job

A simple delivery job system for QBox Framework. Pick up packages and deliver them around the city.

## Features
- Pick up boxes from warehouses
- Deliver to various locations with NPCs
- Two-handed carrying animations
- Dynamic ped spawning at delivery locations
- Payment system

## Installation
1. Add to `server.cfg`: `ensure string_deliveryjob`
2. Restart server

## Dependencies
- qbx_core
- ox_lib
- ox_target
- oxmysql

## Usage
1. Go to warehouse locations to pick up boxes
2. Carry boxes to your van 
3. Drive to delivery locations
4. Deliver boxes to NPCs for payment

## Configuration
Edit `config.lua` to customize:
- Delivery locations
- Payment amounts  
- Box models
- Ped models and scenarios