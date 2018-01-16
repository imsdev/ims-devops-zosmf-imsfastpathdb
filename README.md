# IMS™ Fast Path DEDB database workflows for z/OSMF

## Overview

With the IMS™ Fast Path DEDB database workflows you can rapidly provision or deprovision a DEDB database in an existing IMS system by using the IBM® z/OS® Management Facility
(z/OSMF).

#### Provision workflow
The provision workflow will provision a Fast Path DEDB database in an existing IMS™ with these steps:

| Step          | Description   |
| :------------:|:------------- |
| 1 | Environmental variable information gathering|
| 2 | Allocate datasets for DB deployment|
| 3 | Database Deployment|
| 3.1 | Create DB Structure|
| 3.2 | Compile/Link IMS Database Descriptor definition|
| 3.3 | Create the IMS Program Specification definitions|
| 3.4 | Compile and link the IMS program specification block|
| 3.5 | Perform ACBGEN for the DBD and PSB|
| 3.6 | Allocate Database datasets|
| 3.7 | DBRC Definitions (DBRC INIT)|
| 3.8 | Initialize Database datasets|
| 3.9 | Define IMS Database for Dynamic Allocation|
| 3.10| Define IMS Dynamic Allocation for staging ACBLIB|
| 4 | IMS Resource Definitions for your Database|
| 4.1 | Define your program access (PSB) to IMS|
| 4.2 | Define your Database to IMS|
| 4.3 | Prepare Inactive ACBLIB for OLC|
| 4.4 | Bring online all IMS application-related definitions|
| 5 | Start all the IMS Resources|
| 5.1 | Start IMS Database|
| 5.2 | Load and initialize the IMS Database|
| 5.3 | DBRC Processing (DBRC IC)|
| 6 | IMS Cloud Database deployed. Clean up installation files|


#### De-provision workflow
The de-provision workflow will de-provision a Fast Path DEDB database in an existing IMS with these steps:

| Step          | Description   |
| :------------:|:------------- |
| 1 | Environmental variable information gathering|
| 2 | Stop DB|
| 3 | Delete program resources|
| 4 | Delete database resources|
| 5 | Prep ACBLIB for OLC|
| 6 | INITIATE OLC PHASE(PREPARE)|
| 7 | INITIATE OLC PHASE(COMMIT)|
| 8 | Delete from DBRC|
| 9 | Clean up data sets|

#### Input variables
The IMS_DEDB_Input_Variables.properties file contains the properties that are shown in the
following table.
The properties file contains default values for some of these variables, but you will need to customize
others.

| Property      | Remarks       |
| :-------------|:------------- |
| DFS_PSBNAME | DB PSB name|
| DFS_IMS_SSID | SSID of existing IMS|
| appname | Name of application for new DB|
| zCloud_IMSODBM | |
| zCloud_PORTIDSuf | |
| DFS_IMSPlex | IMS Plex name|
| zCloud_IMSXCFGroup | IMS Coupling Facility group|
| zCloud_IMS_CRC | Command Recognition Character|
| zCloud_IMS_LINEGRP | DC Terminal Unit Type|
| zCloud_VTAM_IMSAPPLID | IMS APPLID|
| DFS_AUTH_LIB_HLQ | HLQ for IMS installation libraries|
| DFS_AUTH_LIB_HLQ2 | 2nd level HLQ for IMS instance datasets to read/write|
| IXUSSCLS | |
| IXUSMCLS | |
| DFS_DS_VOLUME1 | Dataset Volume|
| DFS_DS_VOLUME2 | Dataset Volume|
| zCloud_IMSDEV | |
| zCloud_IMSDEV2 | |
| zCloud_LERuntime | Language Environment Runtime dataset|
| zCloud_MACLIB | z/OS Macros Library|
| zCloud_LPALIB | z/OS LPA Library|
| zCloud_PROCLIB | IMS PROC Library|
| zCloud_MODGEN | z/OS MODGEN Library|
| zCloud_CSSLIB | z/OS PROC Library|
| zCloud_VTAM_Procedure | VTAM Procedure|
| DFS_VTAM_NODE_IMSMTO | VTAM Node for IMS MTO|
| DFS_VTAM_NODE_IMSND1 | VTAM Node for IMS Terminal 1|
| DFS_VTAM_NODE_IMSND2 | VTAM Node for IMS Terminal 2|
| zCloud_TCBIPLinklib | TCP/IP Load Library|
| IXUSTIM1 | EXEC time parameter for SMP/E, SYSDEF STAGE1|
| IXUSTIM3 | EXEC time parameter for MPPs, IFPs, IRLM, VTAM|
| DFS_IMS_USERID | IMS User ID|
| IXUTZONE | IMS SMP/E Target Zone ID|
| IXUGZDSN | IMS SMP/E Global Zone CSI|
| DFS_MOUNTPOINT | Mount Point for Unix Files|
| DFS_FSTYPE | File System for Unix Files|
| DFS_IMS_SECURITY | True/False to use SMS managed DASD for IMS libraries|

