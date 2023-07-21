<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

$results_per_page = 6;
if (isset($_POST['pageno'])){
    $pageno = (int)$_POST['pageno'];
}else{
    $pageno = 1;
}
$page_first_result = ($pageno - 1) * $results_per_page;


if (isset($_POST['userid'])){
    $userid = $_POST['userid'];    
    $sqlloaditems = "SELECT * FROM `tbl_items` WHERE user_id = '$userid'";
} else if (isset($_POST['search'])){
    $search = $_POST['search'];
	$sqlloaditems = "SELECT * FROM `tbl_items` WHERE item_name LIKE '%$search%' OR item_brand LIKE '%$search%'";	
} else {
    $sqlloaditems = "SELECT * FROM `tbl_items`";
}

$result = $conn->query($sqlloaditems);
$number_of_result = $result->num_rows;
$number_of_page = ceil($number_of_result / $results_per_page);
$sqlloaditems = $sqlloaditems . " LIMIT $page_first_result , $results_per_page";
$result = $conn->query($sqlloaditems);

if ($result->num_rows > 0) {
    $items["items"] = array();
    while ($row = $result->fetch_assoc()) {
         $itemlist = array();
        $itemlist['item_id'] = $row['item_id'];
        $itemlist['user_id'] = $row['user_id'];
        $itemlist['user_phone'] = $row['user_phone'];
        $itemlist['item_brand'] = $row['item_brand'];
        $itemlist['item_name'] = $row['item_name'];
        $itemlist['item_type'] = $row['item_type'];
        $itemlist['item_desc'] = $row['item_desc'];
		$itemlist['item_price'] = $row['item_price'];
        $itemlist['item_interest'] = $row['item_interest'];
        $itemlist['item_lat'] = $row['item_lat'];
        $itemlist['item_long'] = $row['item_long'];
        $itemlist['item_state'] = $row['item_state'];
        $itemlist['item_locality'] = $row['item_locality'];
		$itemlist['item_date'] = $row['item_date'];
        array_push($items["items"],$itemlist);
    }
    $response = array('status' => 'success', 'data' => $items, 'numofpage' => "$number_of_page", 'numberofresult' => "$number_of_result");
    sendJsonResponse($response);
} else {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>