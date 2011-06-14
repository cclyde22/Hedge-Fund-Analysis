<?php
	$fund = $_GET['fund'];
// New Connection
	$db = new mysqli('localhost','root','123Pass123','hfdb');

// Check for errors
	if(mysqli_connect_errno()){
 		echo mysqli_connect_error();
	}
//Query
	$result = $db->query("SELECT value FROM MarketValue WHERE seriesID = ( SELECT seriesID FROM Series WHERE fundID = (SELECT fundID FROM Fund WHERE name = '$fund'))");
	if($result){
// Cycle through results
    	while($r = mysqli_fetch_row($result)){
			$rows1[] = $r[0];
	}
//free result set
	$result->close();
	}
	$db->next_result();
//next Query
	$result = $db ->query("SELECT axysShares FROM Series WHERE fundID = (SELECT fundID FROM Fund WHERE name = '$fund')");
	if($result){
//cycle through results
	while ($r = mysqli_fetch_row($result)){
			$rows2[] = $r[0];
	}
	for($i = 0; $i<sizeof($rows1); $i++){
		$rows[] = $rows1[$i]/$rows2[$i];
	}
	echo json_encode($rows);
// Free result set
    	$result->close();
	}
	$db->close();
?>
