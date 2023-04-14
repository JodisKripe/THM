<?php
$file = $_GET["file"];
if ($file == NULL){
	echo "File does not exist.";
} else{
	$fileext = pathinfo('/var/www/html/secretdir/' . $file);
	$fullfile = '/var/www/html/secretdir/' . $file;
	if ( $fileext['extension'] == "png") {
                header('Content-type: image/png');
                include($fullfile);
	} elseif ( $fileext['extension'] == "jpg") {
		header('Content-type: image/jpeg');
		include($fullfile);
	} else {
		include($fullfile);
	}
}
?>
