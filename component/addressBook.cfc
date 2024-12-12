<cfcomponent>

    <cffunction  name="signUp" returnType="string">
        <cfargument  name="fullName" type="string" required="true">
        <cfargument  name="emailId" type="string" required="true">
        <cfargument  name="userName" type="string" required="true">
        <cfargument  name="pwd1" type="string" required="true">
        <cfargument  name="profilePic" type="string" required="true">

        <cfset local.encryptedPass = Hash(#arguments.pwd1#, 'SHA-512')/>
        <cfset local.result = "">
        <cfquery name = "queryUniqueUserCheck">
            SELECT COUNT(userName) AS count
            FROM cfuser 
            WHERE userName = <cfqueryparam value = "#arguments.userName#" cfsqltype="CF_SQL_VARCHAR">
            AND emailId = <cfqueryparam value = "#arguments.emailId#" cfsqltype="CF_SQL_VARCHAR">
        </cfquery>
        <cfif queryUniqueUserCheck.count>
            <cfset local.result = "user name or mail already exists">
        <cfelse>
            <cfif arguments.profilePic =="">
                <cfset local.imagePath = "user-grey-icon.png">
            <cfelse>
                <cfset local.imagePath = expandPath("./assets/userImages")>
                <cffile action="upload" destination="#local.imagePath#" nameConflict="makeunique">
                <cfset local.imagePath = cffile.clientFile>
            </cfif>
            <cfquery name="queryInsert">
                INSERT INTO cfuser(
                        fullName,
                        emailId,
                        userName,
                        pwd,
                        profilePic
                    ) 
                VALUES (<cfqueryparam value = "#arguments.fullName#" cfsqltype="CF_SQL_VARCHAR">,
                        <cfqueryparam value = "#arguments.emailId#" cfsqltype="CF_SQL_VARCHAR">,
                        <cfqueryparam value = "#arguments.userName#" cfsqltype="CF_SQL_VARCHAR">,
                        <cfqueryparam value = "#local.encryptedPass#" cfsqltype="CF_SQL_VARCHAR">,
                        <cfqueryparam value = "#local.imagePath#" cfsqltype="CF_SQL_VARCHAR">
                    )
            </cfquery>
            <cfset local.result = "user created successfully">
        </cfif>
        <cfreturn local.result>
    </cffunction>

    <cffunction name ="logIn" returnType="string">
        <cfargument name ="userName" type="string" required ="true">
        <cfargument name ="pwd" type="string" required = "true">

        <cfset local.encryptedPassFromUser = Hash(#arguments.pwd#, 'SHA-512')/>
        <cfset local.result = "">        

        <cfquery name ="queryUserLogin">
            SELECT userName,
                    pwd,
                    profilePic,
                    fullname,
                    emailId
            FROM cfuser 
            WHERE userName = <cfqueryparam value = "#arguments.userName#" cfsqltype="CF_SQL_VARCHAR">
        </cfquery>

        <cfif queryUserLogin.userName == ''>
            <cfset local.result = "User name doesn't exist">
        <cfelseif queryUserLogin.pwd NEQ local.encryptedPassFromUser >
            <cfset local.result = "Invalid password">
        <cfelse>
            <cfset session.isLoggedIn = true>
            <cfset session.userName = queryUserLogin.userName>
            <cfset session.fullName = queryUserLogin.fullname>
            <cfset session.profilePic = queryUserLogin.profilePic>
            <cfset session.emailId = queryUserLogin.emailId>
            <cflocation  url = "Home.cfm" addToken="no">  
        </cfif>
        <cfreturn local.result>
    </cffunction>

    <cffunction  name="getContacts" returnType="query">
        <cfargument  name="contactid" default= "#session.username#">
            <cfset local.flag_column = "contactid">
        <cfif arguments.contactid EQ session.username>
            <cfset local.flag_column = "createdBy">
        </cfif>
        <cfquery name = queryGetAllContactsInfo>
            SELECT contactid,
                nametitle,
                firstname,
                lastname,
                gender,
                dateofbirth,
                contactprofile,
                address,
                street,
                district,
                STATE,
                country,
                pincode,
                email,
                mobile
            FROM cfcontactDetails
            WHERE #local.flag_column# = <cfqueryparam value = "#arguments.contactid#" cfsqltype = "cf_sql_varchar">
        </cfquery> 
        
        <!--- <cfquery name="queryGetAllContactsInfo">
            SELECT 
                cd.contactid,
                cd.nametitle,
                cd.firstname,
                cd.lastname,
                cd.gender,
                cd.dateofbirth,
                cd.contactprofile,
                cd.address,
                cd.street,
                cd.district,
                cd.state,
                cd.country,
                cd.pincode,
                cd.email,
                cd.mobile,
                STRING_AGG(r.roleName, ',') AS roleNames
            FROM 
                cfcontactDetails cd
            LEFT JOIN 
                cfrole_contactId rc ON cd.contactid = rc.contactid
            LEFT JOIN 
                cfrole r ON rc.roleid = r.roleid
            WHERE 
                #local.flag_column# = <cfqueryparam value="#arguments.contactid#" cfsqltype="cf_sql_varchar">
            GROUP BY 
                cd.contactid,
                cd.nametitle,
                cd.firstname,
                cd.lastname,
                cd.gender,
                cd.dateofbirth,
                cd.contactprofile,
                cd.address,
                cd.street,
                cd.district,
                cd.state,
                cd.country,
                cd.pincode,
                cd.email,
                cd.mobile
        </cfquery>--->
        <cfreturn queryGetAllContactsInfo>
    </cffunction>
    
    <cffunction  name="saveContact" returnType="any">
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
        <cfargument type="string" required="true" name="contactId">
        <cfargument type="string" required="true" name="mobile">
        <cfargument type="string" required="true" name="role">
        
        <!---<cfset local.roles = ListToArray(arguments.role, ",")> --->

        <cfset local.result = "">
        <!---  SETTING DEFAULT PROFILE PICTURE --->

        <cfif arguments.contactProfile =="">
            <cfif len(trim(arguments.contactId))>
                <cfquery name="queryFetchContactProfile">
                    SELECT contactprofile
                    FROM cfcontactDetails
                    WHERE contactid = <cfqueryparam value = "#arguments.contactId#" cfsqltype="CF_SQL_VARCHAR">
                </cfquery>
                <cfset local.file = queryFetchContactProfile.contactprofile>  <!--- fetching file name --->
            <cfelse>
                <cfset local.file = "user-grey-icon.png">
            </cfif>
        <cfelse>
            <cfset local.path = expandPath("./assets/contactImages/")>   <!--- path declare--->
            <cffile  action="upload" destination = "#local.path#" nameConflict="makeUnique">  <!--- uploading file in specified path--->
            <cfset local.file = cffile.clientFile>  <!--- fetching file name --->
        </cfif>
        <!---     to check unique mobile and email     --->
        <cfif len(trim(arguments.contactId))>
            <!--- querycheckUnique for edit--->
            <cfquery name = "queryCheckUnique">
                SELECT email,mobile,contactid
                FROM cfcontactDetails
                WHERE (email= <cfqueryparam value = "#arguments.email#" cfsqltype = "CF_SQL_VARCHAR" > OR 
                        mobile= <cfqueryparam value = "#arguments.mobile#" cfsqltype = "CF_SQL_VARCHAR" >) AND
                        createdBy = <cfqueryparam value = "#session.userName#" cfsqltype = "CF_SQL_VARCHAR" > AND
                        NOT contactid = <cfqueryparam value = "#arguments.contactId#" cfsqltype = "CF_SQL_VARCHAR">  
            </cfquery>
        <cfelse>
            <cfquery name = "queryCheckUnique">
            <!--- querycheckUnique for create--->
                SELECT email,mobile
                FROM cfcontactDetails
                WHERE (email= <cfqueryparam value = "#arguments.email#" cfsqltype = "CF_SQL_VARCHAR" > OR 
                        mobile= <cfqueryparam value = "#arguments.mobile#" cfsqltype = "CF_SQL_VARCHAR" >) AND
                        createdBy = <cfqueryparam value = "#session.userName#" cfsqltype = "CF_SQL_VARCHAR" >            
            </cfquery>
        </cfif>

        <cfif queryRecordCount(queryCheckUnique) GT 0 OR arguments.email EQ session.emailId>
            <cfset local.result ="mobile number or email already exists">
        <cfelse>
            <!---  if arg has contactid   =>EDIT(UPDATE) --->
            <cfif len(trim(arguments.contactId))>
                <!---    deleting all selected         --->
                <cfquery name = "queryDeleteSelectedRoles">
                    DELETE FROM cfrole_contactId  
                    WHERE contactid = <cfqueryparam value = "#arguments.contactid#" cfsqltype="CF_SQL_VARCHAR">
                </cfquery>
                <!---     Adding all new selected     --->
                <cfloop list="#arguments.role#" index="roleid">
                    <cfquery name="insertRole">
                        INSERT INTO cfrole_contactId (roleId, contactid)
                        VALUES (
                            <cfqueryparam value="#roleid#" cfsqltype="CF_SQL_INTEGER">,
                            <cfqueryparam value = "#arguments.contactid#" cfsqltype="CF_SQL_VARCHAR">
                        )
                    </cfquery>
                </cfloop>

                <cfquery name = "queryInsertEdits">
                    UPDATE cfcontactDetails
                    SET nameTitle = <cfqueryparam value = "#arguments.nameTitle#" cfsqltype = "CF_SQL_VARCHAR">,
                        firstname = <cfqueryparam value = "#arguments.firstname#" cfsqltype = "CF_SQL_VARCHAR">,
                        lastname = <cfqueryparam value = "#arguments.lastname#" cfsqltype = "CF_SQL_VARCHAR">,
                        gender = <cfqueryparam value = "#arguments.gender#" cfsqltype = "CF_SQL_VARCHAR">,
                        dateofbirth = <cfqueryparam value = "#arguments.dob#" cfsqltype = "CF_SQL_VARCHAR">,
                        contactprofile = <cfqueryparam value = "#local.file#" cfsqltype = "CF_SQL_VARCHAR">,
                        address = <cfqueryparam value = "#arguments.address#" cfsqltype = "CF_SQL_VARCHAR">,
                        street = <cfqueryparam value = "#arguments.street#" cfsqltype = "CF_SQL_VARCHAR">,
                        district = <cfqueryparam value = "#arguments.district#" cfsqltype = "CF_SQL_VARCHAR">,
                        STATE = <cfqueryparam value = "#arguments.state#" cfsqltype = "CF_SQL_VARCHAR">,
                        country = <cfqueryparam value = "#arguments.country#" cfsqltype = "CF_SQL_VARCHAR">,
                        pincode = <cfqueryparam value = "#arguments.pincode#" cfsqltype = "CF_SQL_VARCHAR">,
                        email = <cfqueryparam value = "#arguments.email#" cfsqltype = "CF_SQL_VARCHAR">,
                        mobile = <cfqueryparam value = "#arguments.mobile#" cfsqltype = "CF_SQL_VARCHAR">,
                        updatedBy = <cfqueryparam value = "#session.userName#" cfsqltype = "CF_SQL_VARCHAR">,
                        updatedOn = <cfqueryparam value = "#Now()#" cfsqltype = "CF_SQL_TIMESTAMP">
                    WHERE contactid = <cfqueryparam value = "#arguments.contactid#" cfsqltype = "CF_SQL_VARCHAR"> 
                </cfquery>
                <cfset local.result = "contact edited succesfully">
                <!---  =>CREATE NEW CONTACT(INSERT) --->
            <cfelse>
                <cfquery name="queryInsertContact">
                    INSERT INTO cfcontactDetails (
                        nameTitle,
                        firstname,
                        lastname,
                        gender,
                        dateofbirth,
                        contactprofile,
                        address,
                        street,
                        district,
                        STATE,
                        country,
                        pincode,
                        email,
                        mobile,
                        createdBy
                        )
                    VALUES (
                        <cfqueryparam value = "#arguments.nameTitle#" cfsqltype = "CF_SQL_VARCHAR">,
                        <cfqueryparam value = "#arguments.firstname#" cfsqltype = "CF_SQL_VARCHAR">,
                        <cfqueryparam value = "#arguments.lastname#" cfsqltype = "CF_SQL_VARCHAR">,
                        <cfqueryparam value = "#arguments.gender#" cfsqltype = "CF_SQL_VARCHAR">,
                        <cfqueryparam value = "#arguments.dob#" cfsqltype = "CF_SQL_VARCHAR">,
                        <cfqueryparam value = "#local.file#" cfsqltype = "CF_SQL_VARCHAR">,
                        <cfqueryparam value = "#arguments.address#" cfsqltype = "CF_SQL_VARCHAR">,
                        <cfqueryparam value = "#arguments.street#" cfsqltype = "CF_SQL_VARCHAR">,
                        <cfqueryparam value = "#arguments.district#" cfsqltype = "CF_SQL_VARCHAR">,
                        <cfqueryparam value = "#arguments.state#" cfsqltype = "CF_SQL_VARCHAR">,
                        <cfqueryparam value = "#arguments.country#" cfsqltype = "CF_SQL_VARCHAR">,
                        <cfqueryparam value = "#arguments.pincode#" cfsqltype = "CF_SQL_VARCHAR">,
                        <cfqueryparam value = "#arguments.email#" cfsqltype = "CF_SQL_VARCHAR">,
                        <cfqueryparam value = "#arguments.mobile#" cfsqltype = "CF_SQL_VARCHAR">,
                        <cfqueryparam value = "#session.userName#" cfsqltype = "CF_SQL_VARCHAR">
                        )
                </cfquery>
                <cfquery name = getContactId>
                    SELECT contactid
                    FROM cfcontactDetails
                    WHERE email= <cfqueryparam value = "#arguments.email#" cfsqltype = "CF_SQL_VARCHAR"> 
                    AND createdBy =<cfqueryparam value = "#session.userName#" cfsqltype = "CF_SQL_VARCHAR">
                </cfquery>
                <cfif len(trim(arguments.role)) > 
                    <cfloop list="#arguments.role#" index="roleid">
                        <cfquery name="insertRole">
                            INSERT INTO cfrole_contactId (roleId, contactid)
                            VALUES (
                                <cfqueryparam value="#roleid#" cfsqltype="CF_SQL_INTEGER">,
                                <cfqueryparam value="#getContactId.contactId#" cfsqltype="CF_SQL_VARCHAR">
                            )
                        </cfquery>
                    </cfloop>
                </cfif>

                <cfset local.result = "contact created succesfully">
            </cfif>
        </cfif>
        <cfreturn local.result>
    </cffunction>

    <!---  <cffunction  name="fetchContact">
                    <cfquery name="local.queryGetContacts">
                        SELECT contactid
                            ,firstname
                            ,lastname
                            ,contactprofile
                            ,email
                            ,mobile
                        FROM cfcontactDetails
                        WHERE createdBy = <cfqueryparam value = "#session.userName#" cfsqltype = "cf_sql_varchar">
                    </cfquery> 
                    <cfreturn local.queryGetContacts>
                </cffunction> 
    --->

    <cffunction  name="logOut" access="remote">
       <cfset structClear(session)>
    </cffunction>

    <cffunction  name="deleteContact" returnType="boolean" access="remote">
        <cfargument  name="contactid" required ="true">
        <cfquery name= "deleteRoleTablelEntries">
            DELETE FROM cfrole_contactId  
            WHERE contactid = <cfqueryparam value = "#arguments.contactid#" cfsqltype="CF_SQL_VARCHAR">
        </cfquery>
        <cfquery name= "queryDeletePage">
            DELETE FROM cfcontactDetails 
            WHERE contactid = <cfqueryparam value = "#arguments.contactid#" cfsqltype="CF_SQL_VARCHAR">
        </cfquery>

        <cfreturn true>
    </cffunction>

    <cffunction  name="getRoleName" returnType = "query">
        <cfargument  name="contactid" required ="true">
        <cfquery name = queryViewRole>
            SELECT roleName
            FROM cfrole
            JOIN  cfrole_contactId
            ON cfrole.roleId = cfrole_contactId.roleId
            WHERE contactid = <cfqueryparam value = "#arguments.contactid#" cfsqltype="CF_SQL_VARCHAR">
        </cfquery>
        <cfreturn queryViewRole>
    </cffunction>

    <cffunction  name="viewContact" returnType="struct" returnFormat = "json" access="remote"> 
        <cfargument  name = "contactid" required ="true">
        <cfset queryViewPage = getContacts(arguments.contactid)>
        <cfset local.contactDetails = structNew()>

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

        <cfquery name="queryRoleDetails">
            SELECT cfrole.roleName, cfrole.roleId
            FROM cfrole
            JOIN cfrole_contactId
            ON cfrole.roleId = cfrole_contactId.roleId
            WHERE cfrole_contactId.contactId = <cfqueryparam value="#arguments.contactid#" cfsqltype="CF_SQL_VARCHAR">
        </cfquery>

        <cfset local.contactDetails["role"] = "">
        <cfset local.contactDetails["roleIds"] = []>
        <!---Loop to get all rolenames and roleIds--->
 
        <cfloop query="queryRoleDetails">
            <cfif local.contactDetails["role"] NEQ "">
                <cfset local.contactDetails["role"] = local.contactDetails["role"] & ", ">
            </cfif>
            <cfset local.contactDetails["role"] = local.contactDetails["role"] & queryRoleDetails.roleName>
            <cfset ArrayAppend(local.contactDetails["roleIds"] , queryRoleDetails.roleId)>
        </cfloop>

        <cfreturn local.contactDetails>
    </cffunction>

    <cffunction  name="generateExcel" access="remote">
        <!---         <cfset queryForExcel = getContacts()>  --->
         <cfset queryForExcel = getContacts()> 
        <cfset queryAddColumn(queryForExcel, "Roles", "varchar", [])>
        <cfloop query="queryForExcel">
            <cfset rolesForContact = getRoleName(queryForExcel.contactid)>
            <cfset roleNamesArr = arrayNew(1)>
            <cfloop query="rolesForContact">
                <cfset arrayAppend(roleNamesArr, rolesForContact.roleName)>
            </cfloop>
            <cfset queryForExcel.Roles[currentRow] = arrayToList(roleNamesArr, ", ")>
        </cfloop> 
        <cfspreadsheet action="write" filename="../assets/spreadsheets/addressBookcontacts.xlsx" overwrite="true" query="queryForExcel" sheetname="courses"> 
    </cffunction>

    <cffunction  name="generatePdf" access="public">
        <cfreturn getContacts()>
    </cffunction>

    <cffunction  name="mailBdayContacts" returnType = "query">
        <cfset local.month = Month(now())>
        <cfset local.day = Day(now())>
        <cfquery name = "getTodayBirthdays">
            SELECT firstname,
                   lastname,
                   email,
                   createdBy
            FROM cfcontactDetails
            WHERE MONTH(dateofbirth) = <cfqueryparam value = "#local.month#" cfsqltype = "CF_SQL_VARCHAR">
            AND DAY(dateofbirth) = <cfqueryparam value = "#local.day#" cfsqltype = "CF_SQL_VARCHAR">
        </cfquery>
        <cfif getTodayBirthdays.recordcount gt 0>
            <cfloop query="getTodayBirthdays">
                <cfmail to ="#email#" from="gosalram554@gmail.com" subject="Happy Birthday, #firstname#!">
                    Dear #firstname#,
                    Wishing you a very Happy Birthday! 
                    Regards,#createdBy#
                </cfmail>
            </cfloop>
        </cfif>
        <cfreturn getTodayBirthdays>
    </cffunction>

    <cffunction  name="googleSignIn" access="public">
        <cfargument  name="email" type="string" required="true">
        <cfargument  name="fullname" type="string" required="true">
        <cfargument  name="image" type="string" required="true">

        <cfset session.fullName = arguments.fullname>
        <cfset session.username = arguments.email>
        <cfset session.emailId = arguments.email>
        <cfset session.isLoggedIn = true>
        <cfset session.profilePicFromGoogle = arguments.image>
        <cfset local.result = "">
        <cfquery name="queryUniqueUserCheck">
            SELECT COUNT(userName) AS count
            FROM cfuser 
            WHERE userName = <cfqueryparam value = "#arguments.email#" cfsqltype="CF_SQL_VARCHAR">
            AND emailId = <cfqueryparam value="#arguments.email#" cfsqltype="CF_SQL_VARCHAR">
        </cfquery>
        <cfif queryUniqueUserCheck.count>
            <cfset local.result = "user name or mail already exists">
        <cfelse>
            <cfquery name="queryInsert">
                INSERT INTO cfuser(fullName,
                                   emailId,
                                   userName,
                                   profilePic
                                ) 
                VALUES (<cfqueryparam value = "#arguments.fullName#" cfsqltype="CF_SQL_VARCHAR">,
                        <cfqueryparam value = "#arguments.email#" cfsqltype="CF_SQL_VARCHAR">,
                        <cfqueryparam value = "#arguments.email#" cfsqltype="CF_SQL_VARCHAR">,
                        <cfqueryparam value = "#arguments.image#" cfsqltype="CF_SQL_VARCHAR">)
            </cfquery>
            <cfset local.result = "user created successfully">
        </cfif>
        <cflocation url = "Home.cfm" addToken="no"> 
        <cfreturn local.result>
    </cffunction>

</cfcomponent>

