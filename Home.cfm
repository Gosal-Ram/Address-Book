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
    <header class="d-flex p-1 align-items-center">
        <div class="nameTxtContainer ms-4">
            <img src="./assets/images/contact-book.png" alt="" width="45" height="45">
            <span class="headerHeadingName">ADDRESS BOOK</span>    
        </div>
        <div class="ms-auto d-flex me-5">
            <div class="loginCont">
                <img src="./assets/images/exit.png" alt="" width="18" height="18">
                <a class="btn text-light"  href="Login.cfm">Logout</a>
            </div>
        </div>
    </header>
    <main class="mx-auto homeMain">
        <div class="homeTopContainer bg-light my-2 p-3 px-5 rounded">
            <div class="homeTopImgCont d-flex justify-content-end ">
                <a href=""><img class="me-2" src="./assets/images/pdf-icon.png" alt="" width="30" height="30"></a>
                <a href=""><img class="ms-2" src="./assets/images/excel-icon.png" alt="" width="30" height="30"></a>
                <a href=""><img class="ms-3" src="./assets/images/printer-icon.png" alt="" width="30" height="30"></a>
            </div>
        </div>
        <div class="homeMainContainer d-flex my-2">
            <div class="homeLeftFlex me-2 bg-light d-flex flex-column align-items-center p-3">
                <img src="./assets/images/user-grey-icon.png" alt="" width="100" height="100">
                <h5 class="fullNameTxt">Merlin Richard</h5>
                <button class="createBtn">CREATE CONTACT</button>
            </div>
            <div class="homeRightFlex bg-light">
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
                      <tr>
                        <th scope="row"><img src="./assets/images/user-grey-icon.png" alt="" width="50" height="50"></th>
                        <td>Anjana S</td>
                        <td>anjana@gmail.com</td>
                        <td>1234567890</td>
                        <td><button type="button" class="" data-bs-toggle="modal" data-bs-target="#editBtn">EDIT</button></td>
                        <td><button class="">DELETE</button></td>
                        <td><button type="button" class="" data-bs-toggle="modal" data-bs-target="#viewBtn">VIEW</button></td>
                      </tr>
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
                      <form>
                        <div class="d-flex justify-content-between">
                          <label class="modalLabelSelect">Title*</label>
                          <label class="modalLabel">First Name*</label>
                          <label class="modalLabel">Last Name*</label>
                        </div>
                        <div class="d-flex justify-content-between">
                          <select class="modalInputSelect">
                            <option></option>
                            <option>Mr.</option>
                            <option>Ms.</option>
                          </select>
                          <input type="text" name="" id="" value="" placeholder="first name" class="modalInput">
                          <input type="text" name="" id="" value="" placeholder="last name" class="modalInput">
                        </div>
                        <div class="d-flex justify-content-center">
                          <label class="modalLabelFor2">Gender*</label>
                          <label class="modalLabelFor2">Date Of Birth*</label>
                        </div>
                        <div class="d-flex justify-content-between">
                          <select class="modalInputSelect">
                            <option>Male</option>
                            <option>Female</option>
                          </select>
                          <input type="date" name="" id="" value="" class="modalInputFor2">
                        </div>
                        <div class="d-flex flex-column">
                          <label class="modalLabelFor1">Upload Photo</label>
                          <input type="file" name="" id="" value="" class="modalInputFor1">
                        </div>
                        <h3 class="modalTiltle2">Contact Details</h3>
                        <div class="d-flex justify-content-center">
                          <label class="modalLabelForEven2">Address*</label>
                          <label class="modalLabelForEven2">Street*</label>
                        </div>
                        <div class="d-flex justify-content-between">
                          <input type="text" name="" id="" value="" class="modalInputForEven2">
                          <input type="text" name="" id="" value="" class="modalInputForEven2">
                        </div>
                        <div class="d-flex justify-content-center">
                          <label class="modalLabelForEven2">District*</label>
                          <label class="modalLabelForEven2">State*</label>
                        </div>
                        <div class="d-flex justify-content-between">
                          <input type="text" name="" id="" value="" class="modalInputForEven2">
                          <input type="text" name="" id="" value="" class="modalInputForEven2">
                        </div>
                        <div class="d-flex justify-content-center">
                          <label class="modalLabelForEven2">Country*</label>
                          <label class="modalLabelForEven2">Pincode*</label>
                        </div>
                        <div class="d-flex justify-content-between">
                          <input type="text" name="" id="" value="" class="modalInputForEven2">
                          <input type="text" name="" id="" value="" class="modalInputForEven2">
                        </div>
                        <div class="d-flex justify-content-center">
                          <label class="modalLabelForEven2">Email*</label>
                          <label class="modalLabelForEven2">Phone*</label>
                        </div>
                        <div class="d-flex justify-content-between">
                          <input type="email" name="" id="" value="" class="modalInputForEven2">
                          <input type="text" name="" id="" value="" class="modalInputForEven2">
                        </div>
                      </form>
                    </div>
                </div>
                <div class="modalRightFlex">
                    <div class="mt-5 ms-5 bg-light">
                        <img src="./assets/images/user-grey-icon.png" alt="" width="100" height="100">
                    </div>
                </div>
            </div>
            <div class="modal-footer">
              <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
              <button type="button" class="btn btn-primary">Save Changes</button>
            </div>
          </div>
        </div>
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
                        <div class="viewColon">&#58;</div>
                        <div class="viewData">Miss. Anjana S</div>
                      </div>
                      <div class="d-flex">
                        <div class="viewLabel">Gender</div>
                        <div class="viewColon">&#58;</div>
                        <div class="viewData">Female</div>
                      </div>
                      <div class="d-flex">
                        <div class="viewLabel">DOB</div>
                        <div class="viewColon">&#58;</div>
                        <div class="viewData">12-05-2021</div>
                      </div>
                      <div class="d-flex">
                        <div class="viewLabel">Address</div>
                        <div class="viewColon">&#58;</div>
                        <div class="viewData">35,East Car Street,Nagercoil,TamilNadu,India</div>
                      </div>
                      <div class="d-flex">
                        <div class="viewLabel">Pincode</div>
                        <div class="viewColon">&#58;</div>
                        <div class="viewData">629001</div>
                      </div>
                      <div class="d-flex">
                        <div class="viewLabel">Email Id</div>
                        <div class="viewColon">&#58;</div>
                        <div class="viewData">anjana@gamil.com</div>
                      </div>
                      <div class="d-flex">
                        <div class="viewLabel">Phone</div>
                        <div class="viewColon">&#58;</div>
                        <div class="viewData">1234567895</div>
                      </div>
                      <div class="d-flex justify-content-center mt-3">
                        <button type="button" class="btn createBtn" data-bs-dismiss="modal">Close</button>
                      </div>
                    </div>
                </div>
                <div class="modalRightFlex">
                    <div class="mt-5 ms-5 bg-light">
                        <img src="./assets/images/user-grey-icon.png" alt="" width="100" height="100">
                    </div>
                </div>
            </div>
          </div>
        </div>
    </div>
</body>
</html>
