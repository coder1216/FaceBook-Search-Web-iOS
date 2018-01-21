<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <title>Facebook Search</title>
    </head>
    
        <style type="text/css">
           
            table{
                border-collapse: collapse;
                font-family: sans-serif;
            }
            
           #myform{
                width: 600px;
                margin: 10px auto auto auto;
                border: 2px solid rgb(213,213,213);
                background-color: rgb(244,244,244);
                height: 150px;
                font-family: sans-serif;
            }
            
            #notfound{
                border:2px solid rgb(213,213,213);
                text-align: center;
                margin: 10px auto auto auto;
                width: 650px;
                background-color: rgb(251,251,251);
                font-family: sans-serif;
            }
            
            #noalbums{
                border:2px solid rgb(213,213,213);
                text-align: center;
                margin: 10px auto auto auto;
                width: 650px;
                background-color: rgb(251,251,251);
                font-family: sans-serif;
                
            }
            
            #noposts{
                
                border:2px solid rgb(213,213,213);
                text-align: center;
                margin: 30px auto auto auto;
                width: 650px;
                background-color: rgb(251,251,251);
                font-family: sans-serif;
                
            }
            
            h1{
                font-weight: 100;
                text-align: center;
                font-style: italic;
                margin: 10px auto auto auto;
                font-family:serif;
                border-bottom: 1px solid rgb(137,137,137);
                margin-left: 10px;
                margin-right: 10px;
                padding-bottom: 5px;
                margin-bottom: -8px;
                margin-top: 4px;
            }
            
            table{
                width: 650px;
                text-align: left;
                margin:20px auto auto auto;
                border:2px rgb(219,219,219) solid;
                border-collapse: collapse;
                font-family: sans-serif;
            }
            label{
                margin-left: 5px;
                font-weight: 400;
                font-family: serif;
            }
            #search{
                margin-left: 70px;
                font-family: sans-serif;
            }
            
            th{
                font-weight: 600;
                border:1px rgb(219,219,219) solid;
                font-family: sans-serif;
                background-color: rgb(255,255,255);
            }
            td{
                border:1px rgb(219,219,219) solid;
                font-family: sans-serif;
            }
            
            th.nav{
                background-color: rgb(244,244,244);
                
            }
            
            .detailnav{
                width: 650px;
                text-align: center;
                background-color: rgb(204,204,204);
                margin:20px auto auto auto;
                font-family: sans-serif;
                font-weight: 100;
            }        
            
        </style>
    

    <?php
    date_default_timezone_set('UTC');
    require_once __DIR__ . '/php-graph-sdk-5.0.0/src/Facebook/autoload.php';
    $my_access_token = "EAADU1r8STQIBAHoqmeF0VYWBimLlt4JKGpL5jKlPlnUXVvZCmjyJP67wTrPouOt9R2Ln4a8mDpqwCI9Pg4DKVjqUC52z346uVeGZCo3oWFKwNRsL7X6wRBWrXZCc7ZALjQJDRSMm67mEdhtydwhZAF30V9N2IEfgZD";

    $fb = new Facebook\Facebook([
      'app_id' => '234018793737474',
      'app_secret' => '474c775cd9a56dfe70e232fbd0d9f71e',
      'default_graph_version' => 'v2.8',
      ]);
        
    $fb->setDefaultAccessToken($my_access_token);
    
    //  print address
                 
    function print_address($loc){

        $raw_data=file_get_contents("https://maps.googleapis.com/maps/api/geocode/json?address=941+Bloom+Walk,Los+Angeles,+CA+".$loc."90089-0781&key=AIzaSyAWAMVB6EdiHJOfCKSWjTb0wSRHMOKSS7A");
        
        $decode_data = json_decode($raw_data, true);
        $position = $decode_data['results'][0]['geometry']['location'];
        
        return $position;
    }
    

