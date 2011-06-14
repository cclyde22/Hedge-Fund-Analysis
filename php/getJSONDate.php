<?php
	$return = $_GET['return'];
	$returnYtd = $_GET['returnYtd'];
// New Connection
	$db = new mysqli('localhost','root','123Pass123','hfdb');

// Check for errors
	if(mysqli_connect_errno()){
 		echo mysqli_connect_error();
	}
//Query
	if($return != ""){
		$result = $db->query("SELECT date FROM Returns WHERE value = '$return'");
	}
	else if($returnYtd != ""){
		$result = $db->query("SELECT date FROM ReturnYtd WHERE value = '$returnYtd'");
	}
	if($result){
// Cycle through results
    	while($r = mysqli_fetch_row($result)){
			$rows[] = $r[0];
	}
	echo json_encode($rows);
// Free result set
    	$result->close();
	}
	$db->close();
?>
