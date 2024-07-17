'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "c26bfb26cec81efb2577c19a7ead51af",
"assets/AssetManifest.bin.json": "ca31688a760173718dde147b0a109e8c",
"assets/AssetManifest.json": "8a811bf58170c03b46bb6f32ccdfb58f",
"assets/assets/backend.png": "b6f97a0bb77c12636d32a57efacd1d10",
"assets/assets/carrent.png": "de7775e7e769abcd0478a0f32554addf",
"assets/assets/close.svg": "333c66a5dff1d7cc3968f6e7af4c5b2c",
"assets/assets/creator.png": "2fb53dc768e9f2b21e8eba0b31c50f1d",
"assets/assets/css.png": "562320553594c7fc047b9d0cf55233ab",
"assets/assets/docker.png": "48daa53dc2e75aa18777f55eb610c4f1",
"assets/assets/figma.png": "897539713a3105b6ee3b797851459130",
"assets/assets/git.png": "91e38c1fb4b2410c06d56542d09086d0",
"assets/assets/github.png": "69b7e397e348747e802b90e5eb0bfbd4",
"assets/assets/herobg.png": "823cad50e07bcea74f9dee734ce3819a",
"assets/assets/html.png": "ff5aca29bd447b791c743ad0075e5aa3",
"assets/assets/index.js": "ac79360bcb0252e8beedc45467f22601",
"assets/assets/javascript.png": "c1f39577de277de6ff5f654e996f1028",
"assets/assets/jobit.png": "261dcd8d434a22a8ce067dcfe77160b8",
"assets/assets/logo.svg": "6ed081346b52940c41917baf7c5a04e0",
"assets/assets/menu.png": "64627fc3a824c98bd23310dbb7224293",
"assets/assets/menu.svg": "d4926d3f2dc6c41bdcb19909d4ae93c8",
"assets/assets/mobile.png": "9537758db1d756949a924fcd4404895f",
"assets/assets/mongodb.png": "1fb83876d8f00b2f67374b05838d09d2",
"assets/assets/nodejs.png": "9e79e8c3cdcccfc06c9840883f15b2c1",
"assets/assets/pic1.jpeg": "808c191b4186972c6c4444e886d131fd",
"assets/assets/pic2.jpeg": "cc714c1aa22e72c1ed25c452257047b5",
"assets/assets/pic3.jpeg": "bf94161452269896374ddcb701c3f8d8",
"assets/assets/pic4.jpeg": "bea8b8779ebbf4c76db6b9fdb0d8957c",
"assets/assets/pic5.jpeg": "026d4afcb5bed51b2b5dabadc2e2d1dc",
"assets/assets/pic6.jpeg": "9312fffaff98de269e1e34d42cb16a78",
"assets/assets/pic7.jpeg": "b1a9cd00c02c104c791129b861c36be5",
"assets/assets/pic8.jpeg": "f442c1846840a92c2f78f5436f953f59",
"assets/assets/react.svg": "f0402b67b6ce880f65666bb49e841696",
"assets/assets/reactjs.png": "f70556624353bdc24ec1e69a2d979630",
"assets/assets/redux.png": "31f3e54c7d49efed1b6a03edc4476ba2",
"assets/assets/star.mp4": "468fc58644e4a7ec33630ce98731e55e",
"assets/assets/tailwind.png": "c73f9afce409c73a75bb36ce9da84a94",
"assets/assets/threejs.svg": "d75c09a5a967d4425a175b6bfe5ca4e5",
"assets/assets/tripguide.png": "5eb0d3c9dd99525d0aa2b584dd573133",
"assets/assets/typescript.png": "6a41ab01fd39f8bae6bad97ef7109cf9",
"assets/assets/web.png": "f59df0f5b55cde9fc8e02c3dfe1e3540",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/fonts/MaterialIcons-Regular.otf": "9e623aee84bfc924faf686363927beb8",
"assets/NOTICES": "3fa762ad20eca8eb372116267636d3d5",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "391ff5f9f24097f4f6e4406690a06243",
"assets/packages/google_places_flutter/images/location.json": "afa33acf2c340246c901718f4efdfccf",
"assets/packages/model_viewer_plus/assets/model-viewer.min.js": "a9dc98f8bf360be897a0898a7395f905",
"assets/packages/model_viewer_plus/assets/template.html": "8de94ff19fee64be3edffddb412ab63c",
"assets/packages/wakelock_plus/assets/no_sleep.js": "7748a45cd593f33280669b29c2c8919a",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "738255d00768497e86aa4ca510cce1e1",
"canvaskit/canvaskit.js.symbols": "74a84c23f5ada42fe063514c587968c6",
"canvaskit/canvaskit.wasm": "9251bb81ae8464c4df3b072f84aa969b",
"canvaskit/chromium/canvaskit.js": "901bb9e28fac643b7da75ecfd3339f3f",
"canvaskit/chromium/canvaskit.js.symbols": "ee7e331f7f5bbf5ec937737542112372",
"canvaskit/chromium/canvaskit.wasm": "399e2344480862e2dfa26f12fa5891d7",
"canvaskit/skwasm.js": "5d4f9263ec93efeb022bb14a3881d240",
"canvaskit/skwasm.js.symbols": "c3c05bd50bdf59da8626bbe446ce65a3",
"canvaskit/skwasm.wasm": "4051bfc27ba29bf420d17aa0c3a98bce",
"canvaskit/skwasm.worker.js": "bfb704a6c714a75da9ef320991e88b03",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter.js": "383e55f7f3cce5be08fcf1f3881f585c",
"flutter_bootstrap.js": "e91649a72a194fd680d2b1c63e081c73",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "a6b644dda9e7ad645454872800d076cc",
"/": "a6b644dda9e7ad645454872800d076cc",
"main.dart.js": "094966fb6646ab03f67c4ffac6e171b9",
"manifest.json": "1de520f081855403b53c7bc26629571e",
"version.json": "9b316a15c3f753a2566496b36f12b4cd"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
