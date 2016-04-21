<?php
    require $_SERVER['DOCUMENT_ROOT'] . '/api/tools.php';

    $method = htmlspecialchars($_SERVER['REQUEST_METHOD']);
    $conn = mysqlConnect();
    
    switch ($method) {
        case 'GET':
            if (!$id = getGETSafe('id')) {
                failure("id required arg");
            }
            
            $query = "SELECT * FROM image WHERE id = ?";
            if (!$stmt = $conn->prepare($query)) {
                failure("Prepare failed: " . $conn->error);
            }
            
            $stmt->bind_param("s", $id);
            if (!$stmt->execute()) {
                failure("Execute failed: " . $stmt->error);
            }
            
            $result = $stmt->get_result();
            if (!$image = $result->fetch_assoc()) {
                failure("No user for id: ".$id);
            }
            success($image);
    
            break;
        case 'POST':
            break;
        case 'PUT';
            break;
        case 'DELETE';
            break;
    }    
?>
