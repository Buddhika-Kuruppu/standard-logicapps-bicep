# standard-logicapps-bicep

Standard Logic Apps Bicep Deployment
This repository provides a Bicep-based template structure for deploying Azure Standard Logic Apps hosted on Azure App Service Environment v3 (ASEv3) across multiple environments.

🚀 Overview
Deploying Standard Logic Apps using Bicep enables infrastructure as code (IaC), allowing for consistent, repeatable, and automated deployments. Standard Logic Apps run on the Azure Functions runtime, offering:

Improved performance and scalability

Support for private networking (VNet integration)

Version control for workflows

🔐 Secure Storage Configuration (Critical for Production)
A key consideration in production environments is configuring the backing storage account used by Logic Apps. To ensure secure and reliable operation within isolated networks, you must configure four private endpoints for the storage account.

✅ Why This Matters
Logic Apps store their workflow artifacts—definitions, runtime state, and metadata—in a connected Azure Storage Account. When running in a VNet-integrated or private environment, public access is restricted, and private endpoints are required for connectivity.
If any endpoint is missing or misconfigured, workflow execution may fail due to access issues.

🧩 Required Private Endpoints

| Service | Purpose                                              |
|---------|------------------------------------------------------|
| Blob    | Stores workflow definitions, artifacts, and metadata |
| File    | Mounts shared files required during execution        |
| Queue   | Handles internal messaging and trigger management    |
| Table   | Maintains workflow state and tracking data           |


⚠️ Important Configuration Notes
All four private endpoints must be created within the same Virtual Network (VNet) that your Logic App is integrated with.

Use Azure Private DNS Zones to resolve private endpoint hostnames (e.g., privatelink.blob.core.windows.net).

Ensure appropriate access permissions are granted via RBAC roles or SAS tokens for the Logic App to access storage services.


