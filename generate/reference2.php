<?

$benchmark_start = microtime_float();

`../java_generate/ReferenceGenerator/processingrefBuild.sh`;

$benchmark_end = microtime_float();
$execution_time = round($benchmark_end - $benchmark_start, 4);

?>

<h2>Reference 2.0 Generation Successful</h2>
<p>Generated <?=$counter?> files in <?=$execution_time?> seconds.</p>