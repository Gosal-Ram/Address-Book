<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Address Book Home Page</title>
    <link rel="stylesheet" href="../../../bootstrap-5.0.2-dist/bootstrap-5.0.2-dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="./assets/css/style.css">
    <script src="../../bootstrap-5.0.2-dist/bootstrap-5.0.2-dist/js/bootstrap.min.js"></script>
</head>
<body>
  <cfoutput>
   <cfif structKeyExists(session, "isLoggedIn")>
      <header class="d-flex p-1 align-items-center">
          <div class="nameTxtContainer ms-4">
              <img src="./assets/images/contact-book.png" alt="" width="45" height="45">
              <span class="headerHeadingName">ADDRESS BOOK</span>    
          </div>
          <div class="ms-auto d-flex me-5">
              <div class="loginCont">
                  <img src="./assets/images/exit.png" alt="" width="18" height="18">
                  <a class="btn text-light" onClick="return logOut()">Logout</a>
              </div>
          </div>
      </header>
      <main class="mx-auto homeMain">
          <div class="homeTopContainer bg-light my-2 p-3 px-5 rounded">
                <div>
                  <cfif structKeyExists(form, "submitBtn")>  
                      <cfset local.value = createObject("component","component.index")>
                      <cfset local.result = local.value.createContact(form.nameTitle,form.firstName,form.lastName,form.gender,form.dob,form.contactProfile,
                      form.address,form.street,form.district,form.state,form.country,form.pincode,form.email,form.mobile)>
                      <span class="text-success fw-bold ms-5 fs-6">#local.result#</span>                
                  </cfif>
                </div>
              <div class="homeTopImgCont d-flex justify-content-end ">
                  <form name="create Pdf " method="POST" >
                      <button type="submit" name="exportPdfBtn" class="pdfBtn"><img class="me-2" src="./assets/images/pdf-icon.png" alt="" width="30" height="30"></button>
                  </form>
                  <a href="" onclick="exportExcel()"><img class="ms-2" src="./assets/images/excel-icon.png" alt="" width="30" height="30"></a>
                  <a href="" onclick="exportPrint()"><img class="ms-3" src="./assets/images/printer-icon.png" alt="" width="30" height="30"></a>
              </div>
          </div>
          <div class="homeMainContainer d-flex my-2">
              <div class="homeLeftFlex me-2 bg-light d-flex flex-column align-items-center p-3">
                  <img src = "./assets/userImages/#session.profilePic#" alt="" width="100" height="100">
                  <h5 class="fullNameTxt">#session.fullName#</h5>
                  <button type="button" class="createBtn" data-bs-toggle="modal" data-bs-target="##editBtn" onclick ="createContact(event)">CREATE CONTACT</button>
              </div>
              <div class="homeRightFlex bg-light" id="homeRightFlex">
                <cfset local.value = createObject("component","component.index")>
                <cfset local.result =  local.value.fetchContact()>
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
                      <cfloop query="local.result">
                        <tr>
                          <th scope="row"><img src="./assets/contactImages/#contactprofile#" alt="" width="50" height="50"></th>
                          <td>#firstname# #lastname#</td>
                          <td>#email#</td>
                          <td>#mobile#</td>
                          <td><button type="button" class="btnHide" data-bs-toggle="modal" data-bs-target="##editBtn" onclick = "editContact('#contactid#')">EDIT</button></td>
                          <td><button type="button" class="btnHide" onClick="deleteContact('#contactid#')">DELETE</button></td>
                          <td><button type="button" class="btnHide" data-bs-toggle="modal" data-bs-target="##viewBtn" onClick="viewContact('#contactid#')">VIEW</button></td>
                        </tr>
                      </cfloop>
                      </tbody>
                  </table>
              </div>
          </div>
      </main>

      <!-- edit modal -->
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
                        <form method="POST" enctype="multipart/form-data" id="contactform" onsubmit="return modalValidate()">
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
                            <input type="date" name="dob" id="dob" value="" class="modalInputFor2">
                          </div>
                          <div class="d-flex justify-content-between">
                            <div id="genderError" class="text-danger fw-bold"></div>
                            <div id="dobError" class="text-danger fw-bold"></div>
                          </div>
                          <div class="d-flex flex-column">
                            <label class="modalLabelFor1">Upload Photo</label>
                            <input type="file" name="contactProfile" id="contactProfile" value="" class="modalInputFor1">
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
                            <input type="text" name="pincode" id="pincode" value="" class="modalInputForEven2">
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
                            <input type="text" name="mobile" id="mobile" value="" class="modalInputForEven2">
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
                <button type="submit" name="submitBtn" class="btn btn-primary">Save Changes</button>
              </div>
            </div>
          </div>
      </form>
      </div>

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
                          <div class="viewData" id="fullNameView">Miss. Anjana S</div>
                        </div>
                        <div class="d-flex">
                          <div class="viewLabel">Gender</div>
                          <div class="viewColon">:</div>
                          <div class="viewData" id="genderView">Female</div>
                        </div>
                        <div class="d-flex">
                          <div class="viewLabel">DOB</div>
                          <div class="viewColon">:</div>
                          <div class="viewData" id="dobView">12-05-2021</div>
                        </div>
                        <div class="d-flex">
                          <div class="viewLabel">Address</div>
                          <div class="viewColon">:</div>
                          <div class="viewData" id="addressView">35,East Car Street,Nagercoil,TamilNadu,India</div>
                        </div>
                        <div class="d-flex">
                          <div class="viewLabel">Pincode</div>
                          <div class="viewColon">:</div>
                          <div class="viewData" id="pincodeView">629001</div>
                        </div>
                        <div class="d-flex">
                          <div class="viewLabel">Email Id</div>
                          <div class="viewColon">:</div>
                          <div class="viewData" id="emailView">anjana@gamil.com</div>
                        </div>
                        <div class="d-flex">
                          <div class="viewLabel">Phone</div>
                          <div class="viewColon">:</div>
                          <div class="viewData" id="mobileView">1234567895</div>
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

      <cfif structKeyExists(form, "exportPdfBtn")>
         <cfset local.pdfObj = createObject("component","component.index")>
          <cfset local.PdfResult = local.pdfObj.generatePdf()>
        <cfdocument format="PDF" filename="assets/pdfs/contacts.pdf" overwrite="yes" pagetype="letter" orientation="portrait">
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
                            </tr>
                        </thead>
                        <tbody>
                            <cfloop query="local.PdfResult">
                                <tr>
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
                                </tr>
                            </cfloop>
                        </tbody>
                    </table>
                <cfelse>
                    <p>No contacts found for the current user.</p>
                </cfif>
        </cfdocument>
      </cfif>
    </cfif>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js" integrity="sha512-v2CJ7UaYy4JwqLDIrZUI/4hqeoQieOmAZNXBeQyjo21dadnwR+8ZaIJVT8EE2iyI61OV8e6M8PP2/4hpQINQ/g==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
    <script src="./assets/js/script.js"></script>
  </cfoutput>
</body>
</html>
