function createContact(event){
    
    document.getElementById("contactId").value = ""
    $(".modalTitle").text("CREATE CONTACT");
    document.getElementById("contactform").reset();
    document.getElementById("contactProfileEdit").src ="./assets/images/user-grey-icon.png";
}

function editContact(contactid) {
    document.getElementById("contactId").value = contactid
    $(".modalTitle").text("EDIT CONTACT");
    $.ajax({
        type:"POST",
        url: "component/addressBook.cfc?method=viewContact",
        data:{contactid: contactid},
        success:function(contactDetails){
            let formattedContactDetails = JSON.parse(contactDetails)
            document.getElementById("nameTitle").value = formattedContactDetails.nametitle;
            document.getElementById("firstName").value = formattedContactDetails.firstname;
            document.getElementById("lastName").value = formattedContactDetails.lastname;
            document.getElementById("gender").value = formattedContactDetails.gender;
            const editedDob = formattedContactDetails.dateofbirth.replace(",", "");   // removing comma
            const dob = new Date(editedDob);
            const year = dob.getFullYear();
            let month = dob.getMonth()+1;
            if (month < 10) month = '0' + month;
            let day = dob.getDate();
            if (day < 10) day = '0' + day;
            document.getElementById("dob").value = year + "-"+ month +"-" +day 
            document.getElementById("address").value = formattedContactDetails.address;
            document.getElementById("street").value = formattedContactDetails.street;
            document.getElementById("district").value = formattedContactDetails.district;
            document.getElementById("state").value = formattedContactDetails.state;
            document.getElementById("country").value = formattedContactDetails.country;
            document.getElementById("pincode").value = formattedContactDetails.pincode;
            document.getElementById("email").value = formattedContactDetails.email;
            document.getElementById("mobile").value = formattedContactDetails.mobile;
            document.getElementById("contactProfileEdit").src = "./assets/contactImages/"+formattedContactDetails.contactprofile;
            $("#role").val( formattedContactDetails.roleIds);

        }
    })
}

function logOut(){

    if(confirm("Confirm logout")){
        $.ajax({
            type:"POST",
            url: "component/addressBook.cfc?method=logOut",
            success:function(){
              //window.location.href = "Login.cfm"
              location.reload();
            }
        })
    }
} 

function deleteContact(contactid){
    // var choice= confirm("Confirm delete")
    // console.log(choice);
    if(confirm("Confirm delete")){
        $.ajax({
            type:"POST",
            url: "component/addressBook.cfc?method=deleteContact",
            data:{contactid: contactid},
            success:function(){
                // location.reload();  
                document.getElementById(contactid).remove()  
            }
        })
    }
}

function viewContact(contactid){
    $.ajax({
        type:"POST",
        url: "component/addressBook.cfc?method=viewContact",
        data:{contactid: contactid},
        success:function(contactDetails){
            let formattedContactDetails = JSON.parse(contactDetails)
            document.getElementById("fullNameView").textContent = `${formattedContactDetails.nametitle} ${formattedContactDetails.firstname} ${formattedContactDetails.lastname} ` 
            document.getElementById("genderView").textContent = formattedContactDetails.gender;
            document.getElementById("dobView").textContent = formattedContactDetails.dateofbirth.split(" ",3).join(" ");  
            document.getElementById("addressView").textContent = formattedContactDetails.address +" ,"+formattedContactDetails.street+" ,"+formattedContactDetails.district+" ,"+formattedContactDetails.state+" ,"+formattedContactDetails.country;
            document.getElementById("pincodeView").textContent = formattedContactDetails.pincode;
            document.getElementById("emailView").textContent = formattedContactDetails.email;
            document.getElementById("mobileView").textContent = formattedContactDetails.mobile;
            document.getElementById("roleView").textContent = formattedContactDetails.role;
            document.getElementById("conatctProfileView").src = "./assets/contactImages/"+formattedContactDetails.contactprofile;        
            // console.log(formattedRoleNames)
            // console.log(formattedContactDetails);
        }
    })
}

function loginValidate(){

    let userName = document.getElementById("userName").value;
    let pwd = document.getElementById("pwd").value;
    let userNameError = document.getElementById("userNameError");
    let pwdError = document.getElementById("pwdError");
    userNameError.textContent = "";
    pwdError.textContent = "";
    let isValid = true;
    if(userName == ''){
        userNameError.textContent = "Enter a valid user name";
        isValid = false;
    }
    if(pwd == ''){
        pwdError.textContent = "Enter your password";
        isValid = false;
    }
    return isValid;
}

