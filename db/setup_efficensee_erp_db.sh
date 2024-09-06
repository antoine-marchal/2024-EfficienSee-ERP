#!/bin/bash

# MongoDB connection string
# Modify this if your MongoDB server requires authentication or uses a different port
MONGO_URI="mongodb://localhost:27017"

# Database name
DB_NAME="EfficienSeeERP"

# Create the setup script
cat << EOF > setup_mongodb.js
// Switch to the EfficienSeeERP database
db = db.getSiblingDB('${DB_NAME}');

// Function to create a collection with schema validation
function createCollection(name, schema) {
  db.createCollection(name, {
    validator: {
      \$jsonSchema: schema
    },
    validationLevel: "strict",
    validationAction: "error"
  });
  print("Created collection: " + name);
}

// Define schemas and create collections
const schemas = {
  users: {
    bsonType: "object",
    required: ["username", "password", "roles"],
    properties: {
      _id: { bsonType: "objectId" },
      username: { bsonType: "string" },
      password: { bsonType: "string" },
      roles: { bsonType: "array", items: { bsonType: "string" } },
      createdAt: { bsonType: "date" },
      updatedAt: { bsonType: "date" }
    }
  },
  items: {
    bsonType: "object",
    required: ["name", "trackingType"],
    properties: {
      _id: { bsonType: "objectId" },
      name: { bsonType: "string" },
      description: { bsonType: "string" },
      trackingType: { enum: ["none", "lot", "serial"] },
      stockLevel: { bsonType: "number" },
      alternateIds: { bsonType: "array", items: { bsonType: "objectId" } },
      preferredItemId: { bsonType: ["objectId", "null"] },
      createdAt: { bsonType: "date" },
      updatedAt: { bsonType: "date" }
    }
  },
  alternateItems: {
    bsonType: "object",
    required: ["masterId", "alternateId"],
    properties: {
      _id: { bsonType: "objectId" },
      masterId: { bsonType: "objectId" },
      alternateId: { bsonType: "objectId" },
      createdAt: { bsonType: "date" },
      updatedAt: { bsonType: "date" }
    }
  },
  locations: {
    bsonType: "object",
    required: ["name", "type"],
    properties: {
      _id: { bsonType: "objectId" },
      name: { bsonType: "string" },
      type: { enum: ["regular", "asp"] },
      createdAt: { bsonType: "date" },
      updatedAt: { bsonType: "date" }
    }
  },
  stocks: {
    bsonType: "object",
    required: ["itemId", "locationId", "quantity"],
    properties: {
      _id: { bsonType: "objectId" },
      itemId: { bsonType: "objectId" },
      locationId: { bsonType: "objectId" },
      quantity: { bsonType: "number" },
      lotNumber: { bsonType: ["string", "null"] },
      serialNumber: { bsonType: ["string", "null"] },
      createdAt: { bsonType: "date" },
      updatedAt: { bsonType: "date" }
    }
  },
  productionOrders: {
    bsonType: "object",
    required: ["targetItemId", "quantity", "status"],
    properties: {
      _id: { bsonType: "objectId" },
      targetItemId: { bsonType: "objectId" },
      quantity: { bsonType: "number" },
      status: { enum: ["draft", "released", "in_progress", "completed", "cancelled"] },
      startDate: { bsonType: "date" },
      endDate: { bsonType: "date" },
      createdAt: { bsonType: "date" },
      updatedAt: { bsonType: "date" }
    }
  },
  productionOrderComponents: {
    bsonType: "object",
    required: ["productionOrderId", "itemId", "requiredQuantity"],
    properties: {
      _id: { bsonType: "objectId" },
      productionOrderId: { bsonType: "objectId" },
      itemId: { bsonType: "objectId" },
      requiredQuantity: { bsonType: "number" },
      createdAt: { bsonType: "date" },
      updatedAt: { bsonType: "date" }
    }
  },
  purchaseRequests: {
    bsonType: "object",
    required: ["itemId", "quantity", "status"],
    properties: {
      _id: { bsonType: "objectId" },
      itemId: { bsonType: "objectId" },
      quantity: { bsonType: "number" },
      status: { enum: ["draft", "approved", "rejected", "completed"] },
      requiredDate: { bsonType: "date" },
      createdAt: { bsonType: "date" },
      updatedAt: { bsonType: "date" }
    }
  },
  purchaseOrders: {
    bsonType: "object",
    required: ["supplierName", "status"],
    properties: {
      _id: { bsonType: "objectId" },
      supplierName: { bsonType: "string" },
      status: { enum: ["draft", "sent", "partially_received", "completed", "cancelled"] },
      orderDate: { bsonType: "date" },
      expectedDeliveryDate: { bsonType: "date" },
      createdAt: { bsonType: "date" },
      updatedAt: { bsonType: "date" }
    }
  },
  purchaseOrderItems: {
    bsonType: "object",
    required: ["purchaseOrderId", "itemId", "quantity", "unitPrice"],
    properties: {
      _id: { bsonType: "objectId" },
      purchaseOrderId: { bsonType: "objectId" },
      itemId: { bsonType: "objectId" },
      quantity: { bsonType: "number" },
      unitPrice: { bsonType: "number" },
      createdAt: { bsonType: "date" },
      updatedAt: { bsonType: "date" }
    }
  },
  configurations: {
    bsonType: "object",
    required: ["name", "serialNumber", "itemId"],
    properties: {
      _id: { bsonType: "objectId" },
      name: { bsonType: "string" },
      serialNumber: { bsonType: "string" },
      itemId: { bsonType: "objectId" },
      createdAt: { bsonType: "date" },
      updatedAt: { bsonType: "date" }
    }
  },
  configurationComponents: {
    bsonType: "object",
    required: ["configurationId", "itemId", "pointDEmploi"],
    properties: {
      _id: { bsonType: "objectId" },
      configurationId: { bsonType: "objectId" },
      itemId: { bsonType: "objectId" },
      serialNumber: { bsonType: ["string", "null"] },
      pointDEmploi: { bsonType: "string" },
      createdAt: { bsonType: "date" },
      updatedAt: { bsonType: "date" }
    }
  },
  mrpResults: {
    bsonType: "object",
    required: ["itemId", "plannedOrderQuantity", "plannedOrderDate", "calculationDate"],
    properties: {
      _id: { bsonType: "objectId" },
      itemId: { bsonType: "objectId" },
      plannedOrderQuantity: { bsonType: "number" },
      plannedOrderDate: { bsonType: "date" },
      calculationDate: { bsonType: "date" },
      createdAt: { bsonType: "date" },
      updatedAt: { bsonType: "date" }
    }
  }
};

// Create collections with schema validation
Object.entries(schemas).forEach(([name, schema]) => {
  createCollection(name, schema);
});

print("Database setup completed successfully.");
EOF

# Run the MongoDB setup script
mongosh "${MONGO_URI}" --file setup_mongodb.js

# Clean up the temporary JavaScript file
rm setup_mongodb.js

echo "EfficienSee ERP database setup completed."