<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>
<body>
    <?php
        $num = "10";
        $sum = $num + 5;
        echo $sum . "<br>";  
        echo gettype($sum);
       

        $mVar = '7fh7h5sabd9'; // string
        settype($mVar, 'integer'); // $zm staje się liczbą 7 (integer)
        echo "<br>" . $mVar;
    
    ?>

    <form method="post" action="incrementation.php">
        <input type="submit" value="Next" name="next_submit">
    </form>
</body>
</html>