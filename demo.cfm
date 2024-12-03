<!--- <cfset local.value = createObject("component", "component.index")> --->
<cfset local.result = application.value.mailBdayContacts()>
<cfoutput>
    <cfloop query="local.result">
        #local.result.firstname# #local.result.lastname#
    </cfloop>
</cfoutput>
<cfschedule  
    action = "update"  
    task="mailBdayContacts" 
    operation = "HTTPRequest" 
    url = "http://127.0.0.1:8500/gosal/Address%20book/demo.cfm" 
    startDate = "#dateFormat(now(),"yyyy-MM-dd")#" 
    startTime = "00:00" 
    <!---     startTime = "#timeFormat(now(), "HH:mm")#" --->
    interval ="daily">  