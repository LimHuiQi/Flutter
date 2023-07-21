<?php
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");
if (isset($_POST['image']) && isset($_POST['userid'])) {
    $image = $_POST['image'];
    $userid = $_POST['userid'];
    $decoded_string = base64_decode($image);
    $path = '../assets/profile/' . $userid . '.png';
    $file = fopen($path, 'wb');
    if ($file) {
        fwrite($file, $decoded_string);
        fclose($file);
        $response = array('status' => 'success', 'data' => null);
        sendJsonResponse($response);
    } else {
        $response = array('status' => 'failed', 'data' => null);
        sendJsonResponse($response);
    }
    die();
}

if (isset($_POST['newemail']) && isset($_POST['newname']) && isset($_POST['newphone']) && isset($_POST['userid'])) {
    $email = $_POST['newemail'];
    $name = $_POST['newname'];
	$phone = $_POST['newphone'];
    $userid = $_POST['userid'];

    // Use prepared statements to prevent SQL injection
    $stmt = $conn->prepare("UPDATE tbl_users SET user_name = ?, user_email = ?,user_phone = ? WHERE user_id = ?");
    $stmt->bind_param("sssi", $name, $email, $phone, $userid);

    if ($stmt->execute()) {
        $response = array('status' => 'success', 'data' => null);
        sendJsonResponse($response);
    } else {
        $response = array('status' => 'failed', 'data' => null);
        sendJsonResponse($response);
    }
}

if (isset($_POST['oldpass']) && isset($_POST['newpass']) && isset($_POST['userid'])) {
    $oldpass = sha1($_POST['oldpass']);
    $newpass = sha1($_POST['newpass']);
    $userid = $_POST['userid'];

    $stmt = $conn->prepare("SELECT * FROM tbl_users WHERE user_id = ? AND user_password = ?");
    $stmt->bind_param("is", $userid, $oldpass);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows > 0) {
        $stmt = $conn->prepare("UPDATE tbl_users SET user_password = ? WHERE user_id = ?");
        $stmt->bind_param("si", $newpass, $userid);

        if ($stmt->execute()) {
            $response = array('status' => 'success', 'data' => null);
            sendJsonResponse($response);
        } else {
            $response = array('status' => 'failed', 'data' => null);
            sendJsonResponse($response);
        }
    } else {
        $response = array('status' => 'failed', 'data' => null);
        sendJsonResponse($response);
    }
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>
