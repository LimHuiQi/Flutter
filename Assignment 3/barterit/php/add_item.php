<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

$userid = $_POST['userid'];
$item_brand = $_POST['itembrand'];
$item_name = $_POST['itemname'];
$item_desc = $_POST['itemdesc'];
$item_type = $_POST['itemtype'];
$item_price = $_POST['itemprice'];
$item_interest = $_POST['iteminterest'];
$latitude = $_POST['latitude'];
$longitude = $_POST['longitude'];
$state = $_POST['state'];
$locality = $_POST['locality'];
$image = json_decode($_POST['image']);

$sqlinsert = "INSERT INTO `tbl_items`(`user_id`,`item_brand`,`item_name`, `item_desc`, `item_type`,`item_price`, `item_interest`, `item_lat`, `item_long`, `item_state`, `item_locality`) VALUES ('$userid','$item_brand','$item_name','$item_desc','$item_type','$item_price','$item_interest','$latitude','$longitude','$state','$locality')";

if ($conn->query($sqlinsert) === TRUE) {
    $itemId = $conn->insert_id; 
    $response = array('status' => 'success', 'data' => null);
    $filename = $itemId . '.1'; // Start with index 1

    foreach ($image as $index => $base64Image) {
        $imageData = base64_decode($base64Image);

        if ($index > 0) {
            $filename = $itemId . '.' . ($index + 1); // Increment the index by 1
        }
        $path = '../assets/items/' . $filename . '.png';
        file_put_contents($path, $imageData);
    }
} else {
    $response = array('status' => 'failed', 'data' => null);
}
sendJsonResponse($response);

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>
