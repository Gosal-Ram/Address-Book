<cfcomponent>
    <cfset this.name = "addressbook">
    <cfset this.sessionManagement = "true">
    <cfset this.dataSource = "database_gosal">
    <cfset this.ormEnabled = true>
    <cfset application.value = createObject("component","component.index")>
    <cfset allowedPages = ["/index.cfm", "/demo.cfm", "/GoogleSignIn.cfm"]>
    <cffunction  name="onRequest"> 
        <cfargument  name="requestPage">
        <!--- <cfif structKeyExists(session, "username") OR requestPage EQ "/index.cfm" OR requestPage EQ "/demo.cfm" OR requestPage EQ "/GoogleSignIn.cfm"> --->
        <cfif structKeyExists(session, "username") OR ArrayContains(allowedPages, requestPage)>
            <cfinclude  template = "#arguments.requestPage#">
        <cfelse>
            <cfinclude  template = "/Login.cfm">
        </cfif>
    </cffunction>
</cfcomponent>
