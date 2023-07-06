# Azure VMware Solution Well-Architected Framework: Operational Excellence

This section aims to build out the operating model for the Azure VMware Solution and the applications inside the SDDC. 

## Management & Monitoring 

It's essential to know how the workload in the SDDC is doing. Similar to how you would monitor things such as CPU usage, OS logs, and security alerts, to name a few, these same elements are monitored in the SDDC. The key difference is that you can now leverage cloud-native plus existing VMware tools into your operating model. Tools include but are not limited to enabling VMware VROPs, installing Azure Monitor agents, and any third-party monitoring/reporting tool used today on-prem. 


The Azure VMware Solution also assists with OS-level metrics and telemetry collection for analysis. Monitoring OS extensions, guest management, patching, and upgrades is important.

Once logs are collected, it's important to have a centralized place for logging and analysis. Once data has been collected and analyzed, it's possible to triage and remediate anomalies. Analysis for security, performance benchmarks, and anomalies are then available for triage and alerting. This is often in terms of an automated ticket generation process for remediation or service restoration. 


## Operational Procedures 

### Alerting and Remediation 
Utilizing platform and workload data and proactively addressing escalations such as downtime, increased performance, and security alerts. 


### Disk Expansion 
Azure VMware solution makes it possible to expand the environment with minimal user input. If manually expanding the contract, it should be documented who will perform these activities and how to do it. AVS operators should ensure node reservation is available for growing the environment as needed. 

### Tagging and Patch management 

Tagging also for resource management by identifying workloads and infrastructure based on an organizational taxonomy (e.g host, business, owner, environment, etc.). The tagging strategy can then be applied for chargeback and resource tracking. These tags can be applied during provisioning. Leveraging infrastructure as code can create, update, and destroy guest VM and work alongside a configuration management tool 

### Disaster Recovery and Backup

Recognizing which workloads are critical to running the business is a central requirement for disaster preparation. Once a DR plan is in place, verified, and tested, this will create day-to-day procedures to be prepared in the event of a disaster. 

It's also important to have a list of follow-up activities and know who is assigned to them to mark a failure or recovery as complete. 

Backups need to be regularly verified and tested to be useful. This means completing in the time allotted, not being corrupted, and the data integrity and recovery process are valid. 

## Security and Governance

Assigning roles and responsibilities using the least privilege will ensure that more permissions are not given than needed and that the permissions are appropriate to the role assigned. Accounts and roles can map to a RACI. RBAC roles and JIT access to enforce the least privileged of roles and responsibilities

## Application Platform

It's important to not only have an understanding of the application dependencies, but how to provision and deploy.

