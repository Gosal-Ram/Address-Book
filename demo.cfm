<cfset local.value = createObject("component", "component.index")>
<cfset local.result = local.value.mailBdayContacts()>
<cfoutput>
    <cfloop query="local.result">
        #local.result.firstname#
    </cfloop>
    
</cfoutput>
<!--- <cfschedule  
    action = "delete"  
    task="mailBdayContacts" 
    operation = "HTTPRequest" 
    url = "http://127.0.0.1:8500/gosal/Address%20book/demo.cfm" 
    startDate = "#dateFormat(now(),"yyyy-MM-dd")#" 
    startTime = "14:45" 
    interval ="daily">    --->





    