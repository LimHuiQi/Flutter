<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

$itemid = $_POST['itemid'];
$item_brand = $_POST['itembrand'];
$item_name = $_POST['itemname'];
$item_price = $_POST['itemprice'];
$item_interest = $_POST['iteminterest'];
$userid = $_POST['userid'];
$user_phone = $_POST['userphone'];
$seller_id = $_POST['sellerid'];

$sqlinsert = "INSERT INTO `tbl_orders`(`item_id`, `item_brand`, `item_name`, `item_price`, `item_interest`, `user_id`, `user_phone`, `seller_id`) VALUES ('$itemid','$item_brand','$item_name','$item_price','$item_interest','$userid','$user_phone', '$seller_id')";


if ($conn->query($sqlinsert) === TRUE) {
    $response = array('status' => 'success', 'data' => $sqlinsert);
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