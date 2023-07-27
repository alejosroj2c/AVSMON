# Monitoring considerations for Azure VMware workloads 

This design area focuses on observability best practices for a VMware workload. The guidance is intended for the operations team. A combination of tools provided by Microsoft, VMware, and third parties can be used to monitor the infrastructure and the application. This article lists those options. 

Each option offers monitoring solutions with varying degrees of licensing costs, integration options, monitoring scope, and support. Carefully review the terms and conditions before using the tools. 

## Collect infrastructure data 
#### Impact: _Operational excellence_

Monitoring the workload involves collecting data from various VMware components and Azure VMware Solution (AVS) infrastructure. Azure VMware Solution (AVS) is integrated with VMware Software-Defined Data Center (SDDC) that runs several VMware native components. vRealize Operations is a suite of tools for managing various aspects of the infrastructure, such as vRealize Network and vRealize Health.  

vRealize Health Status for Azure VMware Solution helps ensure proactive issue detection and remediation are continually performed in the AVS environment, such as finding misconfiguration in the vSphere infrastructure or detecting performance bottlenecks. The solution also provides insight into resource utilization and overall environmental health performance.

vRealize Network Insight enables organizations to achieve comprehensive network visibility, streamline troubleshooting processes, and optimize network performance. 


### Recommendations 

