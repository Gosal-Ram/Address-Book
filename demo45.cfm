<cfset local.value = createObject("component", "component.index")>
<cfset local.result = local.value.mailBdayContacts()>
<cfoutput>
    <cfloop query="local.result">
        #local.result.firstname#
    </cfloop>
    
</cfoutput>
<!--- <cfschedule  
    action = "update"  
    task="mailBdayContacts" 
    operation = "HTTPRequest" 
    url = "http://127.0.0.1:8500/gosal/Address%20book/demo.cfm" 
    startDate = "#dateFormat(now(),"yyyy-MM-dd")#" 
    startTime = "14:45" 
    interval ="daily">   --->






        <cffunction  name="mailBdayContacts">
            <cfset local.month = Month(now())>
            <cfset local.day = Day(now())>
            <cfquery name="getTodayBirthdays">
                SELECT firstname,lastname, email,_createdBy
                FROM cfcontactDetails
                WHERE MONTH(dateofbirth) = <cfqueryparam value = "#local.month#" cfsqltype="CF_SQL_VARCHAR">
                AND DAY(dateofbirth) = <cfqueryparam value = "#local.day#" cfsqltype="CF_SQL_VARCHAR">
            </cfquery>


            <cfif getTodayBirthdays.recordcount gt 0>
                <cfloop query="getTodayBirthdays">
                    <cfmail to="#email#" from="gosalram554@gmail.com" subject="Happy Birthday, #firstname#!">
                        Dear #firstname#,

                        Wishing you a very Happy Birthday! 
                        
                        Regards,#_createdBy#
                        
                    </cfmail>
                </cfloop>
            </cfif>
            <cfreturn getTodayBirthdays>
        </cffunction>