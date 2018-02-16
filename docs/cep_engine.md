### Introduction

CEP Engine is a [DataTorrent RTS Service](services/#overview) that allows users to govern Drools Workbench assets. The service provides you with the capability to change the application functionality, using drools-based rules.

The CEP Engine service is pre-packaged with applications like Omni-channel Fraud Prevention and Account Takeover Prevention. Using this service, you can configure customized rules for an application in DT RTS. From the DT RTS console, you can access CEP Engine service, create the customized rules, and then apply these rules to the application configuration before you launch the application.

### Pre-requisites

- Docker installation (Version 1.9.1 or greater). You can also install Docker during or after RTS installation and specify the docker host in the installation wizard. For more details, please refer to [Docker Configuration](services/#docker-configuration)

### Accessing CEP Engine

When the CEP Engine service is imported and in a running state, you can access it via a proxy URL from either the application configuration page or from the Service Management page.

Steps to access service via Application Configuration page:

1. In an application configuration, from the Services section, select the 'drools-workbench' service. The Service Details page is displayed.
2. Under Proxy URL, click the Web URL. The CEP Engine service login page is displayed.
3. To login into the service, use username **admin** and password **admin**.

Steps to access service via the Service Management page:

1. Click the Settings icon ![](images/services/cog-wheel.png) located on the upper most right section of the page.
2. Select Services option. The Services page is displayed with the list of services.
3. Click on the 'drools-workbench' service link. The Service Details page is displayed.
4. Under Proxy URL, click the Web URL. The CEP Engine service login page is displayed.
5. To login into the service, use username **admin** and password **admin**.


### Configuring Rules in CEP Engine

To configure rules within the CEP Engine, you must complete the following steps:

1. **Create a schema in the Application Configuration**:
	
	1. Create an application configuration for an application.
	2. In the application configuration, create and save a schema. This adds schema in the configuration of the application that you want to launch with the customized rules. <Reference to Config Artifacts documentation>
	
	![step1](/images/cep_engine/step1.png)
	
2. **Create a project in Drools**:

	1. Access the Drools UI, through proxy URL on the 'drools-workbench' service details page.
	2. Log in to Drools UI using the default login credentials.
	3. Click the Authoring tab and select Project Authoring.
	4. In the Welcome page, click New Project.
	5. In the New Project page, enter a project name and description and click Create. The new project gets listed under Project Authoring. For more details, see [Add Project](https://docs.jboss.org/drools/release/7.2.0.Final/drools-docs/html_single/#_wb.quickstartaddproject).
	
	![step2](/images/cep_engine/step2.png)

3. **Add Schema dependency**:

	1. Inside Drools, go to Authoring > Project Authoring and click the name link of the project.
	2. In the Project page, click Settings.
	3. Click the Project Settings button on the left and select Dependencies. The Dependencies page is displayed.
	4. Click Add from Repository button. The Artifacts page is displayed and the schema that was created in DT RTS for the application configuration is listed there.
	5. The schema is now added as a dependency for the project.
	
	![step3](/images/cep_engine/step3.png)

4. **Add Rules file**:

	1. Go to your Drools project and click Create New Asset . A file is created which gets listed in the project.
	2. Open this file, add the rules, and click Save. For more details, refer to [Creating Rules](https://docs.jboss.org/drools/release/7.2.0.Final/drools-docs/html_single/#_welcome).
	
	![step4](/images/cep_engine/step4.png)

5. **Add KieBase and KieSessionName to kmodule.xml**:
	
	1. Inside Drools, go to Project page > Settings.
	2. Click the Project Settings button on the left and select Knowledge Bases and Sessions.
	3. Add the KieBase and Kie Session name to kmodule.xml from here.
	4. Click Save.
	
	![step5-a](/images/cep_engine/step5-a.png)
	
	![step5-b](/images/cep_engine/step5-b.png)

6. **Build and Deploy Project**:
	
	1. Inside Drools, go to Authoring > Project Authoring and select your project.
	2. On the upper right side, click Build & Deploy button. The Rules Jar is created which becomes automatically available in the application configuration in DT RTS.
	
	![step6](/images/cep_engine/step6.png)

7.  **Add Rules Jar to Application Configuration**:

	1. Go to DT RTS and open the corresponding application configuration wherein you want to add the Rules JAR artifact.
	2. Under JAR artifacts, click add from artifact library.
	3. Select the rule jar that was created in Drools Workbench.
	4. The Rules Jar that was created in Drools becomes automatically available in the application configuration in DT RTS.
	
	![step7](/images/cep_engine/step7.png)

8.  **Specify Optional Properties**:

	1. In the same application configuration, add the following properties in the Optional Properties section.
	2. Click Save and launch the application.

	| Property |
	| -- |
	| dt.operator.FraudRulesExecutor.prop.kieSessionName |
	| dt.operator.FraudRulesExecutor.prop.kiebaseName |
	| dt.operator.TransactionValidator.port.input.attr.TUPLE_CLASS |
	| dt.operator.TransactionTransformer.port.input.attr.TUPLE_CLASS |
	| dt.operator.TransactionTransformer.port.output.attr.TUPLE_CLASS |
	| dt.operator.TransactionParser.port.out.attr.TUPLE_CLASS |
	| dt.operator.AccountDataEnricher.port.fraudInput.attr.TUPLE_CLASS |
	| dt.operator.FraudDataAnalyser.port.factsInput.attr.TUPLE_CLASS |
	| dt.operator.FraudDataAnalyser.fieldExtractors(demo) |
	| dt.operator.FraudDataAnalyser.fieldExtractors(fraud) |
	| dt.fraudprevention.enrichments.configFilePath |
