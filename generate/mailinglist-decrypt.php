<?php
    // ubsubscribe functionality. saves to a flat file.
    // built by Jamie Kosoy (@jkosoy, jamie@arbitrary.io)

    require_once('../config.php');
    require_once(BASEDIR . '/subscribe/AES.class.php');

	// gets the aes key.
	$aesKeyFilePath = BASEDIR . '../mailinglist/aes-key.txt';
	$fh = fopen($aesKeyFilePath, 'r');
	$aesKey = fread($fh, filesize($aesKeyFilePath));
	fclose($fh);

	// set the aes block size.
	$aesBlockSize = 256;

	// where the mailing list text file is located.
	$listFilePath = BASEDIR . '../mailinglist/list.txt';


	$aes = new AES('', $aesKey, $aesBlockSize);
	$fh = fopen($listFilePath, 'r');

	while (($line = fgets($fh)) !== false) {
		$aes->setData($line);
		$email = $aes->decrypt();

		error_log($email);
		echo "$email<br />";
	}

	fclose($fh);
?>