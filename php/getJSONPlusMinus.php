<?php
	$returnYtd = $_GET['returnYtd'];
	$actualYtd = $_GET['actualYtd'];
	$plusMinus = $returnYtd-$actualYtd;
	echo json_encode($plusMinus);

?>