// do request
    function send_request($fb,$method,$type,$keyword){
        
        if($method === $_GET){
            $id = $method['id'];
            $request = $fb->request('GET', $id, ['fields' =>'id,name,picture.width(700).height(800),albums.limit(5){name,photos.limit(2){name,picture}},posts.limit(5)']); 
        }
        
        else if($method === $_POST){
                if($type == 'place'){
                
                    $loc = $method["location"];
                    $dis = $method["distance"];
                    $pos = print_address($loc); 
                    $lat = $pos['lat'];
                    $lng = $pos['lng'];

                   $request = $fb->request('GET','/search', ['q' => $keyword, 'type' => $type, 'center' => $lat.",".$lng, 'distance' => $dis, 'fields' => 'id,name,picture.width(700).height(800)']);
            }
            else if($type == 'user'){
                    $request = $fb->request('GET', '/search', ['q' =>$keyword, 'type' => $type, 'fields' =>'id,name,picture.width(700).height(800)']); 
            }
            else if($type == 'page') {
                $request = $fb->request('GET', '/search',  ['q' => $keyword, 'type' => $type, 'fields' => 'id,name,picture.width(700).height(800)']);
            }else if($type == 'event') {
                $request = $fb->request('GET', '/search',  ['q' => $keyword, 'type' => $type, 'fields' => 'id,name,place,picture.width(700).height(800)']);
            }else if($type == 'group') {
                $request = $fb->request('GET', '/search',  ['q' => $keyword, 'type' => $type, 'fields' => 'id,name,picture.width(700).height(800)']);
            }
        }
        
        else {
            echo 'Invalid Global Variable for sending Request!';
            exit;
        }
        
        
            try{
                $response = $fb->getClient()->sendRequest($request);
            } catch (Facebook\Exceptions\FacebookSDKException $e){
                echo 'Graph returned an error!' . $e->getMessage();
                exit;
            } catch(Facebook\Exceptions\FacebookSDKException $e){
                echo 'Facebook SDK returned an error: ' . $e->getMessage();
                exit;
            }
        
                if($method === $_POST){
                    $val = $response->getGraphEdge();
                }else if($method === $_GET){
                    $val = $response->getGraphNode();
                }
        
                $fbdata = json_decode($val, true);
                return $fbdata;
           
    }
    
   
//include place
        
        
     function print_events($fbdata){
        $size =  sizeof($fbdata);
        echo "<tr>";
        echo "<th class='nav'>Profile Photo</th>";
        echo "<th class='nav'>Name</th>";
        echo "<th class='nav'>Place</th>";
        echo "</tr>";
            
         for($i = 0; $i < $size; $i++){
            $data = (array)$fbdata[$i];
            $picture = (array)$data['picture'];
            echo "<tr>";
            echo "<td><a href=".$picture['url']." target='_blank'><img src='".$picture['url']."'width='40px' height='40px'></img></a></td>";  
            echo "<td>".$data['name']. "</td>";
            (isset($data['place']))?(print "<td>".$data['place']['name']."</td>"):(print "<td></td>");
            echo "</tr>";
             
        }
    }
        
// exclude place
        
    
        function print_types($fbdata,$type,$keyword){
            $size = sizeof($fbdata);
            echo "<tr>";
            echo "<th class='nav'>Profile Photo</th>";
            echo "<th class='nav'>Name</th>";
            echo "<th class='nav'>Detail</th>";
            echo "</tr>";
        
         for($i = 0; $i < $size; $i++){
            $data = (array)$fbdata[$i];
            $picture = (array)$data['picture'];     
            echo "<tr>";
            echo "<td><a href=".$picture['url']." target='_blank'><img src='".$picture['url']."'width='40px' height='40px'></img></a></td>";  
            echo "<td>".$data['name']. "</td>";
            echo "<td><a href='http://cs-server.usc.edu:18487/search.php?id=".$data['id']."&q=".$keyword."&type=".$type."'>Details</a ></td>";
            echo "</tr>";
        }
    }
    
    
// main manue, use print_events print_types to indentify 'place' 
    
     function print_search($fbdata,$type,$keyword){
         $size = sizeof($fbdata);
            if($size == 0){
                echo "<div id='notfound'>";
                echo "No records have been found";
                echo "</div>";
            }else{
                echo "<table>";            
                ($_POST['type'] == 'event')?print_events($fbdata):print_types($fbdata,$type,$keyword);
                echo "</table>";
            }          
        }

    
    
// show details
        
    function print_details($fbdata){
        
    if(isset($fbdata['albums'])){
        
        echo "<div class='detailnav'>"; 
        echo "<a href='#albums' onclick='hide_show(".'albums'.");'>Albums</a >";
        echo "</div>";

        $album = $fbdata['albums'];
        $size = sizeof($album);
        
        echo "<div id='albums' style='display:none';>";
        echo "<table>";
        
        for($i = 0; $i < $size; $i++){
            if(isset($album[$i]['photos'])){
                $photo = $album[$i]['photos'];
                // make an id call to picture
                echo "<tr>";
                echo "<td><a href='#albums' onclick='showpicture(".$i.");'>".$album[$i]['name']."</a></td>";
                echo "</tr>";
                echo "<tr class='picture' style='display:none';>";
                echo "<td>";
                //onclick to get a high quality picture
                for($j = 0;$j <sizeof($photo);$j++){
                    $id = $photo[$j]['id'];
                    echo "<a href='https://graph.facebook.com/v2.8/".$id."/picture?access_token=EAADU1r8STQIBAHoqmeF0VYWBimLlt4JKGpL5jKlPlnUXVvZCmjyJP67wTrPouOt9R2Ln4a8mDpqwCI9Pg4DKVjqUC52z346uVeGZCo3oWFKwNRsL7X6wRBWrXZCc7ZALjQJDRSMm67mEdhtydwhZAF30V9N2IEfgZD' target='_blank'></img><img src='".$photo[$j]['picture']."' width='80' height='80'></img></a>";
                } 
                echo "</td>";
                echo "</tr>";
            }else{
                
                echo"<tr>";
                echo "<td>".$album[$i]['name']."</td>";
                echo "</tr>";
            }
        }
        
        echo "</table>";
        echo "</div>";
            
        }else{
        
                echo "<div id='noalbums'>";
                echo "No Albums have been found";
                echo "</div>";
        
        }
    
        if(isset($fbdata['posts'])){
            
            $post = $fbdata['posts'];
            $size = sizeof($post);
        //make an id call to posts
            echo "<div class='detailnav'><a href='#posts' onclick='hide_show(".'posts'.");'>Posts</a></div>";
            echo "<div id='posts' style='display:none';>";
            echo "<table>";
            echo "<tr>";    
            echo "<th>Message</th>";
            echo "</tr>";
            
        for($i = 0;$i < $size; $i++){

            (isset($post[$i]['message']))?(print "<tr><td>".$post[$i]['message']."</td></tr>"):"";
            
        }
            echo "</table>";
            echo "</div>";
              
        }else{
            
                echo "<div id='noposts'>";
                echo "No Posts have been found";
                echo "</div>";
        }
    }
    
        
