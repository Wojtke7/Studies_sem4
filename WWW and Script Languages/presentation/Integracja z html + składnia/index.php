<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>
<body>
    
    <?php
        echo "Hello world";

        $integer = 42;
        echo gettype($string); 

        $string = "Hello";
        echo gettype($integer); 

        echo "W PHP występuję interpolacja zmiennych, zmienna1: {$integer}, zmienna2: {$string}"
    ?>

</body>
</html>