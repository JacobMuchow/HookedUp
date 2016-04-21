<?php require 'tools.php'; 
    requireLoggedIn();
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <?php require 'links.php'; ?>
    <style>
    </style>
    <script>
        $(document).ready(function() {
            console.log("hi");
            $.getJSON("api/feed/index.php", function(data) {
                console.log(data);
            });
        });
    </script>
</head>
<body>

<?php require 'navbar.php'; ?>

<div class="container">
    <p id="result">
        <?php 
            $result = curl_getLocal("templates/image.php", array(
                'id' => 'Image-1',
                'width' => '50',
            ));
            echo $result;
        ?>
    </p>
</div>

</body>
</html>
