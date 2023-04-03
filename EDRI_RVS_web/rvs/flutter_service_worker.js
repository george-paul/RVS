'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "assets/AssetManifest.json": "6e7cf22d26950e15d8858cd75cfca3ec",
"assets/assets/fonts/Arvo-Bold.ttf": "ab1dabbd8ffd289a5c35cb151879e987",
"assets/assets/fonts/Arvo-BoldItalic.ttf": "a53d4514f91e2a95842412c4d3954dd0",
"assets/assets/fonts/Arvo-Italic.ttf": "4d7f205bc8a4a7e98c219a1427999533",
"assets/assets/fonts/Arvo-Regular.ttf": "afb50701726581f5f817faab8f7cf1b7",
"assets/assets/images/ihub.png": "4672e04e0f687b7f001c5b6f549cc8c5",
"assets/assets/images/iiit.png": "b2bd9e6b52d6f6468ae67f3b6f20678a",
"assets/assets/images/inai.png": "7046a1da73b4aa14a36b6613b8547d36",
"assets/assets/images/surveyImage0.png": "fac84a977d727fdbfcc0d4f6f933caba",
"assets/assets/images/surveyImage1.png": "50f6626550287bcd33e5792a0e0bcfb1",
"assets/assets/images/surveyImage2.png": "af1363dd1b9e355066dcca6e7f7555aa",
"assets/assets/images/surveyImage3.png": "2d59a95c10ce770fc7f9ae58afeeb59f",
"assets/assets/images/surveyImage4.png": "cf2b513e3fbd57ec2194a2200c02ca18",
"assets/assets/images/surveyImage5.png": "155e9de401515776870c5248915e123d",
"assets/assets/images/surveyImage6.png": "8f8af26ef20846bc39f2b63c006b8a64",
"assets/FontManifest.json": "687bba46a655d9ed2d1a6f98d7aed813",
"assets/fonts/MaterialIcons-Regular.otf": "95db9098c58fd6db106f1116bae85a0b",
"assets/NOTICES": "775dd92a938af32a4f4043761e236e66",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "6d342eb68f170c97609e9da345464e5e",
"assets/packages/fluttertoast/assets/toastify.css": "a85675050054f179444bc5ad70ffc635",
"assets/packages/fluttertoast/assets/toastify.js": "e7006a0a033d834ef9414d48db3be6fc",
"assets/shaders/ink_sparkle.frag": "998c7d2a66ae16afab37626e752cf0ea",
"canvaskit/canvaskit.js": "2bc454a691c631b07a9307ac4ca47797",
"canvaskit/canvaskit.wasm": "bf50631470eb967688cca13ee181af62",
"canvaskit/profiling/canvaskit.js": "38164e5a72bdad0faa4ce740c9b8e564",
"canvaskit/profiling/canvaskit.wasm": "95a45378b69e77af5ed2bc72b2209b94",
"flutter.js": "f85e6fb278b0fd20c349186fb46ae36d",
"icons/android-icon-144x144.png": "b1c7a3c15e43bca3c47eb73e5e12d46c",
"icons/android-icon-192x192.png": "17bdc257ad9aea6954f44892dc94bc6f",
"icons/android-icon-36x36.png": "730a4a280f3d4b00bcc25ffb49ec661f",
"icons/android-icon-48x48.png": "a8e892a993dd2c62938a7487c3bbd83e",
"icons/android-icon-72x72.png": "78d52cf10fe22928403ae7847f975a6b",
"icons/android-icon-96x96.png": "188a410a77a62df610e3844cd534fe52",
"icons/apple-icon-114x114.png": "0c023b79912656da848ca128b412bc80",
"icons/apple-icon-120x120.png": "2018a71e20cc184ccf5ef2c34fb4af8c",
"icons/apple-icon-144x144.png": "b1c7a3c15e43bca3c47eb73e5e12d46c",
"icons/apple-icon-152x152.png": "84a103ea6cbeac777f39ad82ebfa627b",
"icons/apple-icon-180x180.png": "866b5c30e60ca9c2547a5337e185c6ac",
"icons/apple-icon-57x57.png": "762a4fc3784dc14a9a6f803b6881a35a",
"icons/apple-icon-60x60.png": "8151f0ba4c391fe41df7bdbd70c3b660",
"icons/apple-icon-72x72.png": "78d52cf10fe22928403ae7847f975a6b",
"icons/apple-icon-76x76.png": "97ff6780b523ef05d53f47188378d93d",
"icons/apple-icon-precomposed.png": "44bd8204cc7a72d32ef188b04daa401b",
"icons/apple-icon.png": "44bd8204cc7a72d32ef188b04daa401b",
"icons/favicon-16x16.png": "3826affb989f7253e5805483992384f3",
"icons/favicon-32x32.png": "42c532cce1306b736c7d275ad5021085",
"icons/favicon-96x96.png": "188a410a77a62df610e3844cd534fe52",
"icons/favicon.ico": "7bc457f06f7e93b6ba11f9fc644aaed5",
"icons/logo.png": "b22ee3d7a4e497126b5ef442fb605e1d",
"icons/ms-icon-144x144.png": "b1c7a3c15e43bca3c47eb73e5e12d46c",
"icons/ms-icon-150x150.png": "405d48879a0ad5bea060501ca3289d22",
"icons/ms-icon-310x310.png": "88aebc6edeecf51caae6edd05908c714",
"icons/ms-icon-70x70.png": "06099bf10f6d02e870269a896b639bf4",
"index.html": "1259b8302f985d9fb6145ad6bebca0f7",
"/": "1259b8302f985d9fb6145ad6bebca0f7",
"main.dart.js": "e5dc9abe9e6f1bed65872a14dfaf2af5",
"manifest.json": "a8a336de15d9386f413f6af924974609",
"version.json": "8c923981de73fb7153e176d7fa459939"
};

// The application shell files that are downloaded before a service worker can
// start.
const CORE = [
  "main.dart.js",
"index.html",
"assets/AssetManifest.json",
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
