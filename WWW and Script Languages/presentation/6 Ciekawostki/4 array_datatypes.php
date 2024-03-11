<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>
<body>
    <?php
        $array = array(10, "20", true, null);
        foreach ($array as $value) {
            echo ($value) . "\n" ;
            echo gettype($value) . "<br>";
        }        
    ?>
</body>
</html>