<cflogin>
    <cfoauth
        type="google"
        clientid=""
        secretkey=""
        result="result"                  
        scope="email">
</cflogin>           
<cfif structKeyExists(result, "access_token")>

    <cfdump var = "#result#">
    <cfset local.email  = result.other.email>
    <cfset local.fullname  = result.name>
    <cfset local.image = result.other.picture>
    <cfset googleSignInResult = application.obj.googleSignIn(local.email, local.fullname,local.image)>
    <cfdump  var = "#googleSignInResult#">
<cfelse>
    <cfoutput>Authorization failed or access token missing.</cfoutput>
</cfif>