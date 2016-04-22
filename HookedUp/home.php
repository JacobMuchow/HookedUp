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
        <img src="<?= getImageUrl('Image-1'); ?>" width="100" height="100">
    </p>
</div>

</body>
</html>
