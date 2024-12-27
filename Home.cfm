<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Home</title>
    <link rel="stylesheet" href="bootstrap-5.0.2-dist/bootstrap-5.0.2-dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="./assets/css/style.css">
    <link href="assets/images/favicon.png" rel="icon">
    <script src="bootstrap-5.0.2-dist/bootstrap-5.0.2-dist/js/bootstrap.min.js"></script>
</head>
<body>
  <cfoutput>
    <cfset currentDate = DateFormat(Now(), "yyyy-mm-dd")>
    <cfif structKeyExists(session, "isLoggedIn")>
        <header class="d-flex p-1 align-items-center">
            <div class="nameTxtContainer ms-4">
                <img src="./assets/images/contact-book.png" alt="" width="45" height="45">
                <a href = "Home.cfm" class = "titleLink text-light"
                  <span class="headerHeadingName">ADDRESS BOOK</span>    
                </a>
            </div>
            <div class="ms-auto d-flex me-5">
                <div class="loginCont">
                  <a class="btn text-light" onClick="return logOut()"> 
                    <img src="./assets/images/exit.png" alt="" width="18" height="18">
                    Logout
                  </a>
                </div>
            </div>
        </header>
        
        <main class="mx-auto homeMain">
          <div class="homeTopContainer bg-light my-2 p-3 px-5 rounded">
            <div>
              <cfif structKeyExists(form, "modalSubmitBtn")>  
                  <cfset result = application.obj.saveContact(
                    nameTitle =  form.nameTitle,
                    firstName = form.firstName,
                    lastName = form.lastName,
                    gender = form.gender,
                    dob = form.dob,
                    contactProfile = form.contactProfile,
                    address = form.address,
                    street = form.street,
                    district = form.district,
                    state = form.state,
                    country = form.country,
                    pincode = form.pincode,
                    email = form.email,
                    mobile = form.mobile,
                    contactId = form.contactId,
                    role = form.role
                    )>
                  <span class="text-success fw-bold ms-5 fs-6">#result#</span>                
              </cfif>
            </div>
            <div class="homeTopImgCont d-flex justify-content-end ">
              <button type="button" name="exportPdfBtn" class="pdfBtn" onclick="triggerPdf()" id="downloadPdfBtn"><img class="me-2" src="./assets/images/pdf-icon.png" alt="" width="30" height="30"></button>
              <a href="" onclick="exportExcel()"><img class="ms-2" src="./assets/images/excel-icon.png" alt="" width="30" height="30"></a>
              <a href="" onclick="exportPrint()"><img class="ms-3" src="./assets/images/printer-icon.png" alt="" width="30" height="30"></a>
            </div>
          </div>
          <div class="homeMainContainer d-flex my-2">
            <div class="homeLeftFlex me-2 bg-light d-flex flex-column align-items-center p-3">
              <cfif structKeyExists(session, "profilePicFromGoogle")>
                <img src = "#session.profilePicFromGoogle#" alt="userProfilePic" width="100" height="100">
              <cfelse>
                <img src = "./assets/userImages/#session.profilePic#" alt="user profile picture" width="100" height="100">
              </cfif>
              <h5 class="fullNameTxt mt-2">#session.fullName#</h5>
              <button type="button" class="createBtn" data-bs-toggle="modal" data-bs-target="##editBtn" onclick ="createContact(event)">CREATE CONTACT</button>
              <button type="button" class="createBtn" data-bs-toggle="modal" data-bs-target="##uploadBtn">UPLOAD CONTACT</button>
            </div>
            <div class="homeRightFlex bg-light" id="homeRightFlex">
              <table class="table align-middle table-hover table-borderless">
                  <thead>
                    <tr class="border-bottom tableHeading">
                      <th scope="col"></th>
                      <th scope="col">Name</th>
                      <th scope="col">Email id</th>
                      <th scope="col">Phone number</th>
                      <th scope="col"></th>
                      <th scope="col"></th>
                      <th scope="col"></th>
                    </tr>
                  </thead>
                  <tbody>
                  <cfset ormReload()>
                  <cfset ormFetchContact = entityLoad("addressBookOrm" ,{createdBy = "#session.username#",activeStatus = 1})> 
                  <cfloop array ="#ormFetchContact#" item="item">
                    <tr id ="#item.getcontactid()#">
                      <th scope="row"><img src="./assets/contactImages/#item.getcontactprofile()#" alt="contactProfile" width="50" height="50"></th>
                      <td>#item.getfirstname()# #item.getlastname()#</td>
                      <td>#item.getemail()#</td>
                      <td>#item.getmobile()#</td>
                      <td><button type="button" class="btnHide" data-bs-toggle="modal" data-bs-target="##editBtn" onclick = "editContact('#item.getcontactid()#')">EDIT</button></td>
                      <td><button type="button" class="btnHide" onClick="deleteContact('#item.getcontactid()#')">DELETE</button></td>
                      <td><button type="button" class="btnHide" data-bs-toggle="modal" data-bs-target="##viewBtn" onClick="viewContact('#item.getcontactid()#')">VIEW</button></td>
                    </tr>
                  </cfloop>
                  </tbody>
              </table>
            </div>
          </div>
        </main>

        <!-- edit modal -->
        <form method="POST" enctype="multipart/form-data" id="contactform" onsubmit="return modalValidate()">
          <div class="modal fade" id="editBtn" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
            <div class="modal-dialog">
              <div class="modal-content">
                <div class="modal-body d-flex">
                    <div class="modalLeftFlex bg-light">
                        <div class="modalLeftFlexCont">
                          <div class="modalTitle">
                              EDIT CONTACT
                          </div>
                          <h3 class="modalTiltle2">Personal Contact</h3>
                            <div class="d-flex justify-content-between">
                              <label class="modalLabelSelect">Title*</label>
                              <label class="modalLabel">First Name*</label>
                              <label class="modalLabel">Last Name*</label>
                            </div>
                            <div class="d-flex justify-content-between">
                              <select class="modalInputSelect" name="nameTitle" id="nameTitle">
                                <option></option>
                                <option>Mr.</option>
                                <option>Ms.</option>
                              </select>
                              <input type="text" name="firstName" id="firstName" value="" placeholder="first name" class="modalInput">
                              <input type="text" name="lastName" id="lastName" value="" placeholder="last name" class="modalInput">
                            </div>
                            <div class="d-flex justify-content-between">
                              <div id = "nameTitleError" class="text-danger fw-bold"></div>
                              <div id="firstNameError" class="text-danger fw-bold"></div>
                              <div id="lastNameError" class="text-danger fw-bold"></div>
                            </div>
                            <div class="d-flex justify-content-center">
                              <label class="modalLabelFor2">Gender*</label>
                              <label class="modalLabelFor2">Date Of Birth*</label>
                            </div>
                            <div class="d-flex justify-content-between">
                              <select class="modalInputSelect" name="gender" id="gender" >
                                <option>Male</option>
                                <option>Female</option>
                              </select>
                              <input type="date" name="dob" id="dob" value=""  max="#currentDate#" class="modalInputFor2">
                            </div>
                            <div class="d-flex justify-content-between">
                              <div id="genderError" class="text-danger fw-bold"></div>
                              <div id="dobError" class="text-danger fw-bold"></div>
                            </div>
                              <div class="d-flex flex-column">
                                <label class="modalLabelFor1">Upload Photo</label>
                                <input type="file" name="contactProfile" id="contactProfile" value="" class="modalInputFor1">
                              </div>                          
                              <div class="d-flex flex-column">
                                <label class="modalLabelForEven2">Role*</label>
                                <select name="role" id="role" multiple class="modalInputForEven2 " multiple >
                                <cfset getOptions = application.obj.getRoleNameAndRoleId()>
                                <cfloop query="getOptions">
                                  <option value="#getOptions.roleId#">#getOptions.roleName#</option>
                                </cfloop>
                                </select> 
                              </div>
                              <div class="d-flex justify-content-between">
                                <div id="roleError" class="text-danger fw-bold"></div>
                              </div>
                            <h3 class="modalTiltle2">Contact Details</h3>
                            <div class="d-flex justify-content-center">
                              <label class="modalLabelForEven2">Address*</label>
                              <label class="modalLabelForEven2">Street*</label>
                            </div>
                            <div class="d-flex justify-content-between">
                              <input type="text" name="address" id="address" value="" class="modalInputForEven2">
                              <input type="text" name="street" id="street" value="" class="modalInputForEven2">
                            </div>
                            <div class="d-flex justify-content-between">
                              <div id="addressError" class="text-danger fw-bold"></div>
                              <div id="streetError" class="text-danger fw-bold"></div>
                            </div>
                            <div class="d-flex justify-content-center">
                              <label class="modalLabelForEven2">District*</label>
                              <label class="modalLabelForEven2">State*</label>
                            </div>
                            <div class="d-flex justify-content-between">
                              <input type="text" name="district" id="district" value="" class="modalInputForEven2">
                              <input type="text" name="state" id="state" value="" class="modalInputForEven2">
                            </div>
                            <div class="d-flex justify-content-between">
                              <div id="districtError" class="text-danger fw-bold"></div>
                              <div id="stateError" class="text-danger fw-bold"></div>
                            </div>
                            <div class="d-flex justify-content-center">
                              <label class="modalLabelForEven2">Country*</label>
                              <label class="modalLabelForEven2">Pincode*</label>
                            </div>
                            <div class="d-flex justify-content-between">
                              <input type="text" name="country" id="country" value="" class="modalInputForEven2">
                              <input type="text" name="pincode" id="pincode"  maxLength = "6" value="" class="modalInputForEven2">
                            </div>
                            <div class="d-flex justify-content-between">
                              <div id="countryError" class="text-danger fw-bold"></div>
                              <div id="pincodeError" class="text-danger fw-bold"></div>
                            </div>
                            <div class="d-flex justify-content-center">
                              <label class="modalLabelForEven2">Email*</label>
                              <label class="modalLabelForEven2">Phone*</label>
                            </div>
                            <div class="d-flex justify-content-between">
                              <input type="email" name="email" id="email" value="" class="modalInputForEven2">
                              <input type="text" name="mobile" id="mobile" value="" maxLength = "10" class="modalInputForEven2">
                              <input type="hidden" name="contactId" id="contactId" value="" class="">
                            </div>
                            <div class="d-flex justify-content-between">
                              <div id="emailError" class="text-danger fw-bold"></div>
                              <div id="mobileError" class="text-danger fw-bold"></div>
                            </div>
                        </div>
                    </div>
                    <div class="modalRightFlex">
                        <div class="mt-5 ms-5 bg-light">
                          <img id="contactProfileEdit" src="./assets/images/user-grey-icon.png" alt="" width="100" height="100">
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                  <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                  <button type="submit" name="modalSubmitBtn" class="btn btn-primary">Save Changes</button>
                </div>
              </div>
            </div>
          </div>
        </form>

        <!-- view modal -->
        <div class="modal fade" id="viewBtn" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
            <div class="modal-dialog">
              <div class="modal-content">
                <div class="modal-body d-flex">
                    <div class="modalLeftFlex bg-light">
                      <div class="modalLeftFlexCont ">
                        <div class="modalTitle">
                          CONTACT DETAILS
                        </div>
                        <div class="d-flex">
                          <div class="viewLabel">Name</div>
                          <div class="viewColon">:</div>
                          <div class="viewData" id="fullNameView"></div>
                        </div>
                        <div class="d-flex">
                          <div class="viewLabel">Gender</div>
                          <div class="viewColon">:</div>
                          <div class="viewData" id="genderView"></div>
                        </div>
                        <div class="d-flex">
                          <div class="viewLabel">DOB</div>
                          <div class="viewColon">:</div>
                          <div class="viewData" id="dobView"></div>
                        </div>
                        <div class="d-flex">
                          <div class="viewLabel">Address</div>
                          <div class="viewColon">:</div>
                          <div class="viewData" id="addressView"></div>
                        </div>
                        <div class="d-flex">
                          <div class="viewLabel">Pincode</div>
                          <div class="viewColon">:</div>
                          <div class="viewData" id="pincodeView"></div>
                        </div>
                        <div class="d-flex">
                          <div class="viewLabel">Email Id</div>
                          <div class="viewColon">:</div>
                          <div class="viewData" id="emailView"></div>
                        </div>
                        <div class="d-flex">
                          <div class="viewLabel">Phone</div>
                          <div class="viewColon">:</div>
                          <div class="viewData" id="mobileView"></div>
                        </div>
                        <div class="d-flex">
                          <div class="viewLabel">Role</div>
                          <div class="viewColon">:</div>
                          <div class="viewData" id="roleView"></div>
                        </div>
                        <div class="d-flex justify-content-center mt-3">
                          <button type="button" class="btn createBtn" data-bs-dismiss="modal">Close</button>
                        </div>
                      </div>
                    </div>
                    <div class="modalRightFlex">
                      <div class="mt-5 ms-5 bg-light">
                        <img id="conatctProfileView" src="./assets/images/user-grey-icon.png" alt="" width="100" height="100">
                      </div>
                    </div>
                </div>
              </div>
            </div>
        </div>

        <!-- Upload Modal -->
        <div class="modal fade" id="uploadBtn" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h1 class="modal-title fs-5" id="staticBackdropLabel">Upload Excel File</h1>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <form method = "POST" enctype="multipart/form-data">
                          <div class="mb-3">
                            <label for="uploadExcel" class="form-label">Upload Excel*</label>
                            <input type="file" class="form-control" id="uploadedExcelFile" name="uploadExcel" accept=".xlsx, .xls" required>
                          </div>
                          <div class= "d-flex justify-content-start mt-4 text-danger fw-bold" id = "uploadExcelError"></div>
                          <div class="d-flex justify-content-end">
                              <button type = "button" onclick = "dataTempDownload()" id="downloadWithData" class="btn btn-primary me-2">Template with Data</button>
                              <button type = "button" id="downloadPlainTemplate" onclick ="plainTempDownload()" class="btn btn-secondary">Plain Template</button>
                          </div>
                    </div>
                    <div class="modal-footer d-flex justify-content-end">
                      <div>
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                        <button type="button" name="uploadSubmitBtn" onclick="uploadExcelFile()" class="btn btn-primary">Submit</button>
                        </form>
                      </div>
                    </div>
                </div>
            </div>
        </div>
    </cfif>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js" integrity="sha512-v2CJ7UaYy4JwqLDIrZUI/4hqeoQieOmAZNXBeQyjo21dadnwR+8ZaIJVT8EE2iyI61OV8e6M8PP2/4hpQINQ/g==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
    <script src="./assets/js/script.js"></script>
   
  </cfoutput>
</body>
</html>
