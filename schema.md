## profiles/{uid}

-displayName: firstName + " " + lastName
-photoUrl?: string
-createdAt: timestamp
-homeBranchId?: string
-favoriteChains?: string[]
-role: user | store | admin
-trustScore?: number
-prefs?: { currency?: "PHP", units?: "metric" }
-email?: string
-phone?: string
-emailVerified: boolean
-phoneVerified: boolean
-firstName?: string
-lastName?: string
-dateOfBirth?: number
-occupation?: string
-verifiedAt?: { email?: timestamp, phone?: timestamp }
-tier: "explorer" | "contributor" | "trusted_scout" | "expert_contributor" | "admin"
-tierMetrics: {
totalContributions: number,
flaggedReports: number,
}
-badges: string[] 
-stats: {
priceLogsCount: number,
productsAdded: number,
}

## users/{uid}/lists/{listId}

-type: "shopping" | "watch"
-name?: string
-createdAt: timestamp
-branchId?: string

## users/{uid}/lists/{listId}/items/{itemId}

-productId: string
-qty: number
-notes?: string
-targetBranchId?: string
-estimatedPrice?: number
-purchased?: boolean
-purchasedAt?: { branchId: string, price: number, timestamp: timestamp }
-alertSettings?: {
priceDropPercent?: number,
targetPrice?: number,
newStoreAlert?: boolean,
saleAlert?: boolean
}

## organizations/{orgId}

-name: string
-aka?: string[]
-country: string
-status: "active" | "inactive"
-website?: string
-createdAt: timestamp

## chains/{chainId}

-orgId: string
-name: string
-shortName?: string
-format: "convenience_small" | "supermarket_small" | "supermarket" | "hypermarket" | "
warehouse_club"
-valueTier?: "value" | "mainstream" | "premium"
-status: "active" | "inactive"

## branches/{branchId}

-orgId: string
-chainId: string
-name: string
-branchCode?: string
-address: { line1?: string, city?: string, region?: string, postcode?: string, country: string }
-geo: { lat: number, lng: number, geohash: string }
-openingHours: {
"mon": [ { "open": "09:00", "close": "21:00" } ],
"tue": [ { "open": "09:00", "close": "21:00" } ],
"wed": [ { "open": "09:00", "close": "21:00" } ],
"thu": [ { "open": "09:00", "close": "21:00" } ],
"fri": [ { "open": "09:00", "close": "22:00" } ],
"sat": [ { "open": "09:00", "close": "22:00" } ],
"sun": [ { "open": "10:00", "close": "21:00" } ]
}
-phone?: string | null
-status: "active" | "temp_closed" | "permanently_closed"

## products/{productId}

-name: string
-brand?: string
-status: "active" | "discontinued"
-createdAt: timestamp
-updatedAt?: timestamp
-nameLower: string // lowercase(name)
-size?: { qty: number, unit: "g" | "kg" | "ml" | "L" | "pc" }
-ppuBase?: { qty: number, unit: "g" | "ml" } // for unit price calcs (e.g., per 100 g/ml)
-barcodes?: string[]
-category?: string
-taxonomy?: { taxonomyId: string, departmentId: string, aisleId?: string }
-attributes?: { [k: string]: string | number | boolean }
-isFood?: boolean
-nutrition?: {
source?: "OFF" | "label" | "user" | "none",
confidence?: number, // 0..1
flags?: string[], // e.g., ["nutrition_inconsistent"]
perServing?: {
calories?: number,
total_fat?: number, // g
saturated_fat?: number, // g
trans_fat?: number, // g
cholesterol?: number, // mg
sodium?: number, // mg
total_carbohydrate?: number, // g
dietary_fiber?: number, // g
total_sugars?: number, // g
added_sugars?: number, // g
protein?: number, // g
vitamin_d?: number, // mcg
calcium?: number, // mg
iron?: number, // mg
potassium?: number, // mg
vitamin_a?: number, // mcg RAE
vitamin_c?: number, // mg
vitamin_e?: number, // mg
vitamin_k?: number, // mcg
thiamin?: number, // mg
riboflavin?: number, // mg
niacin?: number, // mg
vitamin_b6?: number, // mg
folate?: number, // mcg DFE
vitamin_b12?: number, // mcg
biotin?: number, // mcg
pantothenic_acid?: number, // mg
phosphorus?: number, // mg
iodine?: number, // mcg
magnesium?: number, // mg
zinc?: number, // mg
selenium?: number, // mcg
copper?: number, // mg
manganese?: number, // mg
chromium?: number, // mcg
molybdenum?: number, // mcg
monounsaturated_fat?: number, // g
polyunsaturated_fat?: number, // g
omega_3?: number, // g
omega_6?: number // g
},
declared?: {
servingSize?: { qty: number, unit: "g" | "ml" | "pieces" | "tbsp" | "cup" },
servingsPerPackage?: number, // decimals allowed
notes?: string // "about 3", "drained weight", etc.
},
per100g?: {
calories?: number,
protein?: number,
fat?: number,
carbs?: number,
sugars?: number,
sodium?: number
},
derived?: {
servingsPerPackage?: number, // computed decimal from size/serving
perPackage?: {
calories?: number,
protein?: number,
fat?: number,
carbs?: number,
sugars?: number,
sodium?: number
}
}
}
-images?: [{ url: string, type?: string }] // e.g., "front", "nutrition", "ingredients"
-overrides?: { name?: string, size?: { qty: number, unit: string }, brand?: string }
-approvalStatus: "pending" | "approved" | "rejected"
-submittedBy?: string
-reviewedBy?: string
-reviewedAt?: timestamp
-completionScore: number
-priorityForCompletion?: {
isPriority: boolean,
bounty: number,
missingFields: string[],
markedAt: timestamp
}

