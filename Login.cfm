<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Address Book Login Page</title>
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
        <div class="mainDivLogin mt-5 bg-light mx-auto shadow-lg">
            <div class="leftFlexLogin d-flex justify-content-center">
                <img src="./assets/images/contact-book.png" alt="" width="110" height="110" class="m-auto">
            </div>
            <div class="rightFlexLogin ">
                <h3 class="text-center rightFlexHeading">LOGIN</h3>
                <form class="d-flex flex-column">
                    <input type="text" name="fullName" id="fullName" class="formInput" placeholder="Username">
                    <input type="password" name="pwd1" id="pwd1" class="formInput" placeholder="Password">
                    <input type="submit" name="submit"  class="registerBtn" value="Login">
                </form>
                <div class="text-center">
                    <div class="my-3 text-secondary loginFooterTxt">Or Sign In Using</div>
                    <div class="d-flex align-items-center justify-content-center">
                        <a href="" class="mx-2"><img src="./assets/images/facebook-icon.png" alt="" width="50" height="50"></a>
                        <a href="" class="mx-2"><img src="./assets/images/google-icon.png" alt="" width="45" height="45"></a>
                    </div>
                    <div class="my-3 loginFooterTxt">Don't have a account <a href="" class="text-decoration-none ">Register here</a></div>
                </div>
            </div>
        </div>
    </main>
</body>
</html>
