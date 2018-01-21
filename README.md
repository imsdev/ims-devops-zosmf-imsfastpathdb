# IMS Fast Path DEDB database workflows for z/OSMF

## Overview

You can rapidly provision or deprovision a DEDB database in an existing IMS™ system by using the IBM® z/OS® Management Facility (z/OSMF) with these z/OSMF workflow samples.

#### Provision workflow
The provision workflow will provision a Fast Path DEDB database in an existing IMS™ with these steps:

| Step          | Description   |
| :------------:|:------------- |
| 1 | Environmental variable information gathering|
| 2 | Allocate data sets for DB deployment|
| 3 | Database deployment|
| 3.1 | Create DB structure|
| 3.2 | Compile and Link IMS database descriptor definition|
| 3.3 | Create the IMS program specification definitions|
| 3.4 | Compile and link the IMS program specification block|
| 3.5 | Perform ACBGEN for the DBD and PSB|
| 3.6 | Allocate database data sets|
| 3.7 | DBRC definitions (DBRC INIT)|
| 3.8 | Initialize database data sets|
| 3.9 | Define IMS database for dynamic allocation|
| 3.10| Define IMS dynamic allocation for staging ACBLIB|
| 4 | IMS resource definitions for your database|
| 4.1 | Define your program access (PSB) to IMS|
| 4.2 | Define your database to IMS|
| 4.3 | Prepare inactive ACBLIB for OLC|
| 4.4 | Bring online all IMS application-related definitions|
| 5 | Start all the IMS resources|
| 5.1 | Start IMS database|
| 5.2 | Load and initialize the IMS database|
| 5.3 | DBRC processing (DBRC IC)|
| 6 | IMS cloud database deployed. Clean up installation files|


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
The properties file contains default values for some of these variables, but you must customize
others.

| Property      | Remarks       |
| :-------------|:------------- |
| DFS_PSBNAME | DB PSB name|
| DFS_IMS_SSID | SSID of existing IMS|
| appname | Name of application for new DB|
| zCloud_IMSODBM | |
| zCloud_PORTIDSuf | |
| DFS_IMSPlex | IMS Plex name|
| zCloud_IMSXCFGroup | IMS coupling facility group|
| zCloud_IMS_CRC | Command recognition character|
| zCloud_IMS_LINEGRP | DC terminal unit type|
| zCloud_VTAM_IMSAPPLID | IMS APPLID|
| DFS_AUTH_LIB_HLQ | HLQ for IMS installation libraries|
| DFS_AUTH_LIB_HLQ2 | 2nd level HLQ for IMS instance data sets to read/write|
| IXUSSCLS | |
| IXUSMCLS | |
| DFS_DS_VOLUME1 | Data set volume|
| DFS_DS_VOLUME2 | Data set volume|
| zCloud_IMSDEV | |
| zCloud_IMSDEV2 | |
| zCloud_LERuntime | Language environment runtime data set|
| zCloud_MACLIB | z/OS macros library|
| zCloud_LPALIB | z/OS LPA library|
| zCloud_PROCLIB | IMS PROC library|
| zCloud_MODGEN | z/OS MODGEN library|
| zCloud_CSSLIB | z/OS PROC library|
| zCloud_VTAM_Procedure | VTAM procedure|
| DFS_VTAM_NODE_IMSMTO | VTAM node for IMS MTO|
| DFS_VTAM_NODE_IMSND1 | VTAM node for IMS terminal 1|
| DFS_VTAM_NODE_IMSND2 | VTAM node for IMS terminal 2|
| zCloud_TCBIPLinklib | TCP/IP load library|
| IXUSTIM1 | EXEC time parameter for SMP/E, SYSDEF STAGE1|
| IXUSTIM3 | EXEC time parameter for MPPs, IFPs, IRLM, VTAM|
| DFS_IMS_USERID | IMS user ID|
| IXUTZONE | IMS SMP/E target zone ID|
| IXUGZDSN | IMS SMP/E global zone CSI|
| DFS_MOUNTPOINT | Mount point for unix files|
| DFS_FSTYPE | File system for unix files|
| DFS_IMS_SECURITY | True/False to use SMS-managed DASD for IMS libraries|

## Pre-requisites
* An existing IMS system.
* Identify the z/OS and IMS system parameters.
* The workflow files are installed in a suitable USS directory.
* z/OSMF must be started. Both the angel and server z/OSMF address spaces must be started. 

## Security requirements  
To run the workflow, you need the following authority:
* RACF READ authority on SMP/E-installed IMS libraries.
* RACF UPDATE authority on the high-level qualifiers (HLQs) you are using for the IMS instance libraries.

## Package structure 
The repository includes the following files:
* Provision_IMS_DEDB.xml
  * This workflow XML provisions an IMS Fast Path DEDB database. Do not modify this file.
* Deprovision_IMS_DEDB.xml
  * This workflow XML de-provisions an IMS Fast Path DEDB database. Do not modify this file.
* IMS_DEDB_Variables.xml
  * This file defines the variables that are referenced by the steps in the workflow.
* IMS_DEDB_Input_Variables.properties
  * This properties file contains values for the variables referenced in the provision_IMS_DEDB.xml and deprovision_IMS_DEDB.xml workflows. Edit the IMS_DEDB_Input_Variables.properties file to specify your system specific information for the variables in the file.

## Installation 
* Use FTP to transfer the Provision_IMS_DEDB.xml, Deprovision_IMS_DEDB.xml, and the IMS_DEDB_Input_Variables.properties files to USS on the z/OS host in binary mode.
* Make these files visible to the z/OSMF application.  Do this by changing the access permissions of the files using the chmod command.
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
1. Select **Workflows** from the left menu.
1. Select the **Actions** drop down menu.
1. Select **Create Workflow**.
1. In the Create Workflow dialog, specify the following information:
    *	Workflow definition file
    *	Workflow variable input file
    *	System
1. Select **Next**.
1. Select **Assign all steps to owner user ID** if you are going to run all of the workflow steps with the current user ID.
1. Select **Finish**.
1. Right-click the first action and select **Perform**.

For more information about running a workflow see [Creating a workflow](https://www.ibm.com/support/knowledgecenter/en/SSLTBW_2.3.0/com.ibm.zosmfworkflows.help.doc/izuWFhpCreateWorkflowDialog.html) in the IBM Knowledge Center.

## Troubleshooting
* IZUWF0105E   Workflow property file file-name is either not found or cannot be accessed
  * Typically, this error occurs when the file does not exist at the given path. If the file does exist, access permission to the file must be set by using the chmod command.
* If there is no **Workflows** menu option in the z/OSMF web interface, configure the IZUPRMxx member in SYS.PARMLIB to specify the WORKLOAD_MGMT in the PLUGINS statement. For more information see [creating a IZUPRMxx](https://www.ibm.com/support/knowledgecenter/en/SSLTBW_2.2.0/com.ibm.zos.v2r2.izua300/izuconfig_IZUPRMxx.htm) in the IBM Knowledge Center.
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
