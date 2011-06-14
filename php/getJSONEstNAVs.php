<?php
	$fund = $_GET['fund'];
	$Nav = $_GET['Nav'];
// New Connection
	$db = new mysqli('localhost','root','123Pass123','hfdb');

// Check for errors
	if(mysqli_connect_errno()){
 		echo mysqli_connect_error();
	}
//Query
	$result = $db->query("SELECT value FROM Returns WHERE fundID = (SELECT fundID FROM Fund WHERE name = '$fund')");
	if($result){
// Cycle through results
    	while($r = mysqli_fetch_row($result)){
			$rows[] = $r[0];
	}
	for($i = 0; $i<sizeof($rows); $i++){
		$estNav[] = $Nav * $rows[$i];
	}
	echo json_encode($estNav);
// Free result set
    	$result->close();
	}
	$db->close();
?>
