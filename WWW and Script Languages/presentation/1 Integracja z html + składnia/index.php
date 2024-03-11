<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>
<body>
    
    <?php
        // Integracja
        echo "Hello world" . "<br>";

        // Dynamiczne typowanie
        $my_integer = 42;
        echo gettype($my_integer) . "<br>" ; 

        $my_string = "Hello";
        echo gettype($my_string) . "<br>"; 

        // Interpolacja zmiennych
        echo "W PHP występuję interpolacja zmiennych <br> zmienna1: {$my_integer} <br> zmienna2: {$my_string}"
    ?>

</body>
</html>