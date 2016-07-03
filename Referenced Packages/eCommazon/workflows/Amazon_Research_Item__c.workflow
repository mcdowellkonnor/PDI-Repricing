<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Amazon_Final_Cost</fullName>
        <field>Amazon_Final_Cost_n__c</field>
        <formula>Amazon_Commission_C__c+ FBA_Order_Handling_F__c+ FBA_Pick_Pack_F__c+  FBA_Outbound_Shipping__c+ FBA_Weight_Handling_Currency__c+ FBA_30_Day_Storage_Fee_F__c+ Inbound_Shipping_Cost__c+ Cost__c</formula>
        <name>Amazon Final Cost</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Fulfillment_Cost_Subtotal</fullName>
        <field>Fulfillment_Cost_Subtotal__c</field>
        <formula>FBA_Order_Handling_F__c + FBA_Pick_Pack_F__c + FBA_Outbound_Shipping__c + FBA_Weight_Handling_Currency__c+ FBA_30_Day_Storage_Fee_F__c + Inbound_Shipping_Cost__c</formula>
        <name>Fulfillment Cost Subtotal</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Amazon_Commission</fullName>
        <field>Amazon_Commission__c</field>
        <formula>IF(OR(Amazon_Category__c = &apos;Major Appliances&apos;,Amazon_Category__c = &apos;Wireless Phone Accessory&apos;,Amazon_Category__c = &apos;Sports Apparel&apos;,Amazon_Category__c = &apos;Tools &amp; Hardware&apos;,Amazon_Category__c = &apos;Home&apos;,Amazon_Category__c = &apos;Home Improvement&apos;,Amazon_Category__c = &apos;Lighting&apos;,Amazon_Category__c = &apos;Paperback&apos;,Amazon_Category__c = &apos;Pet Products&apos;,Amazon_Category__c = &apos;Single Detail Page Misc &apos;,Amazon_Category__c = &apos;Furniture&apos;,Amazon_Category__c = &apos;Game&apos;,Amazon_Category__c = &apos;Audio CD&apos;,Amazon_Category__c = &apos;DVD Audio&apos;,Amazon_Category__c = &apos;Electronics&apos;,Amazon_Category__c = &apos;Baby Product&apos;, CONTAINS(Amazon_Category__c, &apos;Beauty&apos;),Amazon_Category__c = &apos;eBooks&apos;,Amazon_Category__c = &apos;Toy&apos;, Amazon_Category__c = &apos;PC Accessory&apos;,  Amazon_Category__c = &apos;Kitchen&apos;, Amazon_Category__c = &apos;Music&apos;, Amazon_Category__c = &apos;PC Accessory&apos;, Amazon_Category__c = &apos;Sports&apos;,  Amazon_Category__c = &apos;Shoes&apos;, Amazon_Category__c = &apos;Digital Video Games&apos;, Amazon_Category__c = &apos;Apparel&apos;, Amazon_Category__c = &apos;Wireless&apos;,Amazon_Category__c = &apos;Grocery&apos;,Amazon_Category__c = &apos;Tools &amp; Home Improvement&apos;),0.15,  IF( OR(Amazon_Category__c = &apos;Photography&apos;,Amazon_Category__c = &apos;Network Media Player&apos;, Amazon_Category__c = &apos;Receiver or Amplifier&apos;, Amazon_Category__c = &apos;Video Games&apos;) ,0.8,  IF( OR(Amazon_Category__c = &apos;Automotive&apos;,Amazon_Category__c = &apos;3D Printable&apos;, Amazon_Category__c = &apos;Office Product&apos;,Amazon_Category__c = &apos;Industrial &amp; Scientific&apos;, Amazon_Category__c = &apos;Lawn &amp; Patio&apos;) ,0.12,  IF( OR(Amazon_Category__c = &apos;Watch&apos;,Amazon_Category__c = &apos;Entertainment Memorabilia&apos;, Amazon_Category__c = &apos;Jewelry&apos;, Amazon_Category__c = &apos;Entertainment Memorabilia&apos;),0.20,  IF( OR(Amazon_Category__c = &apos;Automotive Parts and Accessories&apos;) , 0.10,  IF( OR(Amazon_Category__c = &apos;Digital Device Accessory&apos;),0.45, IF( OR(Amazon_Category__c = &apos;Personal Computer&apos;),0.6, null) ) ) ) ) ) )</formula>
        <name>Update Amazon Commission %</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_FBA_Weight_Handling</fullName>
        <field>FBA_Weight_Handling_Currency__c</field>
        <formula>IF(AND(Lowest_Current__c &gt;= 300,Lowest_Current__c&lt;&gt;999.99),0,IF(AND( Ship_Weight__c &lt;= 1,Product_Size_Tier__c =&apos;Small Standard-Size&apos;), 0.50,IF(AND(Ship_Weight__c&lt;=1,Product_Size_Tier__c=&apos;Large Standard-Size&apos;, Product_Type__c=&apos;Media&apos;),0.85,IF(AND(Ship_Weight__c &lt;= 1, Product_Size_Tier__c=&apos;Large Standard-Size&apos;,Product_Type__c=&apos;Non-Media&apos;), 0.96,IF(AND(Ship_Weight__c&gt;1,Ship_Weight__c&lt;= 2,Product_Size_Tier__c =&apos;Large Standard-Size&apos;,Product_Type__c =&apos;Media&apos;), 1.24,IF(AND(Ship_Weight__c&gt;1,Ship_Weight__c&lt;= 2,Product_Size_Tier__c=&apos;Large Standard-Size&apos;,Product_Type__c =&apos;Non-Media&apos;), 1.95,IF(AND(Ship_Weight__c&gt;2,Product_Size_Tier__c=&apos;Large Standard-Size&apos;, Product_Type__c=&apos;Media&apos;),(1.24+(Ship_Weight__c-2)*0.41),IF(AND( Ship_Weight__c&gt;2,Product_Size_Tier__c =&apos;Large Standard-Size&apos;, Product_Type__c=&apos;Non-Media&apos;),(1.95+(Ship_Weight__c-2)*0.39),IF( Product_Size_Tier__c = &apos;Small Oversize&apos;, (2.06+ (Ship_Weight__c-2)*0.39), IF(Product_Size_Tier__c=&apos;Medium Oversize&apos;,(2.73+(Ship_Weight__c-2)*0.39), IF(Product_Size_Tier__c=&apos;Large Oversize&apos;,(63.98+ (Ship_Weight__c-2)*0.80), IF(Product_Size_Tier__c=&apos;Special Oversize&apos;,(124.58+(Ship_Weight__c-2)*0.92), 0.00))))))))))))</formula>
        <name>Update FBA Weight Handling</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Inbound_lb</fullName>
        <field>Inbound_lb__c</field>
        <formula>Amazon_Research__r.Supplier__r.ECS__Default_Freight_Charge__c</formula>
        <name>Update Inbound $/lb</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Amazon Final Cost</fullName>
        <actions>
            <name>Amazon_Final_Cost</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Amazon_Commission</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_FBA_Weight_Handling</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Inbound_lb</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Amazon_Research_Item__c.Name</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Amz-Fulfillment Cost Subtotal</fullName>
        <actions>
            <name>Fulfillment_Cost_Subtotal</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Amazon_Research_Item__c.Name</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
