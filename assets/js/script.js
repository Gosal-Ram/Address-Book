function createContact(event){
    $(".modalTitle").text("CREATE CONTACT");
    event.preventDefault();
}

function editContact(event) {
    $(".modalTitle").text("EDIT CONTACT");

    // .text -->.value
}

function logOut(){

    if(confirm("Confirm logout")){
        $.ajax({
            type:"POST",
            url: "component/index.cfc?method=logOut",
            success:function(){
              //window.location.href = "Login.cfm"
              location.reload();
            }
        })
    }
} 
function deletePage(contactid){
   
    // var choice= confirm("Confirm delete")
    // console.log(choice);
    if(confirm("Confirm delete")){
        $.ajax({
            type:"POST",
            url: "component/index.cfc?method=deletePage",
            data:{contactid: contactid},
            success:function(data){
                if(data){
                    location.reload();
                }
            }
        })
    }
}