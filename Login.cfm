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
            <span>ADDRESS BOOK</span>    
        </div>
        <div class="ms-auto d-flex me-5">
            <div class="signUpCont mx-4">
                <img src="./assets/images/user.png" alt="" width="18" height="18" class="headerImg2">
                <button class="btn text-light">Sign Up</button>
            </div>
            <div class="loginCont">
                <img src="./assets/images/exit.png" alt="" width="18" height="18">
                <button class="btn text-light">Login</button>
            </div>
        </div>
    </header>
    <main>
        <div class="mainDiv mt-5 bg-light mx-auto shadow-lg">
            <div class="leftFlex d-flex justify-content-center">
                <img src="./assets/images/contact-book.png" alt="" width="110" height="110" class="m-auto">
            </div>
            <div class="rightFlex ">
                <h3 class="text-center rightFlexHeading">LOGIN</h3>
                <form class="d-flex flex-column">
                    <input type="text" name="fullName" id="fullName" class="formInput" placeholder="User Name">
                    <input type="password" name="pwd1" id="pwd1" class="formInput" placeholder="Password">
                    <input type="submit" name="submit"  class="registerBtn" value="Login">
                </form>
                <div>Or Sign In Using</div>
                <div class="d-flex">
                    <img src="./assets/images/facebook-icon.png" alt="" width="18" height="18">
                    <img src="./assets/images/google-icon.png" alt="" width="18" height="18">
                </div>
                <div>Don't have a account <a href="">Register here</a></div>
            </div>
        </div>
    </main>
</body>
</html>