## Pre-requisites
* An existing IMS system.
* Identify the z/OS and IMS system parameters.
* The workflow files are installed in a suitable USS directory.
* z/OSMF must be started. Both the angel and server z/OSMF address spaces must be started. 

## Security requirements 
To run the workflow, you need the following authority:
* RACF read authority on SMP/E installed IMS libraries.
* RACF update authority on the high level qualifiers (HLQs) you are using for the IMS instance libraries.

## Package structure 
The repository includes the following files:
* Provision_IMS_DEDB.xml
  * This file provisions an IMS Fast Path DEDB database. Do not modify the workflow XML.
* Deprovision_IMS_DEDB.xml
  * This file de-provisions an IMS Fast Path DEDB database. Do not modify the workflow XML.
* IMS_DEDB_Variables.xml
  * This file defines the variables that are referenced by the steps in the workflow.
* IMS_DEDB_Input_Variables.properties
  * This properties file contains values from the variables referenced in the provision_IMS_DEDB.xml and deprovision_IMS_DEDB.xml workflows. Edit the each properties file to specify the system specific information for the variables in the file.

## Installation 
* FTP the Provision_IMS_DEDB.xml, Deprovision_IMS_DEDB.xml, and the IMS_DEDB_Input_Variables.properties files to USS on the z/OS host in binary mode.
* The files need to be made visible to the z/OSMF application.  Do this by changing the access permissions of the files using the chmod command.
* Example chmod commands:
```Java
chmod 755 Provision_IMS_DEDB.xml
```
* Or if the file is in a folder with the name of workflows:
```Java 
chmod -R 755 workflows
```

## Steps to run the workflow using the z/OSMF web interface
1. Log into the IBM z/OS Management Facility web interface.
1. Select "Workflows" from the left menu.
1. Select the "Actions" drop down menu.
1. Select "Create Workflow".
1. In the Create Workflow dialog, specify:
    *	Workflow definition file: 
    *	Workflow variable input file:
    *	System:
1. Select "Next".
1. Select “Assign all steps to owner user ID” if you are going to run all of the workflow steps with the current user ID.
1. Select "Finish".
1. Right-click on the first action and select "Perform".

For more information about running a workflow see [Create a workflow](https://www.ibm.com/support/knowledgecenter/en/SSLTBW_2.3.0/com.ibm.zosmfworkflows.help.doc/izuWFhpCreateWorkflowDialog.html).

## Troubleshooting
* IZUWF0105E   Workflow property file file-name is either not found or cannot be accessed
  * Typically this error comes from the file not existing at the path given, or the file exists, and chmod needs to be done on this file.
* If there is no "Workflows" menu option in the z/OSMF web interface configure the IZUPRMxx member in the SYS.PARMLIB specifying the WORKLOAD_MGMT in the PLUGINS statement. For more information see [creating a IZUPRMxx](https://www.ibm.com/support/knowledgecenter/en/SSLTBW_2.2.0/com.ibm.zos.v2r2.izua300/izuconfig_IZUPRMxx.htm) in the IBM Knowledge Center.
  * Example: 
  
  PLUGINS(INCIDENT_LOG  
        COMMSERVER_CFG
        CAPACITY_PROV 
        SOFTWARE_MGMT 
        ISPF          
        RESOURCE_MON  
        WORKLOAD_MGMT)

## z/OSMF documentation

Visit the IBM Knowledge Center for more information on [IBM z/OS Management Facility](https://www.ibm.com/support/knowledgecenter/search/IBM%20z%2FOS%20Management%20Facility?scope=SSLTBW_2.2.0).
