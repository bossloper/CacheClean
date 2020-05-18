CacheClean v1.1 - will remove old files from cache folder.

Traverses sub folders and will remove if empty. Will ignore .htaccess, index.html and certain MODX system cache files.

Can set file age for deleting, add a random factor to reduce the times it will trigger to clear the cache and set a list of folders where cache is stored.

Plugin is triggered by OnCacheUpdate  event.
