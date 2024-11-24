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
            <cfif arguments.profilePic =="">
                <cfset local.imagePath = "user-grey-icon.png">
            <cfelse>
                <cfset local.imagePath = expandPath("./assets/userImages")>
                <cffile  action="upload" destination="#local.imagePath#" nameConflict="makeunique">
                <cfset local.imagePath = cffile.clientFile>
            </cfif>
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
        <cfif arguments.contactProfile =="">
            <cfset local.file = "user-grey-icon.png">
            
        <cfelse>
            <cfset local.path = expandPath("./assets/contactImages/")>   <!--- path declare--->
            <cffile  action="upload" destination = "#local.path#" nameConflict="makeUnique">  <!--- uploading file in specified path--->
            <cfset local.file = cffile.clientFile>  <!--- fetching file name --->
        </cfif>
        <!---  to check if contact already exists   --->
        <cfif structKeyExists(session, "contactid")>
            <cfquery name="queryInsertEdits">
            UPDATE cfcontactDetails
            SET 
                nameTitle = <cfqueryparam value = "#arguments.nameTitle#" cfsqltype="CF_SQL_VARCHAR">,
                firstname = <cfqueryparam value = "#arguments.firstname#" cfsqltype="CF_SQL_VARCHAR">,
                lastname = <cfqueryparam value = "#arguments.lastname#" cfsqltype="CF_SQL_VARCHAR">,
                gender = <cfqueryparam value = "#arguments.gender#" cfsqltype="CF_SQL_VARCHAR">,
                dateofbirth = <cfqueryparam value = "#arguments.dob#" cfsqltype="CF_SQL_VARCHAR">,
                contactprofile = <cfqueryparam value = "#local.file#" cfsqltype="CF_SQL_VARCHAR">,
                address = <cfqueryparam value = "#arguments.address#" cfsqltype="CF_SQL_VARCHAR">,
                street = <cfqueryparam value = "#arguments.street#" cfsqltype="CF_SQL_VARCHAR">,
                district = <cfqueryparam value = "#arguments.district#" cfsqltype="CF_SQL_VARCHAR">,
                state = <cfqueryparam value = "#arguments.state#" cfsqltype="CF_SQL_VARCHAR">,
                country = <cfqueryparam value = "#arguments.country#" cfsqltype="CF_SQL_VARCHAR">,
                pincode = <cfqueryparam value = "#arguments.pincode#" cfsqltype="CF_SQL_VARCHAR">,
                email = <cfqueryparam value = "#arguments.email#" cfsqltype="CF_SQL_VARCHAR">,
                mobile = <cfqueryparam value = "#arguments.mobile#" cfsqltype="CF_SQL_VARCHAR">,
                _updatedBy = <cfqueryparam value = "#session.userName#" cfsqltype="CF_SQL_VARCHAR">,
                _updatedOn = <cfqueryparam value = "#Now()#" cfsqltype="CF_SQL_TIMESTAMP">
            WHERE 
            contactid = <cfqueryparam value = "#session.contactid#" cfsqltype="CF_SQL_VARCHAR">


            </cfquery>
        <cfelse>
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
        </cfif>
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

    <cffunction  name="deleteContact" returnType="boolean" access="remote">
        <cfargument  name="contactid" required ="true">
        <cfquery name= "queryDeletePage">
            DELETE FROM cfcontactDetails WHERE contactid = <cfqueryparam value = "#arguments.contactid#" cfsqltype="CF_SQL_VARCHAR">
        </cfquery>
        <cfreturn true>
    </cffunction>

    <cffunction  name="viewContact" returnType="struct" returnFormat = "json" access="remote">
        <cfargument  name = "contactid" required ="true">
        
        <cfset local.contactDetails = structNew()>

        <cfquery name= "queryViewPage">
            SELECT contactid ,nametitle,firstname, lastname,gender,dateofbirth, contactprofile, address,street,district,state,country,pincode, email,mobile
            FROM cfcontactDetails
            WHERE contactid = <cfqueryparam value = "#arguments.contactid#" cfsqltype="cf_sql_varchar">
        </cfquery>

        <cfset local.contactDetails["contactid"] = queryViewPage.contactid>
        <cfset local.contactDetails["nametitle"] = queryViewPage.nametitle>
        <cfset local.contactDetails["firstname"] = queryViewPage.firstname>
        <cfset local.contactDetails["lastname"] = queryViewPage.lastname>
        <cfset local.contactDetails["gender"] = queryViewPage.gender>
        <cfset local.contactDetails["dateofbirth"] = queryViewPage.dateofbirth>
        <cfset local.contactDetails["contactprofile"] = queryViewPage.contactprofile>
        <cfset local.contactDetails["address"] = queryViewPage.address>
        <cfset local.contactDetails["street"] = queryViewPage.street>
        <cfset local.contactDetails["district"] = queryViewPage.district>
        <cfset local.contactDetails["state"] = queryViewPage.state>
        <cfset local.contactDetails["country"] = queryViewPage.country>
        <cfset local.contactDetails["pincode"] = queryViewPage.pincode>
        <cfset local.contactDetails["email"] = queryViewPage.email>
        <cfset local.contactDetails["mobile"] = queryViewPage.mobile>

        <cfreturn local.contactDetails>
    </cffunction>

    <cffunction  name="setContactId" access="remote">
        <cfargument  name="contactId" required = "true">
        <cfif len(trim(arguments.contactId))>
            <cfset session.contactId = arguments.contactId>
        <cfelse>
            <cfset structDelete(session, "contactId")>
        </cfif>
<!---    single btn submit prob      --->
<!--- if session var exists  -> edit --->
<!--- else its-> create --->
    </cffunction>
</cfcomponent>










