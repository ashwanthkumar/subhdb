<?php

	require_once("../src/class.db.php");
	
	require_once("../src/config.php");
	
	$url_to_post = "http://127.0.1.1/subhdb/src/posts/";
	$jsonDoc = json_encode(array("id" => 5, "content" => "Another sample test content goes here", "author" => "Ashwanth", "time" => time()));
	
	$ch = curl_init();

	//set the url, number of POST vars, POST data
	curl_setopt($ch, CURLOPT_URL, $url_to_post);
	curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
	curl_setopt($ch, CURLOPT_POST, true);
	curl_setopt($ch, CURLOPT_POSTFIELDS, array("doc" => $jsonDoc));

	//execute post
	$result = curl_exec($ch);
	
	//close connection
	curl_close($ch);
	
	echo $result;
