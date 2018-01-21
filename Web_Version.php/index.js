//Init Facebook SDK
                window.fbAsyncInit = function() {
                    FB.init({
                        appId      : '234018793737474',
                        xfbml      : true,
                        version    : 'v2.8'
                    });
//                    FB.AppEvents.logPageView();
                };
                var crd;

                    var options = {
                      enableHighAccuracy: true,
                      timeout: 5000,
                      maximumAge: 0
                    };

                    function success(pos) {
                      crd = pos.coords;

                      console.log('Your current position is:');
                      console.log(`Latitude : ${crd.latitude}`);
                      console.log(`Longitude: ${crd.longitude}`);
                      console.log(`More or less ${crd.accuracy} meters.`);
                    };

                    function error(err) {
                      console.warn(`ERROR(${err.code}): ${err.message}`);
                    };

                    navigator.geolocation.getCurrentPosition(success, error, options);

                    (function(d, s, id){
                        var js, fjs = d.getElementsByTagName(s)[0];
                        if (d.getElementById(id)) {return;}
                        js = d.createElement(s); js.id = id;
                        js.src = "https://connect.facebook.net/en_US/sdk.js#xfbml=1&version=v2.8&appId=234018793737474";
                        fjs.parentNode.insertBefore(js, fjs);
                    }(document, 'script', 'facebook-jssdk'));

            

                function shareFB() {
                            FB.getLoginStatus(function (response) {
                                if (response.status === 'connected') {
                                    console.log('connected');
                                    postStory();
                                } else {
                                    
                                    FB.login(function (response) {
                                        if (response.status === 'connected') {
                                            postStory();
                                            
                                        } else {
                                            
                                            alert('Not Posted');
                                        }
                                    });
                                }
                            });
                        }

            shareFB();
                
                $(document).ready(function () {
                    $('.nav li a').click(function() {

                        $('a.col-md-2.btn-primary').removeClass('active');

                        var $children = $(this).children();
                        if (!$children.hasClass('active')) {
                            $children.addClass('active');
                        }
                    });
                });
                
                            $('#progressBar').hide(); 
                            $('#progressleft').hide();
                            $('#progressright').hide(); 
                            $('#progressright1').hide();
                            $('#progressleft1').hide();
                            $('#progressright2').hide();
                            $('#progressleft2').hide();
                            $('#progressright3').hide();
                            $('#progressleft3').hide();
                            $('#progressright4').hide();
                            $('#progressleft4').hide();
                            $('#progressright5').hide();
                            $('#progressleft5').hide();

               
                
                 $(".btn").mouseup(function(){$(this).blur();})
                    
                    
                $('#clean').on('click', function () {
                            
                        $('#searchForm').validate().resetForm();
                        $('#result').hide();
                        data = {};
                        clearForm();
                    });

                    function clearForm() {
                        document.getElementById("searchData").value = "";
                    }
                


                var app = angular.module('app', ['ngRoute']);

                app.controller("myController", function ($scope, $http){
                    $scope.rows=[];
                    $scope.rows1=[];
                    $scope.rows2=[];
                    $scope.rows3=[];
                    $scope.rows4=[];
                    
                    
                    $('#result').hide();
                    
                    $scope.postStory=function(x){
                
                        FB.ui({
                            app_id: "234018793737474",
                            method: 'feed',
                            link: window.location.href, 
                            picture: x.picture.data.url, 
                            name: x.name, 
                            mobile_iframe: true,
                            caption: "FB SEARCH FROM USC CSCI571",
                            display: "popup"
                            }, function(response){
                                
                            if (response && !response.error_message){
                                $("#fb").text("link post" + response.post_id);
                                alert('Posted Successfully');}
                                
                            else{
                                $("#fb").text("error");
                                alert('Not Posted');}
                            });
                    }
            
                    
                    
                    
                    
                    
                        $scope.users_next = function(){
                                
                            $http({
                                method : 'get',
                                dataType: 'json',
                                url : $scope.use.paging.next,
                                }).then(function (response){

                                    var json = response.data;
                                    $scope.use = json;
                                    $scope.rows = json.data;
                                    $('#result').show();
//                         
                        });
                            }
                        
                        $scope.users_prev = function(){
                                
                            $http({
                                method : 'get',
                                dataType: 'json',
                                url : $scope.use.paging.previous,
                                }).then(function (response){

                                    var json = response.data;
                                    $scope.use = json;
                                    $scope.rows = json.data;
                                    $('#result').show();
//       
                        });
                            }
                        
                        $scope.user_details = function(x){
                            
                           //$('#result').show();
                           console.log("detail");
                            $('#userContent1').hide();
                            $('#userContent2').hide();
                            $('#progressright').show();
                            $('#progressleft').show();
                            $scope.all = x;
                            $scope.albums=[];
                            $scope.posts=[];
                            if(x.albums){$scope.albums = x.albums.data;}
                            if(x.posts){$scope.posts = x.posts.data;}
                            
    
                            setTimeout(function(){
                                $('#userContent1').show();
                                $('#progressleft').hide();
                                $('#userContent2').show();
                                $('#progressright').hide();
                            },1000);    

                        }
                            
                        $scope.toggleAlbums=function(albums1,index){
                            
                            for(i=0;i<albums.length;i++){
                                if(i==index){
                                    albums[i].pic=!albums[i].pic;
                                }
                                else{
                                    albums[i].pic=false;
                                }
                            }
                        }
                        
                        
                    $scope.favolist = [];
                    (function(){
                        var json=localStorage.getItem("favolist");
                        if(json)$scope.favolist = $.parseJSON(json);
                        console.log(json);
                        console.log($scope.favolist);
                    }
                    )();
                    
                        $scope.change=function(e,type) {
//                  
                            e.favorite = !e.favorite;
                            console.log("click changed "+type);
                            if(e.favorite){
                                e.type=type;
                                $scope.favolist.push(e);
                            }else{
                                for(i=0;i<$scope.favolist.length;i++){
                                    if(e.id==$scope.favolist[i].id){
                                        $scope.favolist.splice(i,1);
                                    }
                                }
                                
                            }
                            console.log($scope.favolist);
                            localStorage.setItem("favolist",JSON.stringify($scope.favolist));
                                //console.log(localStorage.getItem("favolist"));
                            
                        }
                        
                    
                    
                    
                    
                    
                    $scope.pages_next = function(){
                                
                            $http({
                                method : 'get',
                                dataType: 'json',
                                url : $scope.use1.paging.next,
                                }).then(function (response){

                                    var json = response.data;
                                    $scope.use1 = json;
                                    $scope.rows1 = json.data;
                                    $('#result').show();
//                         
                        });
                            }
                        
                        $scope.pages_prev = function(){
                                
                            $http({
                                method : 'get',
                                dataType: 'json',
                                url : $scope.use1.paging.previous,
                                }).then(function (response){

                                    var json = response.data;
                                    $scope.use1 = json;
                                    $scope.rows1 = json.data;
                                    $('#result').show();
//       
                        });
                            }
                        
                        
                    
                    $scope.page_details = function(x){
                            console.log("detail");
                            console.log(x);
                            $('#pageContent1').hide();
                            $('#pageContent2').hide();
                            $('#progressright1').show();
                            $('#progressleft1').show();
                            $scope.all1 = x;
                            $scope.albums1=[];
                            $scope.posts1=[];
                            if(x.albums){$scope.albums1 = x.albums.data;}
                            if(x.posts){$scope.posts1 = x.posts.data;}
                            
    
                            setTimeout(function(){
                                $('#pageContent1').show();
                                $('#pageContent2').show();
                                $('#progressright1').hide();
                                $('#progressleft1').hide();
                            },1000);    
                            
                        }
                    $scope.toggleAlbums=function(albums,index){
                        
                        for(i=0;i<albums.length;i++){
                            if(i==index){
                                albums[i].pic=!albums1[i].pic;
                            }
                            else{
                                albums[i].pic=false;
                            }
                        }
                    }
                        
                    
 
                    
//    event parse                
                    

                    
                    $scope.events_next = function(){
                                
                            $http({
                                method : 'get',
                                dataType: 'json',
                                url : $scope.use2.paging.next,
                                }).then(function (response){

                                    var json = response.data;
                                    $scope.use2 = json;
                                    $scope.rows2 = json.data;
                                    $('#result').show();
//                         
                        });
                            }
                        
                        $scope.events_prev = function(){
                                
                            $http({
                                method : 'get',
                                dataType: 'json',
                                url : $scope.use2.paging.previous,
                                }).then(function (response){

                                    var json = response.data;
                                    $scope.use2 = json;
                                    $scope.rows2 = json.data;
                                    $('#result').show();
//       
                            });
                        }
                        
                         $scope.event_details = function(x){
                            
                           console.log("detail");
                            $('#eventContent1').hide();
                            $('#eventContent2').hide();
                             $('#progressright2').show();
                                $('#progressleft2').show();
                            $scope.all2 = x;
                            $scope.albums2=[];
                            $scope.posts2=[];
                            if(x.albums){$scope.albums2 = x.albums.data;}
                            if(x.posts){$scope.posts2 = x.posts.data;}
                             
                            setTimeout(function(){
                                $('#eventContent1').show();
                                $('#eventContent2').show();
                                 $('#progressright2').hide();
                                $('#progressleft2').hide();
                            },1000);    
//                         
                        }
                         
                    $scope.toggleAlbums=function(albums,index){
                        
                            for(i=0;i<albums.length;i++){
                                if(i==index){
                                    albums[i].pic=!albums[i].pic;
                                }
                                else{
                                    albums[i].pic=false;
                                }
                            }
                        }
                        
                    
                    
                    
                    
                    $("#place_s").on("click", function(){  
                        
                        if(!$('#searchData').val()){
                            return;
                        }
                        
                        if(!crd){
                            alert("Please wait for parsing position!");
                            return;
                            
                        }
                        
                        $http({
                        method : 'get',
                        dataType: 'json',
                        url : "http://cs-server.usc.edu:18487/index.php/?key="+$('#searchData').val()+"&type=place&lat="+crd.latitude+"&lon="+crd.longitude,
                        
                        }).then(function (response){
                                
                            var json = response.data;
                            $scope.rows3 = json.data;
                            $scope.use3 = json;
                           for(i=0;i<$scope.rows3.length;i++){
                                for(j=0;j<$scope.favolist.length;j++){
                                    console.log($scope.favolist[j]);
                                    console.log($scope.rows3[i]);
                                    if($scope.favolist[j].type=="group" && $scope.favolist[j].id==$scope.rows3[i].id){
                                        $scope.rows3[i].favorite=true;
                                    }
                                }
                            }
                            
//                          
                        });
//                       
                        
                    });
                    
                    $scope.places_next = function(){
                                
                            $http({
                                method : 'get',
                                dataType: 'json',
                                url : $scope.use3.paging.next,
                                }).then(function (response){

                                    var json = response.data;
                                    $scope.use3 = json;
                                    $scope.rows3 = json.data;
                                    $('#result').show();
//                         
                        });
                            }
                        
                        $scope.places_prev = function(){
                                
                            $http({
                                method : 'get',
                                dataType: 'json',
                                url : $scope.use3.paging.previous,
                                }).then(function (response){

                                    var json = response.data;
                                    $scope.use3 = json;
                                    $scope.rows3 = json.data;
                                    $('#result').show();
//       
                        });
                            }
                        
                        
                    $scope.place_details = function(x){
                            
                            
                            console.log("detail");
                            $('#placeContent1').hide();
                            $('#placeContent2').hide();
                            $('#progressright3').show();
                                $('#progressleft3').show();
                            $scope.all3 = x;
                            $scope.albums3=[];
                            $scope.posts3=[];
                            if(x.albums){$scope.albums3 = x.albums.data;}
                            if(x.posts){$scope.posts3 = x.posts.data;}
                            
                            setTimeout(function(){
                                $('#placeContent1').show();
                                $('#placeContent2').show();
                                $('#progressright3').hide();
                                $('#progressleft3').hide();
                            },1000);      
//                         
                        }
                    $scope.toggleAlbums=function(albums,index){
                        
                            for(i=0;i<albums.length;i++){
                                if(i==index){
                                    albums[i].pic=!albums[i].pic;
                                }
                                else{
                                    albums[i].pic=false;
                                }
                            }
                        }
                    
                    
                    
                    
                    
                    
                    $("#group_s").on("click", function(){ 
                        if(!$('#searchData').val()){
                            return;
                        }
//                        
                        
                    });
                    
                    $scope.groups_next = function(){
                                
                            $http({
                                method : 'get',
                                dataType: 'json',
                                url : $scope.use4.paging.next,
                                }).then(function (response){

                                    var json = response.data;
                                    $scope.use4 = json;
                                    $scope.rows4 = json.data;
                                    $('#result').show();
//                         
                        });
                            }
                        
                        $scope.groups_prev = function(){
                                
                            $http({
                                method : 'get',
                                dataType: 'json',
                                url : $scope.use4.paging.previous,
                                }).then(function (response){

                                    var json = response.data;
                                    $scope.use4 = json;
                                    $scope.rows4 = json.data;
                                    $('#result').show();
//       
                        });
                            }
                        
                        $scope.group_details = function(x){
                            
                           console.log("detail group");
                            
                            $('#groupContent1').hide();
                            $('#groupContent2').hide();
                            $('#progressright4').show();
                            $('#progressleft4').show();
                            $scope.all4 = x;
                            $scope.albums4=[];
                            $scope.posts4=[];
                            if(x.albums){$scope.albums4 = x.albums.data;}
                            if(x.posts){$scope.posts4 = x.posts.data;}
                            
                            setTimeout(function(){
                                $('#groupContent1').show();
                                $('#groupContent2').show();
                                $('#progressright4').hide();
                            $('#progressleft4').hide();
                            },1000);      
//                         
                        }
                        $scope.toggleAlbums=function(albums,index){
                            
                            for(i=0;i<albums.length;i++){
                                if(i==index){
                                    albums[i].pic=!albums[i].pic;
                                }
                                else{
                                    albums[i].pic=false;
                                }
                            }
                        }
                        
                        
                        
                        
                        
                        $scope.favorites_next = function(){
                                
                            $http({
                                method : 'get',
                                dataType: 'json',
                                url : $scope.use5.paging.next,
                                }).then(function (response){

                                    var json = response.data;
                                    $scope.use5 = json;
                                    $scope.rows5 = json.data;
                                    $('#result').show();
//                         
                        });
                            }
                        
                        $scope.favorites_prev = function(){
                                
                            $http({
                                method : 'get',
                                dataType: 'json',
                                url : $scope.use5.paging.previous,
                                }).then(function (response){

                                    var json = response.data;
                                    $scope.use5 = json;
                                    $scope.rows5 = json.data;
                                    $('#result').show();
//       
                        });
                            }
                        
                        $scope.favorites_details = function(x){
                            
                           console.log("detail");
                            $('#favoriteContent1').hide();
                            $('#favoriteContent2').hide();
                            $('#progressright5').show();
                            $('#progressleft5').show();
                            $scope.all5 = x;
                            $scope.albums5=[];
                            $scope.posts5=[];
                            if(x.albums){$scope.albums5 = x.albums.data;}
                            if(x.posts){$scope.posts5 = x.posts.data;}
                            console.log(x);
                            setTimeout(function(){
                                $('#favoriteContent1').show();
                                $('#favoriteContent2').show();
                                $('#progressright5').hide();
                             $('#progressleft5').hide();
                            },1000);      
//                         
                        }
                        
                        
                      
                        
                        $scope.toggleAlbums=function(albums,index){
                            
                            for(i=0;i<albums.length;i++){
                                if(i==index){
                                    albums[i].pic=!albums[i].pic;
                                }
                                else{
                                    albums[i].pic=false;
                                }
                            }
                        }
                        
                        
                    $('#searchButton').on('click', function(){
                        $scope.rows=[];
                        $scope.rows4=[];
                        
                        if(!$('#searchData').val()){
                            return;
                        }
                        $('#result').hide();
                        $('#progressBar').show();
                        console.log($('#progressBar'));
                    $http({
                        method : 'get',
                        dataType: 'json',
                        url : "http://cs-server.usc.edu:18487/index.php/?key="+$('#searchData').val()+"&type=user",
  
                        }).then(function (response){
                            
                            var json = response.data;
                            $scope.rows = json.data;
                            $scope.use = json;
                              
                        });
                    $http({
                        method : 'get',
                        dataType: 'json',
                        url : "http://cs-server.usc.edu:18487/index.php/?key="+$('#searchData').val()+"&type=page",
  
                        }).then(function (response){
                                
                            var json = response.data;
                            $scope.rows1 = json.data;
                            $scope.use1 = json;
//                          
                        });
                        
                   
                    $http({
                        method : 'get',
                        dataType: 'json',
                        url : "http://cs-server.usc.edu:18487/index.php/?key="+$('#searchData').val()+"&type=group",
  
                        }).then(function (response){
                                
                           var json = response.data;
                            $scope.rows4 = json.data;
                            for(i=0;i<$scope.rows4.length;i++){
                                for(j=0;j<$scope.favolist.length;j++){
                                    console.log($scope.favolist[j]);
                                    console.log($scope.rows4[i]);
                                    if($scope.favolist[j].type=="group" && $scope.favolist[j].id==$scope.rows4[i].id){
                                        $scope.rows4[i].favorite=true;
                                    }
                                }
                            }
                            $scope.use4 = json;
                            $('#result').show();   
                            $('#progressBar').hide();
//                            
                        });
                    $http({
                        method : 'get',
                        dataType: 'json',
                        url : "http://cs-server.usc.edu:18487/index.php/?key="+$('#searchData').val()+"&type=event",
  
                        }).then(function (response){
                                
                            var json = response.data;
                            $scope.rows2 = json.data;
                            $scope.use2 = json;
                            
                        
                        });
                        
                        
                    });
                });


                    
            
                

                
//                    $('.progress').hide();
//                  $('#carousel-example-generic').carousel({
//                    pause: true,
//                    interval: false
//                });
//                    $(window).load(function(){
//                       // PAGE IS FULLY LOADED  
//                       // FADE OUT YOUR OVERLAYING DIV
//                       $('.progress').fadeOut(2000);
//                    });
                
            