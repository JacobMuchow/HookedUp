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
    $fields = array(
        'id' => $_SESSION['id'],
        'sessionId' => session_id()
    );
    
    $result = curl_post($url, $fields);
    
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
     
    $result = curl_getJSON('api/image/index.php', array(
        'id' => $imageId
    ));
    
    return $result['success'] ? $result['result']['path'] : "";
 }

/** 
 * Send a POST requst using cURL
 * Reference: Davic from Code2Design.com http://php.net/manual/en/function.curl-exec.php
 */
function curl_post($urlPart, array $post = array(), array $options = array()) 
{
    $url = getAPIUrl() . $urlPart;
    
    $defaults = array( 
        CURLOPT_POST => 1, 
        CURLOPT_HEADER => 0, 
        CURLOPT_URL => $url, 
        CURLOPT_FRESH_CONNECT => 1, 
        CURLOPT_RETURNTRANSFER => 1, 
        CURLOPT_FORBID_REUSE => 1, 
        CURLOPT_TIMEOUT => 4, 
        CURLOPT_POSTFIELDS => http_build_query($post) 
    ); 

    $ch = curl_init(); 
    curl_setopt_array($ch, ($options + $defaults)); 
    if( ! $result = curl_exec($ch)) 
    { 
        trigger_error(curl_error($ch)); 
    } 
    curl_close($ch);
    return json_decode($result, true); 
} 

/** 
 * Functions for sending GET requests using cURL
 */ 
function curl_getJSON($urlPart, array $data = array(), array $curlOpts = array()) 
{    
    $result = curl_getLocal($urlPart, $data, $curlOpts);
    return json_decode($result, true);
}

function curl_getLocal($urlPart, array $data = array(), array $curlOpts = array()) {
    
    $url = $url = getAPIUrl() . $urlPart;
    return curl_get($url, $data, $curlOpts);
}

//Reference: Davic from Code2Design.com http://php.net/manual/en/function.curl-exec.php
function curl_get($url, array $data = array(), array $curlOpts = array()) {
    
    $defaults = array( 
        CURLOPT_URL => $url. (strpos($url, '?') === FALSE ? '?' : ''). http_build_query($data), 
        CURLOPT_HEADER => 0, 
        CURLOPT_RETURNTRANSFER => TRUE, 
        CURLOPT_TIMEOUT => 4 
    ); 
    
    $ch = curl_init(); 
    curl_setopt_array($ch, ($curlOpts + $defaults)); 
    if( ! $result = curl_exec($ch)) 
    { 
        trigger_error(curl_error($ch)); 
    } 
    curl_close($ch);
    return $result;
}