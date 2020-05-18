//<?php
/**
 * CacheClean
 *
 * Clear out old cache files in the cache folders to keep cache size under control.
 *
 * @category plugin
 * @version 1.1
 * @author bossloper, mplavala
 * @internal @properties &maxDays=Max life for cached files (days);int;56 &refreshEvery=Only refresh 1 in n times;int;5 &folders=Folders to clean up;text;cache;Comma separated list of folders in assets directory containing files to clean up.;
 * @internal @events OnCacheUpdate
 * @internal @modx_category Admin
 * @internal @installset base, sample
 */

define('protectedFiles', ['.htaccess', 'index.html', 'siteCache.php', 'siteHostnames.php', 'siteManager.php', 'sitePublishing.idx.php']);

$e = &$modx->Event;
switch ($e->name) {
	case "OnCacheUpdate":
		// chech the plugin variables
		isset($refreshEvery) ? $refreshEvery=$refreshEvery : $refreshEvery=1;
		isset($maxDays) ? $maxtime=$maxDays*24*60*60 : $maxtime=28*24*60*60; // maximum lifetime for file
		isset($folders) ? $folders=$folders : $folders='cache';
		
		if (rand(1,$refreshEvery) == 1){ // only run 1 in n times
			$now = time();
			foreach (explode(',', $folders) as $cacheFolder) {
				$cacheFolder = trim($cacheFolder);
				$cachePath = MODX_BASE_PATH . 'assets/' . $cacheFolder;
				if (file_exists(realpath($cachePath))) {
					$iterator = new RecursiveIteratorIterator(new RecursiveDirectoryIterator($cachePath), RecursiveIteratorIterator::CHILD_FIRST );
					$iterator->setFlags(RecursiveDirectoryIterator::SKIP_DOTS);
					foreach ($iterator as $path) {
						if ($path->isDir()) { // if directory and empty then delete
							if (iterator_count($iterator->getChildren())===0) {
								rmdir($path->getPathname()); 
							}
						} else {
							if (!in_array($path->getFilename(), protectedFiles)) {
								if ($now - $path->getCTime() >= $maxtime) {
									// delete old files
									unlink($path->getPathname()); 
								}
							}
						}
					}
				}
			}
		}
		break;
	default :
		return; // stop here
		break;
}
