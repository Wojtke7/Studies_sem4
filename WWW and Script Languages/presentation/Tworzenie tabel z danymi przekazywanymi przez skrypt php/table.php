<!DOCTYPE html>
<html>
<head>
    <title>Tabela z danymi z pliku tekstowego</title>
    <style>
        table {
            border-collapse: collapse;
            width: 100%;
        }
        th, td {
            border: 1px solid black;
            padding: 8px;
            text-align: left;
        }
    </style>
</head>
<body>
    <h2>Tabela z danymi z pliku tekstowego</h2>
    <table>
        <tr>
            <th>Dana</th>
            <th>Wartość</th>
        </tr>
        <?php
            // Otwieramy plik tekstowy do odczytu
            $file = fopen("data.txt", "r") or die("Nie można otworzyć pliku!");

            // Wczytujemy dane z pliku i umieszczamy je w tabelce HTML
            while (!feof($file)) {
                $line = fgets($file);
                $data = explode(",", $line);
                echo "<tr>";
                foreach ($data as $value) {
                    echo "<td>".$value."</td>";
                }
                echo "</tr>";
            }
            fclose($file);
        ?>
    </table>
</body>
</html>