function signInValidate(){
    let fullName = document.getElementById("fullName").value;
    let emailId = document.getElementById("emailId").value;
    let userName = document.getElementById("userName").value;
    let pwd1 = document.getElementById("pwd1").value;
    let pwd2 = document.getElementById("pwd2").value;
    // let profilePic = document.getElementById("profilePic").value;
    let fullNameError = document.getElementById("fullNameError");
    let emailIdError  = document.getElementById("emailIdError");
    let userNameError = document.getElementById("userNameError");
    let pwd1Error = document.getElementById("pwd1Error");
    let pwd2Error = document.getElementById("pwd2Error");
    let profilePicError = document.getElementById("profilePicError");
    fullNameError.textContent = "";
    emailIdError.textContent = "";
    userNameError.textContent = "";
    pwd1Error.textContent = "";
    pwd2Error.textContent = "";
    profilePicError.textContent = "";
    let isValid = true;
    let emailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
    let passCheck = /^(?=.*\d)(?=.*[a-zA-Z])[a-zA-Z0-9!@#$%&*]{6,20}$/;

    if(fullName == ""){
        fullNameError.textContent = "Enter a valid Name";
        isValid = false;
    }
    if(emailId == "" || !emailRegex.test(emailId)){
        emailIdError.textContent = "Enter  a valid Email";
        isValid = false;
    }
    if(userName == ""){
        userNameError.textContent = "Enter a valid Username";
        isValid = false;
    }
    if(pwd1 == "" || !passCheck.test(pwd1)){
        pwd1Error.textContent = "Enter a Strong password";
        isValid = false;
    }
    if(pwd2 !== pwd1 || pwd2 == ""){
        pwd2Error.textContent = "password doesn't match";
        isValid = false;
    }
    return isValid
}

function modalValidate() {

    let isValid = true;
    let nameTitle = document.getElementById("nameTitle").value;
    let firstName = document.getElementById("firstName").value.trim();
    let lastName = document.getElementById("lastName").value.trim();
    let gender = document.getElementById("gender").value;
    let dob = document.getElementById("dob").value;
    let address = document.getElementById("address").value.trim();
    let street = document.getElementById("street").value.trim();
    let district = document.getElementById("district").value.trim();
    let state = document.getElementById("state").value.trim();
    let country = document.getElementById("country").value.trim();
    let pincode = document.getElementById("pincode").value.trim();
    let email = document.getElementById("email").value.trim();
    let mobile = document.getElementById("mobile").value.trim();
    let role = document.getElementById("role").value;

    let nameTitleError = document.getElementById("nameTitleError");
    let firstNameError = document.getElementById("firstNameError");
    let lastNameError = document.getElementById("lastNameError");
    let genderError = document.getElementById("genderError");
    let dobError = document.getElementById("dobError");
    let addressError = document.getElementById("addressError");
    let streetError = document.getElementById("streetError");
    let districtError = document.getElementById("districtError");
    let stateError = document.getElementById("stateError");
    let countryError = document.getElementById("countryError");
    let pincodeError = document.getElementById("pincodeError");
    let emailError = document.getElementById("emailError");
    let mobileError = document.getElementById("mobileError");
    let roleError = document.getElementById("roleError");
    
    nameTitleError.textContent = "";
    firstNameError.textContent = "";
    lastNameError.textContent = "";
    genderError.textContent = "";
    dobError.textContent = "";
    addressError.textContent = "";
    streetError.textContent = "";
    districtError.textContent = "";
    stateError.textContent = "";
    countryError.textContent = "";
    pincodeError.textContent = "";
    emailError.textContent = "";
    mobileError.textContent = "";
    roleError.textContent = "";
    

    const emailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
    const phoneRegex = /^[0-9]{10}$/;
    const pincodeRegex = /^[0-9]{6}$/;
    
    if (nameTitle === "") {
        nameTitleError.textContent = "Title is required.";
        isValid = false;
    }
    
    if (firstName === "") {
        firstNameError.textContent = "First Name is required.";
        isValid = false;
    }
    
    if (lastName === "") {
        lastNameError.textContent = "Last Name is required.";
        isValid = false;
    }
    
    if (gender === "") {
        genderError.textContent = "Gender is required.";
        isValid = false;
    }
    
    if (dob === "") {
        dobError.textContent = "Date of Birth is required.";
        isValid = false;
    }
    
    if (address === "") {
        addressError.textContent = "Address is required.";
        isValid = false;
    }
    
    if (street === "") {
        streetError.textContent = "Please provide the required street";
        isValid = false;
    }
    
    if (district === "") {
        districtError.textContent = "District is required.";
        isValid = false;
    }
    
    if (state === "") {
        stateError.textContent = "Please provide the required state";
        isValid = false;
    }
    
    if (country === "") {
        countryError.textContent = "Country is required.";
        isValid = false;
    }
    if (role === "") {
        roleError.textContent = "Role is required.";
        isValid = false;
    }
    
    if (!pincodeRegex.test(pincode)) {
        pincodeError.textContent = "Valid 6-digit Pincode is required.";
        isValid = false;
    }
    
    if (!emailRegex.test(email)) {
        emailError.textContent = "Valid Email is required.";
        isValid = false;
    }
    
    if (!phoneRegex.test(mobile)) {
        mobileError.textContent = "Valid Phone Number is required.";
        isValid = false;
    }
    
    return isValid;
}

function triggerPdf() {
    $.ajax({
        type:"POST",
        url: "component/addressBook.cfc?method=generatePdf",
        success:function(pdfName){
            let newPdfName= JSON.parse(pdfName);
    const link = document.createElement("a");
    link.href = `assets/pdfs/${newPdfName}.pdf`; 
    link.download = newPdfName; 
    document.body.appendChild(link); 
    link.click();
    document.body.removeChild(link);
    }})
  }
  
function exportPrint(){
    // alert("hel")
    $(".btnHide").hide();
    var content= document.getElementById("homeRightFlex").innerHTML
    var fullPage = document.body.innerHTML;
    document.body.innerHTML = content;
    window.print();
    document.body.innerHTML = fullPage;
   
}

function exportExcel() {
    // alert("hel")
    $.ajax({
        method: "POST",
        url: "component/addressBook.cfc?method=generateExcel",
    });
}

