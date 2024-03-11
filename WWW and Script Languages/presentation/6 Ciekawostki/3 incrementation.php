<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>
<body>
    <?php
        $a = '1';
        echo ++$a . "<br>";       
        echo gettype($a); 
    ?>

    <form method="post" action="4 array_datatypes.php">
        <input type="submit" value="Next" name="next_submit">
    </form>

</body>
</html>