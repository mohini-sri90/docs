# Superset - OLAP Data Visualization

### Introduction

Superset service exposes OAS dashboards that are enterprise-ready and business intelliget, with a rich set of data visualizations and an easy-to-use interface for exploring and visualizing data. The dashboards are packaged within applications like Omni-Channel Fraud Application in DT RTS 3.10. You can run these services when you launch the application, and view the dashboards.

Using the Superset service, you can create, edit and export OAS dashboards. These dashboards perform visualizations on the frontend, whereas Online Analytics Service (OAS) provides a backend for SuperSet service to query the expected visualization. Superset service is launched as a docker service whereas OAS is launched as an apex service. For more details on services, please refer to [DataTorrent RTS Services]() 

### Pre-requisites 

In order to successfully launch Superset service, you need to specifically install Docker (Version 1.9.1 or greater), and specify the necessary configurations, during your RTS intsallation. For more details, please refer to [Specifying Docker Host]()

### Configuring Superset service

Superset Service can be configured as a docker service in an application. For more details, refer to [DataTorrent RTS Services]()

### Managing Superset service

Superset service can be managed from the Service Management page in DT RTS console. For more details, refer to [DataTorrent RTS Services]()

### Accessing Superset service(s)

Superset service is run inside docker containers using Docker images provided by DatTorrent.

These superset services are added as a required service for some RTS applications. You can access the OAS dashboards directly via a proxy URL displayed on the Service details page. 

Steps to view Superset service details via application page -

1. Click the Monitor tab and open an application.
2. Click the Services drop-down and select the Superset service, named like superset-fpa, etc. The Service Details page is displayed. 

Steps to view Superset service details via Service Management Page -

1. Click the Settings icon located on the upper most right section of the page. 
2. Click on the 'Services' option.
3. Click a certain Superset service from the list of all services. 
4. The Service Details page is displayed.


### OAS Dashboard Details

OAS Dashboard lets you visualize real time outcomes, historical trends, data KPIs, historical KPIs, real time operational metrics, trends of operator performance, etc. for the following DT RTS applications:

 - Omni-Channel Fraud Prevention Application
 - Account Take Over Prevention Application
 
 The list of widgets packaged in the dashboards for the two applications have been listed below - 
 
#### Omni-Channel Fraud Prevention Application
The Omni-Channel Fraud Prevention application includes the following dashboards:

- Real-time Account Take-over Fraud Prevention Analysis
- Real-time Account Take-over Fraud Prevention Operations

##### Real-time Fraud Prevention Analysis
The following widgets are available within **Real-time Fraud Prevention Analysis** dashboard: 

| Title  | Type of widget |
|--|--|
| Total Fraud Amount Prevented in the last minute | Trend Line |
| Instances of Fraud Prevented in last minute | Trend Line |
| Fraud Transactions Amount vs All Transactions Amount | Trend Line |
| Fraud Transactions Count vs All Transactions Count | Trend Line |
| Fraud Instances by Device | Bar Chart |
| Fraud Rule Matches | Bar Chart |
| Fraud in the USA | Country Map (USA) |
| Top Cities in Number of POS Fraud Transactions | Table |
| Top Cities in Number of Web Fraud Transactions | Table |
| Top Cities in Number of Mobile Fraud Transactions | Table | 
| Percent of fraud transactions broken down by cardType x cardNetwork | Bar Chart |


##### Real-time Fraud Prevention Operations
The following list of widgets are available within **Real-time Fraud Prevention Operations** dashboard: 

| Title  | Type of widget |
|--|--|
| Top Rules | Table |
| Transactions by Device Type | Bar Chart |
| Transaction Throughput | Trend Line |

#### Account Take-Over Fraud Prevention Application
The Account Take-Over Fraud Prevention application includes the following dashboards - 

- Real-time Account Take-over Fraud Prevention Analysis
- Real-time Account Take-over Fraud Prevention Operations

##### Real-time Account Take-over Fraud Prevention Analysis
The following list of widgets are available within **Real-time Account Take-over Fraud Prevention Analysis** dashboard: 

| Title  | Type of widget |
|--|--|
| Total ATO Frauds | Trend |
| ATO Fraud Breakdown by Channel | Pie |
| Fraud Instances by Device | Bar Chart |
| ATO Frauds | Trend Bar |
| Frauds by EventType | Table |
| Fraud Rule Matches | Bar Chart |
| ATO Fraud in the USA | County Map (USA) |
| Login failures by device type | Bar Chart |


##### Real-time Account Take-over Fraud Prevention Operations
The following list of widgets are available within **Real-time Account Take-over Fraud Prevention Operations** dashboard:  

| Title  | Type of widget |
|--|--|
| Event Throughput | Trend Line |
| Top Rules | Table |
| Events by Device Type | Bar Chart |

#### Managing Dashboards and Slices

Using the controls that are shown in the following images, you can manage the dashboards and slices provided by Superset service. 
    
As a Dashboard user, you can do the following within a Superset Dashboard:
Import a dashboard
Add Druid clusters
Scan new data sources
Refresh Druid metadata
View, edit, and remove Slices
View, edit, and remove dashboards
Edit the dashboard properties
Add users for dashboards 
Create a Dashboard
Refresh the Dashboard
Set the Refresh Interval for the Dashboard
Add Dashboard Filters
Change the Visual Style of the Dashboard
Email a Dashboard
Save a Dashboard
As a Dashboard user, you can do the following within a Superset Dashboard Slice
Move a slice
Refresh Data on a Slice
Edit a Slice
Export Slice to CSV
Edit Slice Properties
Remove Slice from the Dashboard

