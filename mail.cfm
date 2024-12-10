<cfset local.result = application.obj.mailBdayContacts()>
<cfoutput>
    <cfloop query="local.result">
    B'day contacts 
        #local.result.firstname# #local.result.lastname# 
    </cfloop>
</cfoutput>
<cfschedule  
    action = "update"  
    task = "mailBdayContacts" 
    operation = "HTTPRequest" 
    url = "http://contactbook.com/mail.cfm" 
    startDate = "#dateFormat(now(),"yyyy-MM-dd")#" 
    startTime = "00:00" 
    interval ="daily">  
    <!---     startTime = "#timeFormat(now(), "HH:mm")#" --->