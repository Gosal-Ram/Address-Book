<cfcomponent>

    <cffunction  name="signUp" returnType="string">
        <cfargument  name="fullName" type="string" required="true">
        <cfargument  name="emailId" type="string" required="true">
        <cfargument  name="userName" type="string" required="true">
        <cfargument  name="pwd1" type="string" required="true">
        <cfargument  name="profilePic" type="string" required="true">

        <cfset local.encryptedPass = Hash(#arguments.pwd1#, 'SHA-512')/>
        <cfset local.result = "">
        <cfquery name = "local.queryUniqueUserCheck">
            SELECT COUNT(userName) AS count
            FROM cfuser 
            WHERE userName = <cfqueryparam value = "#arguments.userName#" cfsqltype="CF_SQL_VARCHAR">
            AND emailId = <cfqueryparam value = "#arguments.emailId#" cfsqltype="CF_SQL_VARCHAR">
        </cfquery>
        <cfif local.queryUniqueUserCheck.count>
            <cfset local.result = "user name or mail already exists">
        <cfelse>
            <cfif arguments.profilePic =="">
                <cfset local.imagePath = "user-grey-icon.png">
            <cfelse>
                <cfset local.imagePath = expandPath("./assets/userImages")>
                <cffile action="upload" destination="#local.imagePath#" nameConflict="makeunique">
                <cfset local.imagePath = cffile.clientFile>
            </cfif>
            <cfquery name="local.queryInsert">
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

        <cfquery name ="local.queryUserLogin">
            SELECT userName,
                    pwd,
                    profilePic,
                    fullname,
                    emailId
            FROM cfuser 
            WHERE userName = <cfqueryparam value = "#arguments.userName#" cfsqltype="CF_SQL_VARCHAR">
        </cfquery>

        <cfif local.queryUserLogin.userName == ''>
            <cfset local.result = "User name doesn't exist">
        <cfelseif local.queryUserLogin.pwd NEQ local.encryptedPassFromUser >
            <cfset local.result = "Invalid password">
        <cfelse>
            <cfset session.isLoggedIn = true>
            <cfset session.userName = local.queryUserLogin.userName>
            <cfset session.fullName = local.queryUserLogin.fullname>
            <cfset session.profilePic = local.queryUserLogin.profilePic>
            <cfset session.emailId = local.queryUserLogin.emailId>
            <cflocation  url = "Home.cfm" addToken="no">  
        </cfif>
        <cfreturn local.result>
    </cffunction>

    <cffunction  name="getContacts" returnType="query">
        <cfargument  name="contactid" default= "#session.username#">
        <cfset local.flag_column = "cd.contactid">
        <cfif arguments.contactid EQ session.username>
            <cfset local.flag_column = "createdBy">
        </cfif>
        <cfquery name="local.queryGetAllContactsInfo">
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
                STRING_AGG(cr.roleName, ',') AS roleNames
            FROM 
                cfcontactDetails cd
            LEFT JOIN 
                contact_role_map crm ON cd.contactid = crm.contactid
            LEFT JOIN 
                cfrole cr ON crm.roleid = cr.roleid
            WHERE 
                #local.flag_column# = <cfqueryparam value="#arguments.contactid#" cfsqltype="cf_sql_VARCHAR">
            AND
                activeStatus = <cfqueryparam value="1" cfsqltype="cf_sql_INTEGER">
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
        </cfquery>
        <cfreturn local.queryGetAllContactsInfo>
    </cffunction>

    <cffunction name="insertRole" returnType="void" access="public">
        <cfargument name="roleList" type="string" required="true">
        <cfargument name="contactId" type="integer" required="true">
        
        <cfloop list="#arguments.roleList#" index="roleId">
            <cfquery name="insertRoleQuery">
                INSERT INTO contact_role_map (roleId, contactid)
                VALUES (
                    <cfqueryparam value="#roleId#" cfsqltype="CF_SQL_INTEGER">,
                    <cfqueryparam value="#arguments.contactId#" cfsqltype="CF_SQL_integer">
                )
            </cfquery>
        </cfloop>
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
        
        <cfset local.result = "">
        <!---  SETTING DEFAULT PROFILE PICTURE --->
        <cfif arguments.contactProfile =="">
            <cfif len(trim(arguments.contactId))>
                <cfquery name="local.queryFetchContactProfile">
                    SELECT contactprofile
                    FROM cfcontactDetails
                    WHERE contactid = <cfqueryparam value = "#arguments.contactId#" cfsqltype="CF_SQL_integer">
                </cfquery>
                <cfset local.file = local.queryFetchContactProfile.contactprofile>  
            <cfelse>
                <cfset local.file = "user-grey-icon.png">
            </cfif>
        <cfelse>
            <cfset local.path = expandPath("./assets/contactImages/")> 
            <cffile  action="upload" destination = "#local.path#" nameConflict="makeUnique">  
            <cfset local.file = cffile.clientFile>  
        </cfif>
        <!---     UNIQUE CONTACT CHECK SECTION     --->
        <cfif len(trim(arguments.contactId))>
            <!--- FOR UPDATE--->
            <cfquery name = "local.queryCheckUnique">
                SELECT email,mobile,contactid
                FROM cfcontactDetails
                WHERE (email= <cfqueryparam value = "#arguments.email#" cfsqltype = "CF_SQL_VARCHAR" > OR 
                        mobile= <cfqueryparam value = "#arguments.mobile#" cfsqltype = "CF_SQL_VARCHAR" >) AND
                        createdBy = <cfqueryparam value = "#session.userName#" cfsqltype = "CF_SQL_VARCHAR" > AND
                        NOT contactid = <cfqueryparam value = "#arguments.contactId#" cfsqltype = "CF_SQL_integer">  
            </cfquery>
        <cfelse>
            <cfquery name = "local.queryCheckUnique">
            <!--- FOR CREATE--->
                SELECT email,mobile
                FROM cfcontactDetails
                WHERE (email= <cfqueryparam value = "#arguments.email#" cfsqltype = "CF_SQL_VARCHAR" > OR 
                        mobile= <cfqueryparam value = "#arguments.mobile#" cfsqltype = "CF_SQL_VARCHAR" >) AND
                        createdBy = <cfqueryparam value = "#session.userName#" cfsqltype = "CF_SQL_VARCHAR" >            
            </cfquery>
        </cfif>

        <cfif local.queryCheckUnique.recordcount GT 0 OR arguments.email EQ session.emailId>
            <cfset local.result ="mobile number or email already exists">
        <cfelse>
            <!---IF ARG CONTACTID PASSED   =>EDIT(UPDATE) --->
            <cfif len(trim(arguments.contactId))>
                <!--- UPDATE ROLE SECTION        DELETING ALL SELECTED ROLES      --->
                <cfquery name = "local.queryDeleteSelectedRoles">
                    DELETE FROM contact_role_map  
                    WHERE contactid = <cfqueryparam value = "#arguments.contactid#" cfsqltype="CF_SQL_integer">
                </cfquery>
                <cfset insertRole(arguments.role, arguments.contactid)>  <!---INSERTING NEW SELECTED ROLES --->
                <!--- UPDATE OTHER CONTACT DETAILS SECTION--->
                <cfquery name = "local.queryInsertEdits">
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
                    WHERE contactid = <cfqueryparam value = "#arguments.contactid#" cfsqltype = "CF_SQL_integer"> 
                </cfquery>
                <cfset local.result = "contact edited succesfully">
            <cfelse>
                <!---  =>CREATE NEW CONTACT(INSERT) --->
                <cfquery name="local.queryInsertContact" result = "local.resultInsertContact">
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
                <cfif len(trim(arguments.role)) > 
                    <cfset insertRole(arguments.role, local.resultInsertContact.generatedkey)>
                </cfif>
                <cfset local.result = "contact created succesfully">
            </cfif>
        </cfif>
        <cfreturn local.result>
    </cffunction>

    <cffunction  name="logOut" access="remote">
       <cfset structClear(session)>
    </cffunction>

    <cffunction  name="deleteContact" returnType="boolean" access="remote">
        <cfargument  name="contactid" required ="true">
        <!---         <cfquery name= "local.deleteRoleTablelEntries">
            DELETE FROM contact_role_map  
            WHERE contactid = <cfqueryparam value = "#arguments.contactid#" cfsqltype="CF_SQL_integer">
        </cfquery>
        <cfquery name= "local.queryDeletePage">
            DELETE FROM cfcontactDetails 
            WHERE contactid = <cfqueryparam value = "#arguments.contactid#" cfsqltype="CF_SQL_integer">
        </cfquery> --->
        <cfquery name = "local.updateContactTablelEntries">
            UPDATE cfcontactDetails
            SET activeStatus = 0 , deletedBy =<cfqueryparam value = "#session.userName#" cfsqltype="CF_SQL_VARCHAR">
            WHERE contactid = <cfqueryparam value = "#arguments.contactid#" cfsqltype="CF_SQL_integer">
        </cfquery>
        <cfreturn true>
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
        <cfquery name="local.queryRoleDetails">
            SELECT cfrole.roleName, cfrole.roleId
            FROM cfrole
            JOIN contact_role_map
            ON cfrole.roleId = contact_role_map.roleId
            WHERE contact_role_map.contactId = <cfqueryparam value="#arguments.contactid#" cfsqltype="CF_SQL_integer">
        </cfquery>
        <cfset local.contactDetails["role"] = "">
        <cfset local.contactDetails["roleIds"] = []>
        <!---Loop to get all rolenames and roleIds--->
        <cfloop query="local.queryRoleDetails">
            <cfif local.contactDetails["role"] NEQ "">
                <cfset local.contactDetails["role"] = local.contactDetails["role"] & ", ">
            </cfif>
            <cfset local.contactDetails["role"] = local.contactDetails["role"] & local.queryRoleDetails.roleName>
            <cfset ArrayAppend(local.contactDetails["roleIds"] , local.queryRoleDetails.roleId)>
        </cfloop>

        <cfreturn local.contactDetails>
    </cffunction>

    <cffunction  name="generateExcel" access="remote">
         <cfset local.queryForExcel = getContacts()> 
        <cfspreadsheet action="write" filename="../assets/spreadsheets/addressBookcontacts.xlsx" overwrite="true" query="local.queryForExcel" sheetname="courses"> 
    </cffunction>

    <cffunction  name="generatePdf" access="remote" returnType = "string" returnFormat = "json">
        <cfset local.PdfResult = getContacts()>
        <cfset local.pdfName = "#session.userName#_#DateFormat(Now(), 'mm-dd-yyyy-HH-nn-ss')#">
        <cfdocument format="PDF" filename="../assets/pdfs/#local.pdfName#.pdf" overwrite="yes" pagetype="letter" orientation="portrait">
        
          <h1>Contact Details Report</h1>
          <p>Generated on: #DateFormat(Now(), 'mm/dd/yyyy')#</p>

          <cfif local.PdfResult.recordCount gt 0>
              <table border="1" cellpadding="5" cellspacing="0">
                  <thead>
                      <tr>
                          <th>Title</th>
                          <th>First Name</th>
                          <th>Last Name</th>
                          <th>DOB</th>
                          <th>Address</th>
                          <th>Street</th>
                          <th>District</th>
                          <th>State</th>
                          <th>Country</th>
                          <th>Pincode</th>
                          <th>Email</th>
                          <th>Mobile</th>
                          <th>Roles</th>
                      </tr>
                  </thead>
                  <tbody>
                      <cfloop query="local.PdfResult">
                          <tr>
                          <cfoutput>
                              <td>#nametitle#</td>
                              <td>#firstname#</td>
                              <td>#lastname#</td>
                              <td>#dateofbirth#</td>
                              <td>#address#</td>
                              <td>#street#</td>
                              <td>#district#</td>
                              <td>#state#</td>
                              <td>#country#</td>
                              <td>#pincode#</td>
                              <td>#email#</td>
                              <td>#mobile#</td>
                              <td>#roleNames#</td>
                          </tr>
                          </cfoutput>
                      </cfloop>
                  </tbody>
              </table>
          <cfelse>
              <p>No contacts found for the current user.</p>
          </cfif>
        </cfdocument>
        <cfreturn local.pdfName>
    </cffunction>

    <cffunction  name="mailBdayContacts" returnType = "query">
        <cfset local.month = Month(now())>
        <cfset local.day = Day(now())>
        <cfquery name = "local.getTodayBirthdays">
            SELECT firstname,
                   lastname,
                   email,
                   createdBy
            FROM cfcontactDetails
            WHERE MONTH(dateofbirth) = <cfqueryparam value = "#local.month#" cfsqltype = "CF_SQL_VARCHAR">
            AND DAY(dateofbirth) = <cfqueryparam value = "#local.day#" cfsqltype = "CF_SQL_VARCHAR">
        </cfquery>
        <cfif local.getTodayBirthdays.recordcount gt 0>
            <cfloop query="local.getTodayBirthdays">
                <cfmail to ="#email#" from="gosalram554@gmail.com" subject="Happy Birthday, #firstname#!">
                    Dear #firstname#,
                    Wishing you a very Happy Birthday! 
                    Regards,#createdBy#
                </cfmail>
            </cfloop>
        </cfif>
        <cfreturn local.getTodayBirthdays>
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
        <cfquery name="local.queryUniqueUserCheck">
            SELECT COUNT(userName) AS count
            FROM cfuser 
            WHERE userName = <cfqueryparam value = "#arguments.email#" cfsqltype="CF_SQL_VARCHAR">
            AND emailId = <cfqueryparam value="#arguments.email#" cfsqltype="CF_SQL_VARCHAR">
        </cfquery>
        <cfif local.queryUniqueUserCheck.count>
            <cfset local.result = "user name or mail already exists">
        <cfelse>
            <cfquery name="local.queryInsert">
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

    <cffunction  name="getRoleNameAndRoleId" access="public" returnType = "query">
         <cfquery name="local.queryRoleDetails">
            SELECT roleName,roleId
            FROM cfrole
        </cfquery>
        <cfreturn local.queryRoleDetails>
    </cffunction>

</cfcomponent>