//server condition 

    if(isset($_GET['id'])){
          $keyword = $_GET['q'];
          $type = $_GET['type'];
          $result = send_request($fb, $_GET, $type, $keyword);

      }else{
            $keyword = $_POST['keyword'];
            $type = $_POST['type'];
            $result = send_request($fb, $_POST, $type, $keyword);
      } 
    
        
    ?>
    
    
    <body>
        <div id="myform">
        <h1>Facebook Search</h1>
        <br>
        
        <form action="http://cs-server.usc.edu:18487/search.php" method="POST">
    
           <label>Keyword</label> 
            <input type="text" name="keyword" size="" value= "<?php echo $keyword; ?>" pattern="^(?!\d).+$" oninvalid="this.setCustomValidity(this.willValidate?'':'This cant be left empty');" required >
            <br>
            <label>Type: &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label>
            <select name="type" onchange="showit(this.value)">
                <option value='user' <?php ($type == 'user')?(print "selected"):"" ?>>Users</option>
                <option value='page' <?php ($type == 'page')?(print "selected"):"" ?>>Pages</option>
                <option value='event' <?php ($type == 'event')?(print "selected"):"" ?>>Events</option>
                <option value='group' <?php ($type == 'group')?(print "selected"):"" ?>>Groups</option>
                <option value='place' <?php ($type == 'place')?(print "selected"):"" ?>>Places</option>   
            </select>
            <br>
        <div id ="hide" style="visibility:<?php ($type == 'place')?(print 'visible'):(print 'hidden') ?>">
                <label>Location</label>
                <input name="location" type="text" size="" value="" id="l" >
                <label>Distance(meters)</label>
                <input name="distance" type="text" size="" value="" pattern="^\d+$" id="d">
                <br>
        </div>
                <input id="search" type="submit" value="Search" size="" name="search"> 
    <!-- clean all the contents-->
                <input id="clear" type="reset" value="Clear" size="" name="clear" onclick="hideall()"> 
            <br>
        </form>
    </div>     
    
<!--    output result from server-->
        
    <?php    
    
        (isset($_GET['id']))?print_details($result):(isset($_POST))?print_search($result,$type,$keyword):"";
    
    ?>
    
    
                
        <script type="text/javascript"> 
        
            function showit(a){
                x = document.getElementById("hide");
                (a == 'place')?x.style.visibility = "visible" : x.style.visibility = "hidden";
            }
            
            function hideall(){
                document.getElementById("hide").style.visibility="hidden";
                window.location.replace("http://www-scf.usc.edu/~yufeihon/AlexHW6.html");
                
            }
            
             function showpicture(s){
                var a = document.getElementsByClassName('picture');
                if(a[s].style.display != 'none'){
                    a[s].style.display = 'none';
                }else{
                    a[s].style.display = 'block';
                }
            }
           
            
            function hide_show(h){
                
                var a = document.getElementById('albums');
                var b = document.getElementById('posts');
                
                if(a == null){
                    (a.style.display === 'none')?a.style.display = 'block':a.style.display = 'none';
                }
 
                else if(b == null){
                    (b.style.display === 'none')?b.style.display = 'block':b.style.display = 'none';
                }

                else if((a != null) && (b != null)){
                    if((h == a) && (a.style.display === 'block')){
                        h.style.display = 'none';
                    }else if((h == b) && (b.style.display === 'block')){
                        h.style.display = 'none';
                    }else if((h == a) && (a.style.display === 'none')){
                        h.style.display = 'block';
                        b.style.display = 'none';
                    }else if((h == b) && (b.style.display === 'none')){
                        h.style.display = 'block';
                        a.style.display = 'none';
                    }else if((a.style.display === 'none') && (b.style.display === 'none')){
                        h.style.display = 'block';
                    }
                }
            }
            
        </script>               
    </body>
</html>