//<?
/**
 * CacheClean
 *
 * Clean cached files
 *
 * @category plugin
 * @version 1.0
 * @author bossloper
 * @internal @properties &maxDays=Max life for cached files (days);int;56 &refreshEvery=Only refresh 1 in n times;int;5;
 * @internal @events OnCacheUpdate
 * @internal @modx_category Admin
 * @internal @installset base, sample
 */

// Clear out old cache files in the cache folder to keep cache size under control
// v1.0 - initial release

$e = &$modx->event;
if ($e->name == 'OnCacheUpdate') {
isset($refreshEvery) ? $refreshEvery=$refreshEvery : $refreshEvery=1;

  if (rand(1,$refreshEvery)==1){ // only run 1 in n times

  isset($maxDays) ? $maxtime=$maxDays*24*60*60 : $maxtime=28*24*60*60; // maximum lifetime for file
  $now = time();

  $cachePath = MODX_BASE_PATH . 'assets/cache';
  if (file_exists(realpath($cachePath))) {

    $iterator = new RecursiveIteratorIterator(new RecursiveDirectoryIterator($cachePath), RecursiveIteratorIterator::CHILD_FIRST );
    $iterator->setFlags(RecursiveDirectoryIterator::SKIP_DOTS);

    foreach ( $iterator as $path ) {
      if ($path->isDir()) { // if directory and empty then delete
        if (iterator_count($iterator->getChildren())===0) {
          rmdir($path->getPathname()); 
        }
      } else {
        if ($path->getFilename()!=='.htaccess' && $path->getFilename()!=='index.html' && $path->getFilename()!=='siteCache.php' && $path->getFilename()!=='siteHostnames.php' && $path->getFilename()!=='siteManager.php' && $path->getFilename()!=='sitePublishing.idx.php') {
          if ($now - $path->getCTime() >= $maxtime) {
            // delete old files
            unlink($path->getPathname()); 
          }
        }
      }
    }
  }

/* NOT NEEDED AS IT CLEANS OK FROM KCFINDER
  $cachePath = MODX_BASE_PATH . 'assets/' . $modx->config['thumbsDir'];
  if (file_exists(realpath($cachePath))) {

    $iterator = new RecursiveIteratorIterator(new RecursiveDirectoryIterator($cachePath), RecursiveIteratorIterator::CHILD_FIRST );
    $iterator->setFlags(RecursiveDirectoryIterator::SKIP_DOTS);

    foreach ( $iterator as $path ) {
      // if directory and empty then delete
      if ($path->isDir()) { 
        if (iterator_count($iterator->getChildren())===0) {
          rmdir($path->getPathname()); 
        }
      // else a file
      } else { 
        if ($path->getFilename()!=='.htaccess' && $path->getFilename()!=='index.html') { // ignore some files
          if ($now - $path->getCTime() >= $maxtime) {
            // delete old files
            unlink($path->getPathname()); 
          }
        }
      }
    }
  }
*/

  }

}
return true;