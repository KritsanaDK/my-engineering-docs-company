# [71] Salesforce-Create Chat

- **Category**: `aws_and_frontend`
- **Source Sheet**: `Salesforce-Create Chat`
- **Total Rows Parsed**: `11`

## Raw & Structured Data Specification

### Pre-Chat Field

| Col1 | Field Name | SF Field | Remark |
| --- | --- | --- | --- |
|  | Social ID | Social_ID__c |  |
|  | Channel Type | Channel__c | Line-Insurverse, Facebook-Insurverse |
|  | Channel ID | Channel_ID__c |  |
|  | Display Name | Contact_Name__c | Facebook should concat firstname and lastname |
|  | Email | Contact_Email__c | For Facebook |
|  | Is Off Busness Hour | Is_Off_Business_Hour__c | true/false |
|  | External Token | External_Token__c | Using for track between service AWS and Salesforce |
|  | Pervious Chat | Previous_Chat__c | ---- |
| Ref: | https://developer.salesforce.com/docs/atlas.en-us.live_agent_rest.meta/live_agent_rest/live_agent_rest_API_requests.htm |  |  |
