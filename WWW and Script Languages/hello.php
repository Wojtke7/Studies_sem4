<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>
<body>
    <?php
            echo "Hello World\n";
            $date = date('j-m-y, h:i:s');
            $x = 5;
            $y = 77;
            $multiplication = $x * $y;
            echo "Date is: {$date} lol \n";
            echo "Multiplication is: {$multiplication}\n";
            
            function getAge() {
                return 25;
            }
            
            function getGreeting() {
                return "Hello";
            }
            
            echo "My age is: {getAge()}\n"; // Wyświetli: ?
            echo "{getGreeting()}, World!"; // Wyświetli: ?
            
        ?>
</body>
</html>
