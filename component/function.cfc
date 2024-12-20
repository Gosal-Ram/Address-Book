<cffunction name="retrieveExcelData">
    <cfargument name="uploadedData"> 
    <cfset local.resultColValues = []>
    <cfset local.file = "user-grey-icon.png">
    <cfset local.roleQuery = getRoleNameAndRoleId()>
    <cfset local.columnValues = valueList(local.roleQuery.roleName)>
    <cfset local.roleIdList = "">

    <cfloop query="#arguments.uploadedData#">
        <cfset local.validationErrors = []>

        <!--- CHECK FOR MISSING FIELDS --->
        <cfloop list="#arguments.uploadedData.columnlist#" index="columnName">
            <cfset local.currentValue = arguments.uploadedData[columnName][arguments.uploadedData.currentRow]>
            <cfif trim(local.currentValue) EQ "" OR isNull(local.currentValue)>
                <cfset arrayAppend(local.validationErrors, columnName & " missing")>
            </cfif>
        </cfloop>

        <!--- ADDITIONAL VALIDATIONS --->
        <cfif arrayLen(local.validationErrors) EQ 0>
            <!--- Validate Title --->
            <cfif NOT listFindNoCase("Mr.,Ms.", arguments.uploadedData.nameTitle)>
                <cfset arrayAppend(local.validationErrors, "Invalid Title (must be Mr. or Ms.)")>
            </cfif>

            <!--- Validate Date of Birth --->
            <cfif NOT isDate(arguments.uploadedData.dateofbirth) OR createDateTime(arguments.uploadedData.dateofbirth) GT Now()>
                <cfset arrayAppend(local.validationErrors, "Invalid Date of Birth (must not be in the future)")>
            </cfif>

            <!--- Validate Pincode --->
            <cfif len(trim(arguments.uploadedData.pincode)) NEQ 6 OR NOT isNumeric(arguments.uploadedData.pincode)>
                <cfset arrayAppend(local.validationErrors, "Invalid Pincode (must be 6 digits)")>
            </cfif>

            <!--- Validate Phone Number --->
            <cfif len(trim(arguments.uploadedData.mobile)) NEQ 10 OR NOT isNumeric(arguments.uploadedData.mobile)>
                <cfset arrayAppend(local.validationErrors, "Invalid Mobile Number (must be 10 digits)")>
            </cfif>

            <!--- Validate Email --->
            <cfif NOT isValid("email", arguments.uploadedData.email)>
                <cfset arrayAppend(local.validationErrors, "Invalid Email Address")>
            </cfif>

            <!--- Validate Roles --->
            <cfif len(trim(arguments.uploadedData.role))>
                <cfset local.roles = arguments.uploadedData.role.toString()>
                <cfloop list="#local.roles#" index="roleName" delimiters=",">
                    <cfif listFind(local.columnValues, roleName) EQ 0>
                        <cfset arrayAppend(local.validationErrors, "Invalid Role: " & roleName)>
                        <!--- Exit role validation once one invalid role is found --->
                        <cfexit method="loop">
                    </cfif>
                </cfloop>
            </cfif>
        </cfif>

        <!--- If Validation Errors Exist --->
        <cfif arrayLen(local.validationErrors) GT 0>
            <cfset arrayAppend(local.resultColValues, arrayToList(local.validationErrors))>
        <cfelse>
            <!--- Proceed to Update or Insert --->
            <cfquery name="local.queryCheckUnique">
                SELECT email
                FROM cfcontactDetails
                WHERE email = <cfqueryparam value="#arguments.uploadedData.EMAIL#" cfsqltype="CF_SQL_VARCHAR">
                AND activeStatus = <cfqueryparam value="1" cfsqltype="CF_SQL_INTEGER">
                AND createdBy = <cfqueryparam value="#session.userName#" cfsqltype="CF_SQL_VARCHAR">
            </cfquery>

            <cfif local.queryCheckUnique.recordcount GT 0>
                <!--- UPDATE QUERY (Insert Update Code from Original) --->
                <cfset arrayAppend(local.resultColValues, "UPDATED")>
            <cfelse>
                <!--- INSERT QUERY (Insert Insert Code from Original) --->
                <cfset arrayAppend(local.resultColValues, "INSERTED")>
            </cfif>
        </cfif>
    </cfloop>

    <!--- Append Results Column to Data --->
    <cfset queryAddColumn(arguments.uploadedData, "Results", local.resultColValues)>
    <cfreturn arguments.uploadedData>
</cffunction>
<!--- Validate Roles --->
<cfif len(trim(arguments.uploadedData.role))>
    <cfset local.roles = arguments.uploadedData.role.toString()>
    <cfset local.roleIdList = ""> <!-- Initialize the list -->
    <cfset local.validRoles = true> <!-- Flag for invalid roles -->
    
    <cfloop list="#local.roles#" index="roleName" delimiters=",">
        <cfif listFind(local.columnValues, roleName)>
            <!-- Add roleId to the list if roleName is valid -->
            <cfloop query="local.roleQuery">
                <cfif roleName EQ local.roleQuery.roleName>
                    <cfset local.roleIdList = listAppend(local.roleIdList, local.roleQuery.roleId)>
                </cfif>
            </cfloop>
        <cfelse>
            <!-- Mark as invalid and add error -->
            <cfset local.validRoles = false>
            <cfset arrayAppend(local.validationErrors, "Invalid Role: " & roleName)>
            <!-- No need to validate further roles -->
            <cfbreak>
        </cfif>
    </cfloop>

    <!-- If invalid roles exist, clear the roleIdList to avoid accidental insertion -->
    <cfif NOT local.validRoles>
        <cfset local.roleIdList = "">
    </cfif>
</cfif>
