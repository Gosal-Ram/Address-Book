<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Address Book Sign In Page</title>
    <link rel="stylesheet" href="../../../bootstrap-5.0.2-dist/bootstrap-5.0.2-dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="./assets/css/style.css">
</head>
<body>
    <header class="d-flex p-1 align-items-center">
        <div class="nameTxtContainer ms-4">
            <img src="./assets/images/contact-book.png" alt="" width="45" height="45">
             <span class="headerHeadingName">ADDRESS BOOK</span>    
        </div>
        <div class="ms-auto d-flex me-5">
            <div class="signUpCont mx-4">
                <img src="./assets/images/user.png" alt="" width="18" height="18" class="headerImg2">
                <a class="btn text-light" href="index.cfm">Sign Up</a>
            </div>
            <div class="loginCont">
                <img src="./assets/images/exit.png" alt="" width="18" height="18">
                <a class="btn text-light"  href="Login.cfm">Login</a>
            </div>
        </div>
    </header>
    <main>
        <div class="mainDiv mt-5 bg-light mx-auto shadow-lg">
            <div class="leftFlex d-flex justify-content-center">
                <img src="./assets/images/contact-book.png" alt="" width="110" height="110" class="m-auto">
            </div>
            <div class="rightFlex ">
                <h3 class="text-center rightFlexHeading">SIGN UP</h3>
                <form class="d-flex flex-column">
                    <input type="text" name="fullName" id="fullName" class="formInput" placeholder="Full Name">
                    <input type="mail" name="emailId" id="emailId" class="formInput" placeholder="Email ID">
                    <input type="text" name="userName" id="userName" class="formInput" placeholder="Username">
                    <input type="password" name="pwd1" id="pwd1" class="formInput" placeholder="Password">
                    <input type="password" name="pwd2" id="pwd2" class="formInput" placeholder="Confirm Password">
                    <label for="file" class="ms-3">Upload Profile picture</label>
                    <input type="file" name="file" id="file" class="fileInput">
                    <input type="submit" name="submit"  class="registerBtn" value="Register">
                </form>
            </div>
        </div>
    </main>
</body>
</html>
