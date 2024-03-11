<?php

// Definicja funkcji autoloadującej
function autoloader($className) {
    
    // Sprawdzenie, czy plik z klasą istnieje
    $file = __DIR__ . '/' . $className . '.php';
    
    if (file_exists($file)) {
        // Dodanie pliku do skryptu
        include_once($file);
    }
}

// Rejestracja funkcji autoloadującej
spl_autoload_register('autoloader');
?>
