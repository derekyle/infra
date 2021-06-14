<?php
$CONFIG = [
  'htaccess.RewriteBase' => '/',
  'config_is_read_only' => true,
  'memcache.local' => '\\OC\\Memcache\\APCu',
  'datadirectory' => '/data',
  'instanceid' => 'ocdblat2xgz9',
  'passwordsalt' => 'YM/RvtP6k+6+BK/9HjzV7EGodmgWkN',
  'secret' => '0gkTE6FyqqlZUAKlh3tfh7Rf8jvHodbUR8cKOrvCADjTBH3B',
  'overwritehost' => 'cloud.dc5.in',
  // 'overwriteprotocol' => 'https',
  'trusted_domains' => 
    [
      'localhost:9999',
      'cloud.dc5.in:80',
      'cloud.dc5.in:443',
      'cloud.dc5.in',
    ],
  'trusted_proxies' => 
    [
      '172.18.0.0/16',
      '192.168.1.2',
    ],
  'dbtype' => 'mysql',
  'version' => '21.0.2.1',
  'overwrite.cli.url' => 'https://cloud.dc5.in',
  'dbname' => 'nextcloud',
  'dbhost' => 'nextcloud-db',
  'dbport' => '3306',
  'dbtableprefix' => 'oc_',
  'mysql.utf8mb4' => true,
  'dbuser' => 'nextcloud',
  'dbpassword' => 'Ntr52z8A0wquhH76422gobBNtfeesjnz',
  'installed' => true,
  'maintenance' => false,
  'loglevel' => 1,
];