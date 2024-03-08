<!DOCTYPE html>
<html>
<head>
    <title>Formularz szefa</title>
</head>
<body>
    <h1>Przykładowy formularz szefa</h1>
    
    <form action="index.php" method="get">
        <label for="Ława">Ława is:</label>
        <input type="number" id="Ława" name="Ława" required><br><br>

        <label for="Martwy">Martwy is:</label>
        <input type="number" id="Martwy" name="Martwy" required><br><br>

        <label for="Przysiad">Przysiad is:</label>
        <input type="number" id="Przysiad" name="Przysiad"required><br><br>

        <input type="submit" name="submit" value="Submit"><br><br>
    </form>
</body>
</html>

<?php
    if (isset($_GET['submit'])) {
        // Retrieve form data
        $bench = $_GET["Ława"];
        $deadlift = $_GET["Martwy"];
        $squat = $_GET["Przysiad"];

        // Display the submitted data
        echo "Wynik na ławie: " . $bench . "kg" . "<br>";
        echo "Wynik w martwym: " . $deadlift . "kg" . "<br>";
        echo "Wynik w przysiadzie: " . $squat . "kg" . "<br>";

        echo "Eleganckie wyniki, tak trzymaj mistrzu 😎";
    }
?>