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
            SELECT userName,pwd,profilePic,fullname
            FROM cfuser 
            WHERE userName = <cfqueryparam value = "#arguments.userName#" cfsqltype="CF_SQL_VARCHAR">
        </cfquery>

        <cfif queryUserLogin.userName == ''>
            <cfset local.result = "user name doesn't exist">
        <cfelseif queryUserLogin.pwd NEQ local.encryptedPassFromUser >
            <cfset local.result = "Invalid password">
        <cfelse>
            <cfset session.isLoggedIn = true>
            <cfset session.userName = queryUserLogin.userName>
            <cfset session.fullName = queryUserLogin.fullname>
            <cfset session.profilePic = queryUserLogin.profilePic>
          
            <cflocation  url = "Home.cfm" addToken="no">  
        </cfif>
        <cfreturn local.result>
    </cffunction>

    <cffunction  name="createContact" returnType="any">
        <cfargument type="string" required="true" name="nameTitle">
        <cfargument type="string" required="true" name="firstName">
        <cfargument type="string" required="true" name="lastName">
        <cfargument type="string" required="true" name="gender">
        <cfargument type="string" required="true" name="dob">
        <cfargument type="string" required="true" name="contactProfile">
        <cfargument type="string" required="true" name="address">
        <cfargument type="string" required="true" name="street">
        <cfargument type="string" required="true" name="district">
        <cfargument type="string" required="true" name="state">
        <cfargument type="string" required="true" name="country">
        <cfargument type="string" required="true" name="pincode">
        <cfargument type="string" required="true" name="email">
        <cfargument type="string" required="true" name="mobile">

        <cfset local.result = true>
        <cfset local.path = expandPath("./assets/contactImages")>
        <cffile  action="upload" destination = "#local.path#" nameConflict="makeUnique">
        <cfset local.file = cffile.clientFile>
        <cfquery name="queryInsertContact" datasource="database_gosal">
            INSERT INTO cfcontactDetails(nameTitle,firstname,lastname,gender,dateofbirth,contactprofile,address,street,district,state,country,pincode,email,mobile,_createdBy) 
            VALUES (<cfqueryparam value = "#arguments.nameTitle#" cfsqltype="CF_SQL_VARCHAR">,
                <cfqueryparam value = "#arguments.firstname#" cfsqltype="CF_SQL_VARCHAR">,
                <cfqueryparam value = "#arguments.lastname#" cfsqltype="CF_SQL_VARCHAR">,
                <cfqueryparam value = "#arguments.gender#" cfsqltype="CF_SQL_VARCHAR">,
                <cfqueryparam value = "#arguments.dob#" cfsqltype="CF_SQL_VARCHAR">,
                <cfqueryparam value = "#local.file#" cfsqltype="CF_SQL_VARCHAR">,
                <cfqueryparam value = "#arguments.address#" cfsqltype="CF_SQL_VARCHAR">,
                <cfqueryparam value = "#arguments.street#" cfsqltype="CF_SQL_VARCHAR">,
                <cfqueryparam value = "#arguments.district#" cfsqltype="CF_SQL_VARCHAR">,
                <cfqueryparam value = "#arguments.state#" cfsqltype="CF_SQL_VARCHAR">,
                <cfqueryparam value = "#arguments.country#" cfsqltype="CF_SQL_VARCHAR">,
                <cfqueryparam value = "#arguments.pincode#" cfsqltype="CF_SQL_VARCHAR">,
                <cfqueryparam value = "#arguments.email#" cfsqltype="CF_SQL_VARCHAR">,
                <cfqueryparam value = "#arguments.mobile#" cfsqltype="CF_SQL_VARCHAR">,
                <cfqueryparam value = "#session.userName#" cfsqltype="CF_SQL_VARCHAR">)
        </cfquery>
        <cfset local.result = "contact created succesfully">
        <cflocation  url="./Home.cfm" addToken="no">
        <cfreturn local.result>
    </cffunction>

    <cffunction  name="fetchContact">
        <cfquery name="local.queryGetContacts">
            SELECT contactid, firstname, lastname, contactprofile, email, mobile
            FROM cfcontactDetails
            WHERE _createdBy = <cfqueryparam value = "#session.userName#" cfsqltype="cf_sql_varchar">
        </cfquery> 
        <cfreturn local.queryGetContacts>
    </cffunction>

    <cffunction  name="logOut" access="remote">
<!---        <cfset structDelete(session,"username")>  --->
       <cfset structClear(session)>
    </cffunction>

    <cffunction  name="deletePage" retunType="boolean" access="remote">
        <cfargument  name="contactid" required ="true">
        <cfquery name= "queryDeletePage">
            DELETE FROM cfcontactDetails WHERE contactid = <cfqueryparam value = "#arguments.contactid#" cfsqltype="CF_SQL_INTEGER">
        </cfquery>
        <cfreturn true>
    </cffunction>



























</cfcomponent>










