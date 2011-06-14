<?php
	$client = $_GET['client'];
// New Connection
	$db = new mysqli('localhost','root','123Pass123','hfdb');

// Check for errors
	if(mysqli_connect_errno()){
 		echo mysqli_connect_error();
	}
//Query
	$result = $db->query("SELECT value FROM ActualYtd WHERE seriesID IN (SELECT seriesID FROM Series WHERE clientID = (SELECT clientID FROM Client WHERE name = '$client'))");
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
