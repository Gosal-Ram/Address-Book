<cfcomponent>
    <cfset this.name = "addressbook">
    <cfset this.sessionManagement = "true">
    <cfset this.dataSource = "database_gosal">
    <cfset this.ormEnabled = true>
    <cfset application.obj = createObject("component","component.addressBook")>
    <cfset allowedPages = ["/index.cfm", "/mail.cfm", "/GoogleSignIn.cfm"]>
    <cffunction  name="onRequest"> 
        <cfargument  name="requestPage">
        <cfif structKeyExists(session, "username") OR ArrayContains(allowedPages, requestPage)>
            <cfinclude template = "#arguments.requestPage#">
        <cfelse>
            <cfinclude template = "/Login.cfm">
        </cfif>
    </cffunction>
</cfcomponent>
