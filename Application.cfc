<cfcomponent>
    <cfset this.name = "addressbook">
    <cfset this.sessionManagement = "true">
    <cfset this.dataSource = "database_gosal">
    <cfset this.ormEnabled = true>
    <cfset application.value = createObject("component","component.index")>
    <cffunction  name="onRequest"> 
        <cfargument  name="requestPage">
        <cfif structKeyExists(session, "username") OR requestPage EQ "/gosal/Address book/index.cfm" OR requestPage EQ "/gosal/Address book/demo.cfm">
            <cfinclude  template="#arguments.requestPage#">
        <cfelse>
            <cfinclude  template = "/gosal/Address book/Login.cfm">
        </cfif>
    </cffunction>
</cfcomponent>
