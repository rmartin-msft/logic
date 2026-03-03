# First real workflow

## Scenario
The objective of this lab is to understand the basic constructs of building a workflow. In this lab, we'll expose a simple HTTP endpoint which validates the inputs and writes the result to an azure storage account. 

During the lab, we'll introduce the HTTP Trigger action and use the Azure Storage Connector and introduce the concept of validating data represented in Javascript Object Notation (JSON) which has become a standard format for data exchange between different systems. We'll also cover a little about writing expressions and reporting run history.

## Setting up the lab

If you haven't already, you'll need to provision your Azure Logic Apps Standard Environment. To do this you'll use the command `azd up` from the terminal window.

### Steps 1 - Opening the environment

- In the Azure Portal window (https://portal.azure.com) locate your resource group, which should be similar to `rg-logicapps-INITIAL`. Inside, you should find three Azure Resources have been created.

- ℹ️ *Note: There may be other resources automatically created in the resource group, but these are not needed for this lab and can be ignored for now.*

![Azure Resources](./01/IMG/deployment.png)

- Logic Apps Environment
- App Service Plan - for hosting the Logic Apps
- Storage Account - for storing state of your logic apps, don't worry about this yet - we'll be using this later.

### Step 2 - Opening your Logic App Resource
For this lab, we'll be build our workflow using the on-line designer in the Azure Portal. 

1. Open the Logic app resource by clicking on the logic app resource link

    ![Open Logic Apps](./01/IMG/logicapp-resource.png)


### Configure Identity 

To create connections and effeciently secure your Azure resources to your workflows the workflow needs to be configured with an Identity. You can choose the Identity or have the system automatically create one.

1. Configure System Assigned Managed Identity
    
    ![alt text](image-1.png)

Managed Identities enhance security and avoid the need to share passwords and secrets, effectively identifying your Azure Logic App Environment. When the environment is deleted, the System Managed Identities are automatically cleaned up.

2. Save the Configuration and wait for the page to refresh.
3. Click the `Azure Role Assignments` button
    ![alt text](image-2.png)

4. In the assignments option choose Storage from the Scope
5. Locate the storage account name that was listed in your resource group - It'll probably start with st

    ![alt text](image-3.png)

6. We'll choose Contributor for our role here, but we'd use more fine grain controls in production.

### Step 3 - Creating our first workflow

This will open the Azure Logic Apps blade. For standard Logic Apps, multiple workflows can be hosted in the plan. We'll find all our **workflows** under the Workflow section, where we'll also find our **connections** and and **Parameters**

![Create workflow](./01/IMG/create-workflow.png)

1. Create a new workflow either by open the Workflows section and choosing Create OR click the Quick Link from the main pane to open the **Create workflow** form
2. Name the workflow **OrderSupplies** 
3. Choose Stateless for the workflow type.
4. Click **create** button to create the workflow

    ![alt text](image.png)

### Step 4 - Open the workflow
From the workflow pane, choose the Workflow you've just created to open it in the designer. 

![tryit](./01/IMG/designer.png)

If a banner appears about the new Logic Apps experience - select try it now. The new preview mode gives a modern and faster design surface.

![new-designer](./01/IMG/preview-designer.png)

### Step 5 - Adding the Trigger
We're going to add the trigger to our workflow to enable it to respond 

1. Press the + Add Trigger button. On
2. Ot the right hand panel select the `When an HTTP Request is received` option. 

    ![http-action](./01/IMG/http-request.png)

    You can rename the action so you can more easily refer back to it later in the workflow. The trigger also has an _optional_ description field to help document the trigger.

    The important part here is the request body. The trigger assumes that the body will contain a request expressed in Javascript Object Notation (JSON) format. 
    
    There are two ways to create the body either by 
        - (1) Declaring the JSON schema into the field or 
        - (2) with an example request which we can infer the schema from.

3. For now, choose "Use a sample payload to generate schema" and paste the following JSON into the request

    ```json        
    {
        "item" : "Printer Paper 80GSM",
        "qty" : 500,
        "priority" : "Urgent"
    }
    ```

4. Change the Method in the drop down to POST

### Step 6 - Adding an action
Once we've received some data, we now need to do something with it. For our workflow, we're going to add a record into Azure Table Storage to represent adding a request to add new supplies for our monthly order.

![AddAction](./01/IMG/AddAction.gif)

1. Click the + button underneath the HTTP action and choose Add Action
2. Choose Data transformation from the action
3. In the search box type `Table` to find the Azure Table Storage actions
4. Choose the `Insert Entity (V2)` action

As we don't already have a connection to Azure Table Storage already setup, you'll need to create a new connection to Azure Storage.

5. Add your initials to the connection to make it easier to find in the future
6. We'll cover security later, for now choose Access Key






