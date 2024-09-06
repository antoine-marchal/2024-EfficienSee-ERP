# EfficienSee ERP Project

## Project Overview

EfficienSee is a comprehensive ERP (Enterprise Resource Planning) application that integrates MRP (Material Requirements Planning), WMS (Warehouse Management System), and various other modules to manage items, production, procurement, and configurations. The application will be built using Node.js, Express, Vite + React, TailwindCSS, and MongoDB, with a focus on modularity and role-based access control.

## Tech Stack

- Frontend: Vite, React, TailwindCSS
- Backend: Node.js, Express
- Database: MongoDB
- Development Environment: VS Code Web
- Version Control: GitHub
- Deployment: Docker

## Core Features

1. User Authentication and Role Management
2. Dashboard with module access
3. Item Management (lot, serial number)
4. Warehouse Management System (WMS)
5. Production Order Management
6. Procurement Management (Purchase Requests and Orders)
7. Configuration Management for serialized items
8. MRP Calculation

## Detailed Requirements

### User Management and Authentication

- Implement user registration and login system
- Role-based access control with the following roles:
  - Admin
  - Configuration Manager
  - Warehouse Admin
  - Warehouse Manager
  - Production Manager
  - Procurement Manager
  - Read-only

### Item Management

- CRUD operations for items
- Support for lot numbered, serialized, or non-tracked items
- Stock tracking across different locations

### Warehouse Management System (WMS)

- CRUD operations for warehouse locations
- Stock movement between locations
- ASP (Aire de Stockage Provisoire) management
- Automatic stock transfer to ASP when deleting a location with items

### Production Order Management

- CRUD operations for production orders
- Link production orders to target items and required components
- Implement production order release process
- Manage item consumption and production in ASP
- Update stock levels upon production order completion

### Procurement Management

- CRUD operations for Purchase Requests (PR) and Purchase Orders (PO)
- PO consumption process
- Lot/Serial number assignment during PO consumption
- Stock update in ASP upon PO consumption

### Configuration Management

- CRUD operations for item configurations
- Manage "points d'emploi" for serialized items
- Track serialized item installations within other serialized items
- Update stock levels when items are installed in configurations

### MRP Calculation

- Implement daily automated MRP calculation
- Provide manual trigger option for MRP calculation
- Store MRP results in the database for each item

### Reporting and Analytics

- Generate reports for inventory, production, and procurement
- Implement dashboards for key performance indicators
