<?php
    $str = htmlentities(file_get_contents("docker-compose.yml"));
    echo $str;
?>