## barcodeIndex/{code}

-productId: string
-type: "ean" | "upc" | "gtin14" | "internal"
-normalized: string // zero-padded, stripped of spaces
-source: "off" | "manual" | "import"
-createdAt: timestamp

## listings/{listingId}

-productId: string
-branchId: string
-chainId: string
-orgId: string
-status: "active" | "oos" | "discontinued" | "unknown"
-lastSeenAt?: timestamp
-branchSku?: string
-departmentId?: string
-aisleId?: string
-notes?: string
-cheapestPrice?: number
-cheapestSeenAt?: timestamp
-updatedAt?: timestamp
-priorityStatus: {
isPriority: boolean,
priorityScore: number,
bounty: number,
markedAt: timestamp,
expiresAt: timestamp
}
-lastPriceUpdate: timestamp

## priorityQueue/{queueId}

-listingId: string
-productName: string
-branchName: string
-bounty: number
-createdAt: timestamp
-claimedBy?: string
-completedAt?: timestamp

## priceLogs/{logId}

-productId: string
-branchId: string
-chainId: string
-orgId: string
-price: number
-currency: "PHP"
-unitPrice?: number
-size?: { qty: number, unit: "g" | "kg" | "ml" | "L" | "pc" }
-source: "user" | "scrape" | "admin"
-userId: string
-createdAt: timestamp
-trustTier: 0 | 1 | 2
-flags?: string[]
-saleEndsAt?: timestamp

## groceryRuns/{runId}

-userId: string
-startedAt: timestamp
-endedAt?: timestamp | null
-branchId?: string
-isActive: boolean
-items: [{
productId: string,
qty: number,
scannedPrice?: number,
priceLogId?: string
}]

## taxonomy/{taxonomyId}

-name: string
-version: number
-default?: boolean
-createdAt: timestamp

## taxonomy/{taxonomyId}/departments/{departmentId}

-name: string
-slug: string
-sortOrder?: number

## taxonomy/{taxonomyId}/departments/{departmentId}/aisles/{aisleId}

-name: string
-slug: string
-sortOrder?: number

## feedbackReports/{reportId}

-userId?: string
-type: "bug" | "suggestion" | "price_error" | "product_issue" | "general"
-title: string
-description: string
-priority: "low" | "medium" | "high" | "critical"
-status: "open" | "in_progress" | "resolved" | "closed"
-createdAt: timestamp
-resolvedAt?: timestamp
-adminNotes?: string
-metadata?: { version: string, device: string, screenshots?: string[] }

## notifications/{notificationId}

-userId: string
-type: "price_alert" | "new_sale" | "tier_promotion" | "general"
-title: string
-body: string
-read: boolean
-createdAt: timestamp
-data?: { productId?: string, branchId?: string }

## appContent/{docId}

-type: "faq" | "announcement" | "tutorial" | "terms" | "privacy"
-title: string
-content: string
-published: boolean
-createdAt: timestamp
-updatedAt: timestamp
-order?: number

## reports/{reportId}

-reporterId: string
-targetType: "product" | "price_log" | "user"
-targetId: string
-reason: "incorrect_info" | "spam" | "inappropriate" | "duplicate"
-description?: string
-status: "pending" | "reviewed" | "resolved"
-createdAt: timestamp

## moderationQueue/{queueId}

-type: "product_approval" | "user_report" | "price_validation"
-targetId: string
-priority: number
-assignedTo?: string
-createdAt: timestamp

## schemaMeta/{docId}

-version: number
-notes?: string
-createdAt?: timestamp

1. barcodeIndex lookup
   └─> If exists: fetch product from products collection
   └─> If not: call Open Food Facts API

2. Product creation (pending status)
   └─> Parse OFF response
   └─> Create product doc with basic fields
   └─> Create barcodeIndex entry
   └─> Return to user

3. Simple product display
   └─> Show product name, brand, size
   └─> Show "pending approval" badge
4. Branch selection/creation
   └─> Search existing branches
   └─> Allow simple branch creation

5. Price log creation
   └─> Create priceLog doc
   └─> Create/update listing doc
   └─> Update user stats

6. Basic user profile
   └─> Track contributions
   └─> Simple tier system (start with everyone as "explorer")
7. Product approval workflow
   └─> Admin can approve/reject pending products
   └─> Merge duplicate products

8. Basic price history
   └─> Show recent prices for product at branch
   └─> Simple price trends