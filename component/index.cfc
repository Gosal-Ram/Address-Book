<cfcomponent>
    <cffunction  name="signUp" returnType="string">
        <cfargument  name="fullName" type="string" required="true">
        <cfargument  name="emailId" type="string" required="true">
        <cfargument  name="userName" type="string" required="true">
        <cfargument  name="pwd1" type="string" required="true">
        <cfargument  name="profilePic" type="string" required="true">

        <cfset local.encryptedPass = Hash(#arguments.pwd1#, 'SHA-512')/>
        <cfset local.result = "">
        <cfquery name="queryUserCheck" datasource="database_gosal">
            SELECT COUNT(userName) AS count
            FROM cfuser 
            WHERE userName = <cfqueryparam value = "#arguments.userName#" cfsqltype="CF_SQL_VARCHAR">
        </cfquery>
        <cfif queryUserCheck.count>
            <cfset local.result = "user name already exists">
            <cfelse>
                <cfset local.imagePath = expandPath("./assets/userImages")>
                <cffile  action="upload" destination="#local.imagePath#" nameConflict="makeunique">
                <cfset local.imagePath = cffile.clientFile>
                <cfquery name="queryInsert" datasource="database_gosal">
                    INSERT INTO cfuser(fullName,emailId,userName,pwd,profilePic) 
                    VALUES (<cfqueryparam value = "#arguments.fullName#" cfsqltype="CF_SQL_VARCHAR">,
                            <cfqueryparam value = "#arguments.emailId#" cfsqltype="CF_SQL_VARCHAR">,
                            <cfqueryparam value = "#arguments.userName#" cfsqltype="CF_SQL_VARCHAR">,
                            <cfqueryparam value = "#local.encryptedPass#" cfsqltype="CF_SQL_VARCHAR">,
                            <cfqueryparam value = "#local.imagePath#" cfsqltype="CF_SQL_VARCHAR">)
                </cfquery>
                <cfset local.result = "data added to the database">
        </cfif>
        <cfreturn local.result>
    </cffunction>

    <cffunction  name="logIn" returnType="string">
        <cfargument  name="userName" type="string" required ="true">
        <cfargument  name="pwd" type="string" required = "true">

        <cfset local.encryptedPassFromUser = Hash(#arguments.pwd#, 'SHA-512')/>
        <cfset local.result = "">        
        <cfquery name="queryUserLogin" datasource="database_gosal">
            SELECT userName,pwd
            FROM cfuser 
            WHERE userName = <cfqueryparam value = "#arguments.userName#" cfsqltype="CF_SQL_VARCHAR">
        </cfquery>
        <cfif queryUserLogin.userName == ''>
            <cfset local.result = "userName doesn't exist">
            <cfelseif  queryUserLogin.pwd NEQ local.encryptedPassFromUser >
                <cfset local.result = "Invalid password">
            <cfelse>
<!---                 <cfset session.userDetails["role"] = queryUserLogin.role> --->
                <cflocation  url="Home.cfm" addToken="no">
        </cfif>
        <cfreturn local.result>
    </cffunction>
</cfcomponent>