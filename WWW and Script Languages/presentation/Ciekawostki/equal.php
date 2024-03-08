<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>
<body>
    <?php
    $a = 5;
    $b = '5';
    
    // Operator "==" porównuje tylko wartości zmiennych 
    
    if ($a == $b) {
        echo "Equal\n";
    } else {
        echo "Not Equal\n";
    }

    echo "<br>";

    // Operator potrójnego porównania "===" porównuje wartości oraz typy danych

    if ($a === $b) {
        echo "Identical\n";
    } else {
        echo "Not Identical\n";
    }

    ?>

    <br><br>
    
    <form method="post" action="conversion.php">
        <input type="submit" value="Next" name="next_submit">
    </form>

</body>
</html>