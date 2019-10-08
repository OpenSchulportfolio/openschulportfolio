<?php
# This script tries to fix most conditions after 
# upgrading from OSP 13.03 to OSP 19.10
# However, it come without warranty, use at your 
# own risk - and have a backup of your OSP
# installation ready.
#
# License: GPLv2
# 08.10.2019
# Frank Schiebel <frank@linuxmuster.net>
#
?>
<!doctype html>
<html>
<title>OSP fixsettings</title>
<style>
  body { text-align: center; padding: 150px; }
  h1 { font-size: 50px; }
  body { font: 20px Helvetica, sans-serif; color: #333; }
  article { display: block; text-align: left; width: 650px; margin: 0 auto; }
  a { color: #dc8100; text-decoration: none; }
  a:hover { color: #333; text-decoration: none; }
</style>
</header>
<body>
<p>Trying to fix your configuration...</p>
<ul>

<?php


$date=date('Ymdhis');

$settings="conf/local.php";
#$backup="conf/local.php.fixsettings-".$date;
$backup="conf/local.php.fixsettings";

require_once($settings);
$pluginkeys=array_keys ($conf['plugin'] );
$stop=0;
if (in_array("authchained", $pluginkeys)) { $stop=1;}
if (in_array("authldap", $pluginkeys)) { $stop=1;}
if (in_array("authad", $pluginkeys)) { $stop=1;}

if ( $stop == 1 ) {
    echo "</ul>";
    echo "<p>It ssems you already run this script. Will not do it again</p>";
    echo "</body></html>";
    exit();
}

copy($settings,$backup); 
echo "<li>Saved your config ($settings) to $backup</li>";

$file = fopen($settings."-tmp","w");

$lines = file($settings);
foreach ($lines as $line) {

    $line = str_replace("']['","____",$line);
    $line = str_replace("\n","",$line);
    $pattern = '/^(.+\[\')auth____(\w+)____(.+)$/U'; 
    $replacement = '${1} plugin____auth${2}____${3}'; 
    $line = preg_replace($pattern, $replacement, $line);
    $line = str_replace("' ", "'", $line);

    if (preg_match("/authtype\'\]/", $line)) {
        $parts = explode ("=", $line);
        $parts[1] = str_replace("'","", $parts[1]);
        $parts[1] = str_replace(";","", $parts[1]);
        $parts[1] = str_replace(" ","", $parts[1]);
        $parts[1] = "'auth" . $parts[1] . "';";
        $line = $parts[0] . " = " .$parts[1];
    }

    if (preg_match("/plugin____authchained____authtypes/", $line)) {
        $parts = explode ("=", $line);
        $parts[1] = str_replace(",",":", $parts[1]);
        $parts[1] = str_replace("'","", $parts[1]);
        $parts[1] = str_replace(";","", $parts[1]);
        $parts[1] = str_replace(" ","", $parts[1]);

        $methods = explode(":", $parts[1]);
        $nm = "";
        foreach ($methods as $m ) {
            $m = trim($m);
            $m = "auth" . $m .":";
            $nm .= $m;
        }
        $nm = rtrim($nm,":");
        $line = $parts[0] . " = '" .$nm . "';";
    }

    $line = str_replace("____","']['",$line);
    
    #echo $line . "<br>";
    fwrite($file,$line.PHP_EOL);
}

# Sidebar Fix:
$line='$conf[\'sidebar\'] = \'sidebar\';';
fwrite($file,$line.PHP_EOL);

fclose($file);
copy($settings."-tmp",$settings); 
echo "<li>Copied modified config to $settings.</li>";
echo "</ul>";
echo "<p><a href=\"index.php\">Open your OSP</a>";
?>
</body>
</html>
