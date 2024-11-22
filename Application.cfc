<cfcomponent>
    <cfset this.name = "addressbook">
    <cfset this.sessionManagement = "true">
    <cfset this.dataSource = "database_gosal">
    <cffunction  name="onRequest"> 
        <cfargument  name="requestPage">
        <cfif structKeyExists(session, "username") OR requestPage EQ "/gosal/Address book/index.cfm">
            <cfinclude  template="#arguments.requestPage#">
        <cfelse>
            <cfinclude  template = "/gosal/Address book/Login.cfm">
        </cfif>
    </cffunction>
</cfcomponent>
