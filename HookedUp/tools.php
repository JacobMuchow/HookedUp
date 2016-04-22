<?php 

$loggedIn = false;

/**
 * Helper functions for getting request data
 */
function getGETSafe($key) {
    $val = htmlspecialchars($_GET[$key]);
    return empty($val) ? NULL : $val;
}

function getPOSTSafe($key) {
    $val = htmlspecialchars($_POST[$key]);
    return empty($val) ? NULL : $val;
}

/**
 * Helper functions to get root urls for client & API
 */
function getClientUrl() {
    return "http://" . $_SERVER['HTTP_HOST'] . "/";
}

function getAPIUrl() {
    if (strpos($_SERVER['HTTP_HOST'], "localhost:8000") !== FALSE) {
        return "http://localhost:8001" . "/";
    }
    
    return "http://" . $_SERVER['HTTP_HOST'] . "/";
}

function redirect($urlPart) {
    header("Location: " . getClientUrl() . $urlPart);
}

/**
 * Called at the top of pages that require login to view
 * Checks user cookie and redirects them to login screen if 
 * not logged in or invalid. 
 */
function requireLoggedIn() {
    if(!isUserLoggedIn()) {
        header("Location: " . getClientUrl() . "login.php");
    }
}

function checkLoggedIn() {
    if(isUserLoggedIn()) {
        header("Location: " . getClientUrl . "home.php");
    }
}

function isUserLoggedIn() {
    session_start();
    
    if(!isset($_SESSION['id'])) {
        return false;
    }
    
    $url = "/api/auth/authenticate.php";
    $data = array(
        'id' => $_SESSION['id'],
        'sessionId' => session_id()
    );
    
    $result = makeAPIRequest($url, 'POST', $data);
    
    global $loggedIn;
    $loggedIn = $result['result'];
    return $loggedIn;
}

/**
 * Helper functions for getting logged in user data. 
 */
function getUserId() {
    return $_SESSION['id'];
}

function getUserFirstName() {
    return $_SESSION['firstName'];
}

function getUserLastName() {
    return $_SESSION['lastName'];
}

function getUserFullName() {
    return getUserFirstName() . " " . getUserLastName();
}

/**
 * Template functions
 */
 function getImageUrl($imageId) {
     
    $result = makeAPIRequest('api/image/index.php', 'GET', array(
        'id' => $imageId
    ));
    
    return $result['success'] ? $result['result']['path'] : "";
 }

/** 
 * Make a request using cURL
 * 
 * Adapted from: Davic from Code2Design.com http://php.net/manual/en/function.curl-exec.php
 */
 function makeAPIRequest($urlPart, $method, array $data = array()) {
     $url = getAPIUrl() . $urlPart;
     $result = makeRequest($url, $method, $data);
     return json_decode($result, true);
 }
 
 function makeRequest($url, $method, array $data = array()) {
     
     if($method === "GET") {
         $url .= (strpos($url, '?') === FALSE ? '?' : '') . http_build_query($data);
     }
     
     $curlOpts = array(
         CURLOPT_URL => $url,
         CURLOPT_HEADER => 0,
         CURLOPT_RETURNTRANSFER => 1,
         CURLOPT_TIMEOUT => 4
     );
     
     if($method !== "GET") {
         $curlOpts[CURLOPT_POST] = 1;
         $curlOpts[CURLOPT_POSTFIELDS] = http_build_query($data);
         $curlOpts[CURLOPT_FRESH_CONNECT] = 1;
         $curlOpts[CURLOPT_FORBID_REUSE] = 1;
     }
     
    $curl = curl_init(); 
    curl_setopt_array($curl, $curlOpts); 
    
    if( ! $result = curl_exec($curl)) { 
        trigger_error(curl_error($curl)); 
    }
    
    curl_close($curl);
    return $result;
 }