- Configure  [vSphere Health Status](https://docs.vmware.com/en/VMware-vSphere/7.0/com.vmware.vsphere.monitoring.doc/GUID-F957C1BB-A032-4648-9310-68A94733ABC8.html)  to get a high-level overview of Azure VMware Solution SDDC's health status.
- Use  [vRealize Network Insight](https://docs.vmware.com/en/VMware-vRealize-Network-Insight/6.2/com.vmware.vrni.using.doc/GUID-3A09A9F1-23FE-44C5-A1F0-DB1932BB8E45.html) for enhanced visibility and analytics of Azure VMware Solution SDDC's network infrastructure.


#### Assessment question 

What tools are used to monitor your Azure VMware Solution Private Cloud and clusters? 

### Log Management and Archival Strategies

You'll need logs collected by VMware Syslog to get health data from the VMware system components, such as ESXi, vSAN, NSX-T, vCenter, and others. These logs are available through Azure VMware Solution (AVS) infrastructure. Azure Log Analytics agent/extension sends guest VM-level logs to Azure Log Analytics. Within AVS, you can send the AVS logs to the Azure Native storage blob. Sending logs to a storage blob is possible by setting up forwarders from a centralized Syslog server or as a destination from Azure Monitor. It's also possible to use an Azure Native tool such as Azure Logic Apps or Azure Functions to create listeners for incoming logs from AVS and send them to the storage blobs as the destination. 

Archival of logs is a strategy for keeping your storage costs down. Azure Storage Blobs and Azure Log Analytics can send logs for long-term archival. While storage blobs are cheaper, Log Analytics has more advanced integrations for alerting, visualization, querying, and machine learning-based insights. Consider your budget, functional, and long-term use cases to decide on each solution. 

### Recommendations

- Collect **VMware Syslogs** to get health data from the VMware system components, such as ESXi, vSAN, NSX-T, and vCenter.
- Configure tools such as [Azure Log Analytics](https://review.learn.microsoft.com/en-us/azure/azure-vmware/configure-vmware-syslogs) to collect those logs for querying, analyzing, and reporting capabilities.
- Configure retention durations for sending logs to log term storage to reduce query time and save on storage costs. 
  
#### Assessment question 

Is there a defined approach for managing the lifecycle of logs, including specific retention durations?

### Monitoring the Guest Operating System

Within the Guest Operating System are metrics around disk usage, application performance, system resource utilization, and user activity.  Consider using Azure Arc for Azure VMware Solution (Preview). For more information, visit [Deploy ARC for Azure VMware Solution](https://review.learn.microsoft.com/en-us/azure/azure-vmware/deploy-arc-for-azure-vmware-solution)

#### Recommendations

- Enable guest management and install Azure extensions once the private cloud with Azure ARC
- Install additional agents to collect data to enable guest management and monitoring on AVS guest VMs.  


#### Assessment Question
 - Are there tools for alerting and remediating stale patches, OS versions, and software configurations? 

## Security monitoring
#### Impact: _Security, Operational excellence_

Security monitoring is critical to detect and respond to anomalous activities. Workloads running in Azure VMware Solution (AVS) SDDC need comprehensive security monitoring spanning networks, Azure resources, and the Azure VMware Solution (AVS) SDDC itself. You can centralize security events by deploying Microsoft Sentinel workspace.  With this integration, the operation team can view, analyze, and detect security incidents in the context of a broader organizational threat landscape.  

### Recommendations 

- Enable [Azure Defender for Cloud](https://review.learn.microsoft.com/en-us/azure/defender-for-cloud/get-started) on the Azure subscription for deploying Azure VMware Solution SDDC, ensuring the defender plan has "Cloud Workload Protection (CWP)" ON for Servers. 

- Audit activities by privileged users on Azure VMware Solution SDDC. For more information, see: https://review.learn.microsoft.com/en-us/azure/active-directory/privileged-identity-management/groups-audit 

  - Integrate Sentinel with Defender for Cloud  and Enable its data collector for security events and connect it with Microsoft Defender for Cloud. For more information, see these articles: 

  - Use security monitoring solutions from pre-validated partners in Azure VMware Solution SDDC. 

### Assessment question 

- How are you monitoring security-related events in Azure VMware Solution? 

### Network Analysis

Network monitoring inspects all the traffic coming into and going out of Azure VMware Solution private cloud. Network security with AVS operates at both the network and host layers. 


### Recommendations

- Capture and monitor [Network Firewall](https://techcommunity.microsoft.com/t5/azure-migration-and/firewall-integration-in-azure-vmware-solution/ba-p/2254961) logs deployed in Azure VMware Solution SDDC or Azure where the application extends to Azure native devices such as Azure Firewall or Azure App Gateway.
- Use [Azure Firewall Workbook](https://review.learn.microsoft.com/en-us/azure/firewall/firewall-workbook) or similar tools to monitor common metrics and logs related to firewall devices.
- Correlate logs from multiple security vectors such as identity, networking, and infrastructure.


#### Assessment Questions
- How are you monitoring identity and networking events?


## Alerts and notifications 
#### Impact: _Operational Excellence_, _Cost optimization_ 

Configure alerts to notify the accountable teams when certain conditions are met. 

### Recommendations 

- Use [vSphere events and alarms subsystem](https://docs.vmware.com/en/VMware-vSphere/7.0/com.vmware.vsphere.monitoring.doc/GUID-9272E3B2-6A7F-427B-994C-B15FF8CADC25.html) for monitoring vSphere and setting up triggers. 

- Configure [Azure Alerts in Azure VMware Solution](https://review.learn.microsoft.com/en-us/azure/azure-vmware/configure-alerts-for-azure-vmware-solution#supported-metrics-and-activities) to respond to events in real-time. 

- Ensure that alerts are configured so that  [vSAN storage slack space](https://review.learn.microsoft.com/en-us/azure/azure-vmware/concepts-storage)  is maintained at the levels mandated by the SLA agreement. 

- Configure Resource Health alerts to get the real-time health status of Azure VMware Solution SDDC. 

Assessment question 

- How are platform and workload data obtained and mapped to thresholds to create alerts? 


## Cost Management 
#### Impact: _Cost Optimization, Operational Excellence_

Cost monitoring refers to the ability to keep track of costs associated with Azure VMware Solution private cloud.

### Recommendations
- Use the vSphere events and alarms subsystem to monitor vSphere and set up triggers.
- Configure Azure Alerts in Azure VMware Solution. Such alerts enable operation teams to respond to expected and unexpected events in real time.


#### Assessment Questions
Are there Azure budgets and alerts on costs? 

### Troubleshooting and Debugging

Efficient debugging and troubleshooting of the application necessitate logs, metrics, and associated information, such as event activities, to identify, analyze, and establish connections between events.

### Recommendations

- Configure Azure VMware Solution syslog forwarding to Log Analytics. Configure it with all relevant logs, metrics, and diagnostic information.
- Configure Azure Arc-enabled Server agent on guest VMs running inside Azure VMware Solution private cloud.

#### Assessment Questions
Have common queries for troubleshooting and debugging been identified and defined?


## Visualization 
#### Impact: _Operational excellence_ 

Visually representing the monitoring reports in dashboards helps drive effective operations to do root-cause analysis and troubleshooting quickly. Operation teams can use such a dashboard for a simplified view of all key resources that make up Azure VMware Solution in a single pane. 

### Recommendations
- Configure the Monitoring dashboard. 
- Create Azure Workbook as a central repository for commonly executed queries, metrics, and interactive reports. 

#### Assessment question 

-Have you created a single dashboard for all monitoring in a single pane? 

### Application Performance Monitoring and Alerting 

Workloads running in Azure VMware Solution private cloud need effective performance monitoring and alerting to respond to any change in their performance baseline. 
For example, collecting logs to collect metrics, trace requests, and capture logs for both the application and infrastructure layer. This mechanism for workloads running in Azure VMware Solution private cloud aids in creating proactive performance monitoring and alerting to respond to any change in their performance baseline. 

### Recommendation

- Discuss and establish baselines based on performance data
- Use application performance monitoring (APM) tools to gain performance insights and the application code level.
- Use a combination of monitoring techniques such as synthetic transactions, heartbeat monitoring, and endpoint monitoring
- Integrate alerts with collaboration messaging tools such as Microsoft Teams

#### Assessment Questions 

- What tools are in place for monitoring the health of the application?
