<?php 
        header('Access-Control-Allow-Origin: *');
        date_default_timezone_set('UTC');
        require_once __DIR__ . '/php-graph-sdk-5.0.0/src/Facebook/autoload.php';
        $my_access_token = "EAADU1r8STQIBAHoqmeF0VYWBimLlt4JKGpL5jKlPlnUXVvZCmjyJP67wTrPouOt9R2Ln4a8mDpqwCI9Pg4DKVjqUC52z346uVeGZCo3oWFKwNRsL7X6wRBWrXZCc7ZALjQJDRSMm67mEdhtydwhZAF30V9N2IEfgZD";

        $fb = new Facebook\Facebook([
          'app_id' => '234018793737474',
          'app_secret' => '474c775cd9a56dfe70e232fbd0d9f71e',
          'default_graph_version' => 'v2.8',
          ]);

        $fb->setDefaultAccessToken($my_access_token);

    function print_address($loc){

            $raw_data=file_get_contents("https://maps.googleapis.com/maps/api/geocode/json?address=941+Bloom+Walk,Los+Angeles,+CA+".$loc."90089-0781&key=AIzaSyAWAMVB6EdiHJOfCKSWjTb0wSRHMOKSS7A");

            $decode_data = json_decode($raw_data, true);
            $position = $decode_data['results'][0]['geometry']['location'];
            return $position;
        }

         $token = "EAADU1r8STQIBAHoqmeF0VYWBimLlt4JKGpL5jKlPlnUXVvZCmjyJP67wTrPouOt9R2Ln4a8mDpqwCI9Pg4DKVjqUC52z346uVeGZCo3oWFKwNRsL7X6wRBWrXZCc7ZALjQJDRSMm67mEdhtydwhZAF30V9N2IEfgZD";

            

        if(isset($_GET["key"]) && isset($_GET["type"]) && $_GET["type"] == 'user'){
            
            $keyword = $_GET["key"];
            $type = $_GET["type"];
            $json =file_get_contents("https://graph.facebook.com/v2.8/search?q={$keyword}&type=user&fields=id,name,picture.width(700).height(700),albums.limit(5){name,photos.limit(2){name,picture}},posts.limit(5){created_time,message}&access_token={$token}");
            echo $json; 
            
        }

        else if(isset($_GET["key"]) && isset($_GET["type"]) && $_GET["type"] == 'page'){
            $keyword = $_GET["key"];
            $type = $_GET["type"];
            $json =file_get_contents("https://graph.facebook.com/v2.8/search?q={$keyword}&type=page&fields=id,name,picture.width(700).height(700),albums.limit(5){name,photos.limit(2){name,picture}},posts.limit(5){created_time,message}&access_token={$token}");
            echo $json; 
            
        }

        else if(isset($_GET["key"]) && isset($_GET["type"]) && $_GET["type"] == 'event'){
            $keyword = $_GET["key"];
            $type = $_GET["type"];
            $json =file_get_contents("https://graph.facebook.com/v2.8/search?q={$keyword }&type=event&fields=id,name,picture.width(700).height(700),albums.limit(5){name,photos.limit(2){name,picture}},posts.limit(5){created_time,message}&access_token={$token}");
            echo $json;  
        }

        else if(isset($_GET["key"]) && isset($_GET["type"]) && $_GET["type"] == 'place'){
            $keyword = $_GET["key"];
            $type = $_GET["type"];
            $lat=$_GET["lat"];
            $lon=$_GET["lon"];
            $json =file_get_contents("https://graph.facebook.com/v2.8/search?q={$keyword }&type=place&fields=id,name,picture.width(700).height(700),albums.limit(5){name,photos.limit(2){name,picture}},posts.limit(5){created_time,message}&center=".$lat.",".$lon."&access_token={$token}");
            echo $json;  
        }

        else if(isset($_GET["key"]) && isset($_GET["type"]) && $_GET["type"] == 'group'){
            $keyword = $_GET["key"];
            $type = $_GET["type"];
            $json =file_get_contents("https://graph.facebook.com/v2.8/search?q={$keyword }&type=group&fields=id,name,picture.width(700).height(700),albums.limit(5){name,photos.limit(2){name,picture}},posts.limit(5){created_time,message}&access_token={$token}");
            echo $json;  
        }
         


     ?>


        