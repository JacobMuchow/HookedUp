<?php require '../tools.php';

    $id = getGETSafe('id');
    $width = getGETSafe('width');
    $height = getGETsafe('height');
    
    $result = curl_getJSON('api/image/index.php', array(
        'id' => $id
    ));
    
    $image = $result['result'];
    
    if(!empty($width) && !empty($height)) { ?>
    
<img src="<?= $image['path'] ?>" width="<?= $width ?>" height="<?= $height ?>">
        
    <?php } else { ?>
    
<img src="<?= $image['path'] ?>">
        
    <?php } ?>