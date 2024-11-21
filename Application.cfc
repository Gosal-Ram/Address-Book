<cfcomponent>
    <cfset this.name = "addressbook">
    <cfset this.sessionManagement = "true">
    <cfset this.dataSource = "database_gosal">
<!---     <cffunction  name="onRequest"> 
        <cfargument  name="requestPage">
        <cfif structKeyExists(session, "userDetails") OR requestPage EQ "/gosal/Task qns/Qn28/Signup.cfm">
            <cfinclude  template="#arguments.requestPage#">
        <cfelse>
            <cfinclude  template = "/gosal/Task qns/Qn28/Login.cfm">
        </cfif>
    </cffunction>--->
</cfcomponent>
